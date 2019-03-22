/**
 * tile image in QuPath and send tiles to imageJ for saving as TIFFs
 *
 * @author: C Heiser
 * Mar2019
 */

import ij.IJ
import ij.ImagePlus
import qupath.imagej.gui.IJExtension
import qupath.imagej.helpers.IJTools
import qupath.lib.scripting.QPEx
import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder
import qupath.imagej.plugins.ImageJMacroRunner
import qupath.lib.plugins.parameters.ParameterList
import qupath.lib.images.servers.ImageServer
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import java.awt.image.BufferedImage

int tileWidthPixels = 1000  // Width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels // Width of (final) output tile in pixels
double downsample = 10      // Downsampling used when extracting tiles
String format = "tif"       // Format of the output image - TIFF or ZIP is best for ImageJ to preserve pixel sizes
def dirOutput = getQuPath().getDialogHelper().promptForDirectory(null) // prompt user for output directory

int maxErrors = 20          // Maximum number of errors... to avoid trying something doomed forever
int minImageDimension = 20  // If a tile will have a width or height < minImageDimension, it will be skipped

// Check we have an output directory
if (dirOutput == null) {
    println("Be sure to set the 'dirOutput' variable!")
    return
}

// Initialize error counter
int nErrors = 0

// Get the image server
ImageServer<BufferedImage> serverOriginal = QP.getCurrentImageData().getServer()

// Get an ImagePlus server
ImagePlusServer server = ImagePlusServerBuilder.ensureImagePlusWholeSlideServer(serverOriginal)

// Make sure that ImageJ is open
IJExtension.getImageJInstance()

// Ensure convert the format to a file extension
String ext
if (format.startsWith("."))
    ext = format.substring(1).toLowerCase()
else
    ext = format.toLowerCase()

// Extract useful variables
String path = server.getPath()
String serverName = serverOriginal.getShortServerName()
double tileWidth = tileWidthPixels * downsample
double tileHeight = tileHeightPixels * downsample

// Loop through the image - including z-slices (even though there's normally only one...)
int counter = 0;
for (int z = 0; z < server.nZSlices(); z++) { 
    for (double y = 0; y < 1; y += tileHeight) { // replace number with server.getHeight()

        // Compute integer y coordinates
        int yi = (int)(y + 0.5)
        int y2i = (int)Math.min((int)(y + tileHeight + 0.5), server.getHeight());
        int hi = y2i - yi

        // Check if we requesting a region that is too small
        if (hi / downsample < minImageDimension) {
            println("Image dimension < " + minImageDimension + " - skipping row")
            continue
        }

        for (double x = 0; x < server.getWidth(); x += tileWidth) { 

            // Compute integer x coordinates
            int xi = (int)(x + 0.5)
            int x2i = (int)Math.min((int)(x + tileWidth + 0.5), server.getWidth());
            int wi = x2i - xi

            // Create request
            RegionRequest request = RegionRequest.createInstance(path, downsample, xi, yi, wi, hi, z, 0)

            // Check if we requesting a region that is too small
            if (wi / downsample < minImageDimension) {
                // Only print warning if we've not skipped this before
                if (y > 0)
                    println("Image dimension < " + minImageDimension + " - skipping column")
                continue
            }

            // Surround with try/catch in case the server gives us trouble
            try {
                // Read the image region
                ImagePlus imp = server.readImagePlusRegion(request).getImage(false)
                // Show the image
                imp.show()
                println("Sending tile " + counter + " to ImageJ")

                // Get a suitable file name
                //String name = String.format("%s (d=%.2f, x=%d, y=%d, w=%d, h=%d, z=%d).%s", serverName, downsample, xi, yi, wi, hi, z, ext)
                // Create an output file
                //File file = new File(dirOutput, name)
                // Save the image
                //IJ.save(imp, file.getAbsolutePath())
                // Print progress
                counter++
                //println("Written tile " + counter + " to " + file.getAbsolutePath())
            } catch (Exception e) {
                // Check if we have had a sufficient number of errors to just give up
                nErrors++;
                if (nErrors > maxErrors) {
                    println("Maximum number of errors exceeded - aborting...")
                    return
                }
                e.printStackTrace()
            }
        }
    }
}