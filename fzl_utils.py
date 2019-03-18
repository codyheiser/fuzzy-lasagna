# fuzzy-lasagna IMS analysis objects

# @author: C Heiser
# March 2019

# packages for reading in data files
import os
# basics
import numpy as np
import pandas as pd
# plotting packages
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(style = 'white')
import pptk


def threshold(mat, thresh=0.5, dir='above'):
	'''replace all values in a matrix above or below a given threshold with np.nan'''
	a = np.ma.array(mat, copy=True)
	mask=np.zeros(a.shape, dtype=bool)
	if dir=='above':
		mask |= (a > thresh).filled(False)

	elif dir=='below':
		mask |= (a < thresh).filled(False)

	else:
		raise ValueError("Choose 'above' or 'below' for threshold direction (dir)")

	a[~mask] = np.nan
	return a

def bin_threshold(mat, threshmin=None, threshmax=0.5):
	'''
	generate binary segmentation from probabilities
		thresmax = value on [0,1] to assign binary IDs from probabilities. values higher than threshmax -> 1.
			values lower than thresmax -> 0.
	'''
	a = np.ma.array(mat, copy=True)
	mask = np.zeros(a.shape, dtype=bool)
	if threshmin is not None:
		mask |= (a < threshmin).filled(False)

	if threshmax is not None:
		mask |= (a > threshmax).filled(False)

	a[mask] = 1
	a[~mask] = 0
	return a

def to_coord_2D(mat):
	'''convert and m by n np.array to a pd.DataFrame with x, y coordinates and intensity values (i)'''
	assert len(mat.shape)==2, 'need 2D array'
	coord = {'x':[], 'y':[], 'i':[]}

	for y in range(0, mat.shape[0]):
		for x in range(0, mat.shape[1]):
			coord['x'].append(x)
			coord['y'].append(y)
			coord['i'].append(mat[y,x])

	return pd.DataFrame(coord)


def to_coord_3D(mat):
	'''convert and m by n by p np.array to a pd.DataFrame with x, y, z coordinates and intensity values (i)'''
	assert len(mat.shape)==3, 'need 3D array'
	coord = {'x':[], 'y':[], 'z':[], 'i':[]}
	for z in range(0, mat.shape[2]):
		for y in range(0, mat.shape[0]):
			for x in range(0, mat.shape[1]):
				coord['x'].append(x)
				coord['y'].append(y)
				coord['z'].append(z)
				coord['i'].append(mat[y,x,z])

	return pd.DataFrame(coord)


class ilastik_mask():
	'''
	Object containing segmentation masks exported from ilastik ML software
	'''
	def __init__(self, data):
		'''data = np.ndarray containing segment IDs from ilastik'''
		self.raw = data

	def get_points(self, seg_ID=1):
		'''get x, y coordinates and value ('intensity') for each item in data array; return as pd.DataFrame'''
		if isinstance(self, seg):
			dat = self.data 

		elif isinstance(self, prob):
			dat = self.data[seg_ID]

		return to_coord_2D(dat)

	@classmethod
	def from_file(cls, datafile):
		'''initialize object from outside file (datafile)'''
		filetype = os.path.splitext(datafile)[1] # extract file extension to save as metadata

		if filetype == '.zip': # if compressed, open the file and update filetype
			zf = zipfile.ZipFile(datafile)
			datafile = zf.open(os.path.splitext(datafile)[0]) # update datafile with zipfile object
			filetype = os.path.splitext(os.path.splitext(datafile)[0])[1] # update filetype


		if filetype == '.npy': # read numpy arrays
			data = np.load(datafile)

		elif filetype == '.csv': # read comma-delimited tables
			data = np.genfromtxt(datafile, delimiter=',')

		elif filetype == '.txt': # read tab-delimited text files
			data = np.genfromtxt(datafile, delimiter='\t')


		if filetype == '.gz': # if file is g-zipped, read accordingly
			filetype = os.path.splitext(os.path.splitext(datafile)[0])[1] # update filetype

			if filetype == '.npy': # read numpy arrays
				data = np.load(gzip.open(datafile))

			elif filetype == '.csv': # read comma-delimited tables
				data = np.genfromtxt(gzip.open(datafile), delimiter=',')

			elif filetype == '.txt': # read tab-delimited text files
				data = np.genfromtxt(gzip.open(datafile), delimiter='\t')

		return cls(data)


class seg(ilastik_mask):
	'''
	Object containing 'Simple Segmentation' export from ilastik.
	Values should be integers on [1, len(segments)] where number of segments are defined in ilastik (usually 2-3).
	'''
	def __init__(self, data):
		ilastik_mask.__init__(self, data) # inherits from ilastik_mask object
		self.data = np.squeeze(self.raw) # squeeze into 2D
		self.dims = self.data.shape # dimensions of image in pixels
		self.seg_IDs = np.unique(self.data) # segment IDs present in file

	def plot(self):
		plt.imshow(self.data)
		plt.tick_params(labelbottom=False, labelleft=False)
		sns.despine()
		plt.show()
		plt.close()


class prob(ilastik_mask):
	'''
	Object containing 'Probabilities' export from ilastik.
	Values should be on [0, 1] that describe fractional probability of belonging to segment groups defined in ilastik.
	'''
	def __init__(self, data):
		ilastik_mask.__init__(self, data) # inherits from ilastik_mask object
		self.dims = self.raw.shape # get all three dimensions of object (ID, pixel, pixel)
		self.data = {} # data dumped into dictionary on third dimension, which is different segment IDs
		for dim in range(1,self.dims[0]+1):
			self.data[dim] = self.raw[dim-1,:,:]

		self.seg_IDs = np.array(list(self.data.keys()), dtype='uint8')

	def prob_threshold(self, seg_ID=1, threshmin=None, threshmax=0.5, plot_out=False):
		'''
		generate binary segmentation from probabilities
			threshmax = value on [0,1] to assign seg_IDs from probabilities. values higher than threshmax for seg_ID -> 1.
				values lower than thresmax for seg_ID -> 0.
		'''
		a = bin_threshold(mat=self.data[seg_ID], threshmin=threshmin, threshmax=threshmax)

		if plot_out:
			plt.imshow(a)
			plt.tick_params(labelbottom=False, labelleft=False)
			sns.despine()
			plt.show()
			plt.close()

		return a

	def plot(self, seg_ID=1):
		plt.imshow(self.data[seg_ID])
		plt.tick_params(labelbottom=False, labelleft=False)
		sns.despine()
		plt.show()
		plt.close()


class mask_stack():
	'''stack of ilastik_mask objects for 3D mapping and visualization'''
	def __init__(self, masks):
		self.data = {} # data dumped into dictionary where keys are layers in stack
		self.dims = {}
		self.seg_IDs = {} 
		for layer in range(0,len(masks)):
			self.data[layer] = masks[layer].data 
			self.dims[layer] = masks[layer].dims
			self.seg_IDs[layer] = masks[layer].seg_IDs

	def visualize(self, layer_step=50, seg_ID=1):
		'''visualize stack in 3D using `pptk`. layer_step = how to scale z-axis for separation between layers'''
		if isinstance(self, seg_stack):
			points = self.points.copy(deep=True)

		elif isinstance(self, prob_stack):
			points = self.points[seg_ID].copy(deep=True)

		points['z'] = points['z']*layer_step
		v = pptk.viewer(points[['x','y','z']])
		v.attributes(points['i'])
		v.set(point_size=0.0002)


class seg_stack(mask_stack):
	def __init__(self, masks):
		mask_stack.__init__(self, masks)
		self.stacked = np.dstack(list(self.data.values())) # make giant 3D numpy array
		self.points = to_coord_3D(self.stacked)


class prob_stack(mask_stack):
	def __init__(self, masks):
		mask_stack.__init__(self, masks)
		self.stacked = {}
		self.points = {}

		for ID in np.unique(np.concatenate(list(self.seg_IDs.values()))):
			ID_data = []
			for layer in range(0, len(masks)):
				ID_data.append(self.data[layer][ID])

			self.stacked[ID] = np.dstack(ID_data)# make giant 3D numpy array for each seg_ID
			self.points[ID] = to_coord_3D(self.stacked[ID])
