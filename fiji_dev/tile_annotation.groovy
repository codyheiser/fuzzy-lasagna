// tile whole-slide image in QuPath and create annotations for each tile
//
// @author: C Heiser
// Apr19

import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder
import qupath.lib.objects.PathAnnotationObject
import qupath.lib.objects.classes.PathClassFactory
import qupath.lib.roi.RectangleROI
import qupath.lib.images.servers.ImageServer
import qupath.lib.scripting.QP
import qupath.lib.scripting.QPEx
import java.awt.image.BufferedImage

// set parameters for tiling QuPath image and IJ analysis
int tileWidthPixels = 1000              // width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels  // Width of (final) output tile in pixels
double downsample = 2                   // downsampling used when extracting tiles
int minImageDimension = 50              // if a tile will have a width or height < minImageDimension, it will be skipped

// Get main data structures
def imageData = QPEx.getCurrentImageData()
def server = imageData.getServer()
double tileWidth = tileWidthPixels * downsample
double tileHeight = tileHeightPixels * downsample

// loop through the image - including z-slices (even though there's normally only one...)
int counter = 0;
for (int z = 0; z < server.nZSlices(); z++) { 
    for (double y = 0; y < server.getHeight(); y += 0.8*tileHeight) { 

        // compute integer y coordinates
        int yi = (int)(y + 0.5)
        int y2i = (int)Math.min((int)(y + tileHeight + 0.5), server.getHeight());
        int hi = y2i - yi

        // check if we are requesting a region that is too small
        if (hi / downsample < minImageDimension) {
            println("Image dimension < " + minImageDimension + " - skipping row")
            continue
        }

        for (double x = 0; x < server.getWidth(); x += 0.8*tileWidth) { 

            // compute integer x coordinates
            int xi = (int)(x + 0.5)
            int x2i = (int)Math.min((int)(x + tileWidth + 0.5), server.getWidth());
            int wi = x2i - xi

            // check if we requesting a region that is too small
            if (wi / downsample < minImageDimension) {
                // Only print warning if we've not skipped this before
                if (y > 0)
                    println("Image dimension < " + minImageDimension + " - skipping column")
                continue
            }
            
            // Create a new Rectangle ROI
            def roi = new RectangleROI(xi, yi, wi, hi)

            // Create & new annotation & add it to the object hierarchy
            def annotation = new PathAnnotationObject(roi, PathClassFactory.getPathClass("Region"))
            imageData.getHierarchy().addPathObject(annotation, false)
            
            // print progress
            println("Creating annotation for tile " + counter)
            counter++
        }
    }
}

println("Done!");
