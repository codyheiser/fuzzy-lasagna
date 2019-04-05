# -*- coding: utf-8 -*-
'''
Identify segments in image file based on RGB channel

@author: C Heiser
Apr2019

usage: watershed.py [-h] -i IMAGE -c CHANNEL

Detect particles in image using watershed function

optional arguments:
  -h, --help            show this help message and exit
  -i IMAGE, --image IMAGE
                        path to input image
  -c CHANNEL, --channel CHANNEL
                        channel to perform watershed segmentation on ('r'=2, 'g'=1, or 'b'=0)
'''
import argparse
import numpy as np
# image analysis packages
from skimage.feature import peak_local_max
from skimage.morphology import watershed
from scipy import ndimage
import imutils
import cv2
# plotting packages
import matplotlib.pyplot as plt
import seaborn as sns; sns.set(style = 'white')


def make_fig(img, name='Figure', size=(7,7)):
	'''output image using matplotlib'''
	plt.figure(name, figsize=size)
	plt.imshow(img)
	plt.tick_params(labelbottom=False, labelleft=False)
	sns.despine()

def run_watershed(img, bin_mask):
	'''identify segments using watershed function'''
	# compute the exact Euclidean distance from every binary pixel to the nearest zero pixel, then find peaks
	D = ndimage.distance_transform_edt(bin_mask)
	localMax = peak_local_max(D, indices=False, min_distance=20, labels=bin_mask)

	# perform a connected component analysis on the local peaks, using 8-connectivity, then apply the Watershed algorithm
	markers = ndimage.label(localMax, structure=np.ones((3, 3)))[0]
	labels = watershed(-D, markers, mask=bin_mask)
	print("[INFO] {} unique segments found".format(len(np.unique(labels)) - 1))

	# loop over the unique labels returned by the Watershed algorithm
	for label in np.unique(labels):
		# if the label is zero, we are examining the 'background', so simply ignore it
		if label == 0:
			continue

		# otherwise, allocate memory for the label region and draw it on the mask
		mask = np.zeros(bin_mask.shape, dtype="uint8")
		mask[labels == label] = 255

		# detect contours in the mask and grab the largest one
		cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
		cnts = imutils.grab_contours(cnts)
		c = max(cnts, key=cv2.contourArea)

		# draw a circle enclosing the object
		((x, y), r) = cv2.minEnclosingCircle(c)
		cv2.circle(img, (int(x), int(y)), int(r), (0, 255, 0), 2)
		cv2.putText(img, "#{}".format(label), (int(x) - 10, int(y)), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

	return img


if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Detect particles in image using watershed function")
	parser.add_argument("-i", "--image", required=True, type=str, help="path to input image")
	parser.add_argument("-c", "--channel", required=True, type=int, help="channel to perform watershed segmentation on ('r'=2, 'g'=1, or 'b'=0)")
	args = parser.parse_args()

	# load the image and perform Gaussian blur filtering
	image = cv2.imread(args.image)
	blur = cv2.GaussianBlur(image,(5,5),0)
	make_fig(cv2.cvtColor(image, cv2.COLOR_BGR2RGB), name='Input')

	# grab the desired channel from the blurred image, then apply Otsu's thresholding
	thresh = cv2.threshold(blur[:,:,args.channel], 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)[1]
	make_fig(cv2.cvtColor(thresh, cv2.COLOR_BGR2RGB), name='Threshold')

	# identify segments and markup original image
	image = run_watershed(image, thresh)
	# show the output image
	make_fig(cv2.cvtColor(image, cv2.COLOR_BGR2RGB), name='Markup')

	plt.show('all')
