/**
 * tile image in QuPath and send tiles to imageJ for analysis
 *
 * @author: C Heiser
 * Mar2019
 */

import qupath.lib.objects.PathAnnotationObject
import qupath.lib.objects.classes.PathClassFactory
import qupath.lib.roi.RectangleROI
import qupath.lib.scripting.QPEx

// Define the size of the region to create
//double sizeMicrons = 200.0

// Get main data structures
def imageData = QPEx.getCurrentImageData()
def server = imageData.getServer()

// Get dimensions of image in pixels
def pixel_h = server.getHeight()
def pixel_w = server.getWidth()

// Get the current viewer & the location of the pixel currently in the center
def viewer = QPEx.getCurrentViewer()
double cx = viewer.getCenterPixelX()
double cy = viewer.getCenterPixelY()

// Create a new Rectangle ROI
def roi = new RectangleROI(cx-pixel_w/2, cy-pixel_h/2, pixel_w, pixel_h)

// Create & new annotation & add it to the object hierarchy
def annotation = new PathAnnotationObject(roi, PathClassFactory.getPathClass("Region"))
imageData.getHierarchy().addPathObject(annotation, false)


//for (annotation in getAnnotationObjects()) {
//    roi = annotation.getROI()
//    print(roi)
//}
