# fuzzy-lasagna IMS analysis objects

# @author: C Heiser
# March 2019

# packages for reading in data files
import os
# basics
import numpy as np
# plotting packages
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(style = 'white')


class ilastik_mask():
	'''
	Object containing segmentation masks exported from ilastik ML software
	'''
	def __init__(self, data):
		'''data = np.ndarray containing segment IDs from ilastik'''
		self.raw = data

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
	Values should be float on [0, 1] that describe fractional probability of belonging to segment groups defined in ilastik.
	'''
	def __init__(self, data):
		ilastik_mask.__init__(self, data) # inherits from ilastik_mask object
		self.dims = self.raw.shape # get all three dimensions of object (ID, pixel, pixel)
		self.data = {} # data dumped into dictionary on third dimension, which is different segment IDs
		for dim in range(1,self.dims[0]+1):
			self.data[dim] = self.raw[dim-1,:,:]

		self.seg_IDs = np.array(list(self.data.keys()), dtype='uint8')

	def threshold(self, seg_ID, threshmin=None, threshmax=None, plot_out=False):
		'''
		generate binary segmentation from probabilities
			thresmax = value on [0,1] to assign seg_IDs from probabilities. values higher than threshmax for seg_ID -> 1.
				values lower than thresmax for each seg_ID -> 0.
		'''
		a = np.ma.array(self.data[seg_ID], copy=True)
		mask = np.zeros(a.shape, dtype=bool)
		if threshmin is not None:
			mask |= (a < threshmin).filled(False)

		if threshmax is not None:
			mask |= (a > threshmax).filled(False)

		a[mask] = 1
		a[~mask] = 0

		if plot_out:
			plt.imshow(a)
			plt.tick_params(labelbottom=False, labelleft=False)
			sns.despine()
			plt.show()
			plt.close()

		return a

	def plot(self, seg_ID = 1):
		plt.imshow(self.data[seg_ID])
		plt.tick_params(labelbottom=False, labelleft=False)
		sns.despine()
		plt.show()
		plt.close()
