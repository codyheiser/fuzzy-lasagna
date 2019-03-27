// tile whole-slide image in QuPath and save as brightness-adjusted, composite, 3-channel TIFF using ImageJ
// @author: C Heiser
// Mar19

import ij.IJ
import ij.ImagePlus
import qupath.imagej.gui.IJExtension
import qupath.imagej.helpers.IJTools
import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder
import qupath.lib.scripting.QPEx
import qupath.lib.plugins.parameters.ParameterList
import qupath.lib.images.servers.ImageServer
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import java.awt.image.BufferedImage

int tileWidthPixels = 1000  // width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels // Width of (final) output tile in pixels
double downsample = 4      // downsampling used when extracting tiles
String format = "tif"       // format of the output image - TIFF or ZIP is best for ImageJ to preserve pixel sizes
def dirOutput = getQuPath().getDialogHelper().promptForDirectory(null) // prompt user for output directory

int maxErrors = 20          // maximum number of errors... to avoid trying something doomed forever
int minImageDimension = 20  // if a tile will have a width or height < minImageDimension, it will be skipped

// check we have an output directory
if (dirOutput == null) {
    println("Be sure to set the 'dirOutput' variable!")
    return
}

// initialize error counter
int nErrors = 0

// get the image server
ImageServer<BufferedImage> serverOriginal = QP.getCurrentImageData().getServer()

// get an ImagePlus server
ImagePlusServer server = ImagePlusServerBuilder.ensureImagePlusWholeSlideServer(serverOriginal)

// make sure that ImageJ is open
IJExtension.getImageJInstance()

// ensure convert the format to a file extension
String ext
if (format.startsWith("."))
    ext = format.substring(1).toLowerCase()
else
    ext = format.toLowerCase()

// extract useful variables
String path = server.getPath()
String serverName = serverOriginal.getShortServerName()
double tileWidth = tileWidthPixels * downsample
double tileHeight = tileHeightPixels * downsample

// loop through the image - including z-slices (even though there's normally only one...)
int counter = 0;
for (int z = 0; z < server.nZSlices(); z++) { 
    for (double y = 0; y < 1; y += tileHeight) { // replace number with server.getHeight()

        // compute integer y coordinates
        int yi = (int)(y + 0.5)
        int y2i = (int)Math.min((int)(y + tileHeight + 0.5), server.getHeight());
        int hi = y2i - yi

        // check if we are requesting a region that is too small
        if (hi / downsample < minImageDimension) {
            println("Image dimension < " + minImageDimension + " - skipping row")
            continue
        }

        for (double x = 0; x < 1; x += tileWidth) { // replace number with server.getWidth()

            // compute integer x coordinates
            int xi = (int)(x + 0.5)
            int x2i = (int)Math.min((int)(x + tileWidth + 0.5), server.getWidth());
            int wi = x2i - xi

            // create request
            RegionRequest request = RegionRequest.createInstance(path, downsample, xi, yi, wi, hi, z, 0)

            // check if we requesting a region that is too small
            if (wi / downsample < minImageDimension) {
                // Only print warning if we've not skipped this before
                if (y > 0)
                    println("Image dimension < " + minImageDimension + " - skipping column")
                continue
            }

            // surround with try/catch in case the server gives us trouble
            try {
                // read the image region
                println("Sending tile " + counter + " to ImageJ")
                ImagePlus imp = server.readImagePlusRegion(request).getImage(false)
                // show the image
                imp.show()

                // process 3-channel image to make it pretty for ilastik
                imp = IJ.getImage();

                // get composite of three channels
                IJ.run("Make Composite", "display=Composite");

                // adjust brightness and contrast to make pretty export image
                IJ.run("Brightness/Contrast...");
                IJ.setMinAndMax(imp, 0, 65000);
                IJ.run(imp, "Next Slice [>]", "");
                IJ.setMinAndMax(imp, 0, 13000);
                IJ.run(imp, "Next Slice [>]", "");
                IJ.setMinAndMax(imp, 0, 12000);
                IJ.run(imp, "Apply LUT", "");

                // get a suitable file name
                String name = String.format("%s (d=%.2f, x=%d, y=%d, w=%d, h=%d, z=%d).%s", serverName, downsample, xi, yi, wi, hi, z, ext)
                
                // create an output file
                File file = new File(dirOutput, name)
                
                // save the image
                IJ.save(imp, file.getAbsolutePath())
                
                // print progress
                counter++
                println("Written tile " + counter + " to " + file.getAbsolutePath())

            } catch (Exception e) {
                // check if we have had a sufficient number of errors to just give up
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