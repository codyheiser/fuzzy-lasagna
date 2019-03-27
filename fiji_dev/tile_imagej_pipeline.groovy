// tile whole-slide image in QuPath and send to ImageJ for analysis
// @author: C Heiser
// Mar19

import ij.IJ
import ij.ImagePlus
import ij.WindowManager
import ij.plugin.ImageCalculator
import ij.plugin.frame.RoiManager
import qupath.imagej.gui.IJExtension
//import qupath.imagej.processing.SimpleThresholding
//import qupath.imagej.helpers.IJTools
import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder
//import qupath.imagej.plugins.ImageJMacroRunner
//import qupath.lib.scripting.QPEx
//import qupath.lib.plugins.parameters.ParameterList
import qupath.lib.images.servers.ImageServer
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import java.awt.image.BufferedImage

int tileWidthPixels = 700  // width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels // Width of (final) output tile in pixels
double downsample = 4      // downsampling used when extracting tiles

int maxErrors = 20          // maximum number of errors... to avoid trying something doomed forever
int minImageDimension = 20  // if a tile will have a width or height < minImageDimension, it will be skipped

// initialize error counter
int nErrors = 0

// get the image server
ImageServer<BufferedImage> serverOriginal = QP.getCurrentImageData().getServer()

// get an ImagePlus server
ImagePlusServer server = ImagePlusServerBuilder.ensureImagePlusWholeSlideServer(serverOriginal)

// make sure that ImageJ is open
IJExtension.getImageJInstance()

// extract useful variables
String path = server.getPath()
String serverName = serverOriginal.getShortServerName()
double tileWidth = tileWidthPixels * downsample
double tileHeight = tileHeightPixels * downsample

// loop through the image - including z-slices (even though there's normally only one...)
int counter = 0;
for (int z = 0; z < server.nZSlices(); z++) { 
    for (double y = 0; y < server.getHeight(); y += tileHeight) { // replace number with server.getHeight()

        // compute integer y coordinates
        int yi = (int)(y + 0.5)
        int y2i = (int)Math.min((int)(y + tileHeight + 0.5), server.getHeight());
        int hi = y2i - yi

        // check if we are requesting a region that is too small
        if (hi / downsample < minImageDimension) {
            println("Image dimension < " + minImageDimension + " - skipping row")
            continue
        }

        for (double x = 0; x < server.getWidth(); x += tileWidth) { // replace number with server.getWidth()

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
            //try {
            
            // read the image region
            println("Sending tile " + counter + " to ImageJ")
            ImagePlus imp = server.readImagePlusRegion(request).getImage(false)
            // show the image
            imp.show()
            // remove blue and green channels to segment only on red
            IJ.run(imp, "Next Slice [>]", "");
            IJ.run(imp, "Next Slice [>]", "");
            IJ.run(imp, "Delete Slice", "");
            IJ.run(imp, "Delete Slice", "");
            // perform gaussian blur filter to lower background
            IJ.run(imp, "Gaussian Blur...", "sigma=2");
            
            // segment by maxima in red channel and create mask
            IJ.run(imp, "Find Maxima...", "noise=16000 output=[Segmented Particles]"); // 'exclude' at end of string to exclude on edges
            
            // adjust threshold in red channel to get tubule areas in separate mask
            IJ.setRawThreshold(imp, 2000, 65535, null);
            //IJ.run(imp, "Smooth");
            //Prefs.blackBackground = true;
            IJ.run(imp, "Convert to Mask", "method=Default");
            
            //// calculate intersection of two above masks
            names = WindowManager.getImageTitles()
            println(names) // see if WindowManager works
            imp1 = WindowManager.getImage(names[0]); // maxima mask
            imp2 = WindowManager.getImage(names[1]); // thresholded mask
            ic = new ImageCalculator();
            imp3 = ic.run("AND create", imp1, imp2); // intersection of maxima and threshold
            imp3.show();
            
            // clean up by tubules by size, invert selection and fill holes
            imp4 = IJ.run(imp3, "Analyze Particles...", "size=500-Infinity show=Masks");
            imp2.close();
            imp3.close();
            names = WindowManager.getImageTitles()
            imp4 = WindowManager.getImage(names[1]);
            IJ.run(imp4, "Invert LUT", "");
            IJ.run(imp4, "Fill Holes", "");
            
            // select mask and send to ROI manager
            IJ.run(imp4, "Create Selection", "");
            IJ.run(imp4, "Add Selection...", "");
            IJ.run("To ROI Manager", "");
            
            // in ROI Manager, split selection into individual cells
            rm = RoiManager.getInstance();
            rm.select(0); 

            // surround in try-catch to continue if no ROIs are detected
            try {
            	rm.runCommand("Split"); // split selection of all cells
            	rm.runCommand("Delete"); // delete selection of all cells
            	rm.select(0); // select first cell from split

            	// loop through cell ROIs and send to QuPath
            	n_ROI = rm.getCount();
            	for(i=1; i<n_ROI; i++){
            		rm.select(i);
            		IJ.run("Send ROI to QuPath", "");
            	}

            	IJ.run("Close All", "");
            	rm.close();
            }
            catch(err) {
            	IJ.run("Close All", "");
            	rm.close();
            }
            
            // print progress
            counter++
            println("Identified " + n_ROI + " ROIs in tile " + counter)

            //} catch (Exception e) {
            //    // check if we have had a sufficient number of errors to just give up
            //    nErrors++;
            //    if (nErrors > maxErrors) {
            //        println("Maximum number of errors exceeded - aborting...")
            //        return
            //    }
            //    e.printStackTrace()
            //}
        }
    }
}
