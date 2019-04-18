// tile whole-slide image in QuPath and send to ImageJ for analysis
// return resulting ROIs to QuPath as individual annotations
//
// @author: C Heiser
// Apr19

import ij.IJ
import ij.ImagePlus
import ij.WindowManager
import ij.plugin.ImageCalculator
import ij.plugin.frame.RoiManager
import qupath.imagej.gui.IJExtension
import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder
import qupath.lib.images.servers.ImageServer
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import java.awt.image.BufferedImage

// set parameters for tiling QuPath image and IJ analysis
int tileWidthPixels = 1000                          // width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels              // Width of (final) output tile in pixels
double downsample = 2                               // downsampling used when extracting tiles
int minImageDimension = 50                          // if a tile will have a width or height < minImageDimension, it will be skipped

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
int bits = serverOriginal.getBitsPerPixel()         // number of bits in image
double maxIntensity = Math.pow(2, bits)             // maximum intensity in each channel (24-bit image is 8-bit per channel)

// set parameters for IJ target detection
String GaussianBlurSigma = "2"			            // sigma value for preliminary Gaussian blur filter
String maximaNoiseTolerance = 0.244*maxIntensity;	// noise tolerance for identifying red channel maxima
int minThreshold = 0.03*maxIntensity;				// lower threshold for raw red channel
String minParticleSize = "500"                      // minimum size particle to keep in IJ analysis (pixels^2)
int minROIlen = 300                                 // ROI measurement cutoff to determine when to split; rule of thumb: >50% of minParticleSize

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

            // create request with proper coordinates and downsample factor
            RegionRequest request = RegionRequest.createInstance(path, downsample, xi, yi, wi, hi, z, 0)

            // check if we requesting a region that is too small
            if (wi / downsample < minImageDimension) {
                // Only print warning if we've not skipped this before
                if (y > 0)
                    println("Image dimension < " + minImageDimension + " - skipping column")
                continue
            }
            
            // read the image region
            println("Sending tile " + counter + " to ImageJ")
            ImagePlus imp = server.readImagePlusRegion(request).getImage(false)
            // show the image
            imp.show()
            if(bits == 8){
                // split 24-bit RGB image into stack by channels
                IJ.run(imp, "RGB Stack", "")
            }
            // remove blue and green channels to segment only on red
            IJ.run(imp, "Next Slice [>]", "");
            IJ.run(imp, "Next Slice [>]", "");
            IJ.run(imp, "Delete Slice", "");
            IJ.run(imp, "Delete Slice", "");
            // perform gaussian blur filter to lower background
            IJ.run(imp, "Gaussian Blur...", "sigma=" + GaussianBlurSigma);
            
            // segment by maxima in red channel and create mask
            IJ.run(imp, "Find Maxima...", "noise=" + maximaNoiseTolerance + " output=[Segmented Particles]");
            
            // adjust threshold in red channel to get tubule areas in separate mask
            IJ.setRawThreshold(imp, minThreshold, maxIntensity, null);
            IJ.run(imp, "Convert to Mask", "method=Default");
            
            // calculate intersection of two above masks
            names = WindowManager.getImageTitles()
            imp1 = WindowManager.getImage(names[0]); // maxima mask
            imp2 = WindowManager.getImage(names[1]); // thresholded mask
            ic = new ImageCalculator();
            imp3 = ic.run("AND create exclude", imp1, imp2); // intersection of maxima and threshold
            imp3.show();
            
            // clean up by tubules by size, invert selection and fill holes to yield final binary mask
            imp4 = IJ.run(imp3, "Analyze Particles...", "size=" + minParticleSize + "-Infinity show=Masks exclude");
            imp2.close();
            imp3.close();
            names = WindowManager.getImageTitles()
            imp4 = WindowManager.getImage(names[1]);
            IJ.run(imp4, "Invert LUT", "");
            IJ.run(imp4, "Fill Holes", "");
            
            // select entire mask and send to ROI manager
            IJ.run(imp4, "Create Selection", "");
            IJ.run(imp4, "Add Selection...", "");
            IJ.run("To ROI Manager", "");
            rm = RoiManager.getInstance(); // open ROI manager window
            rm.select(0); // get selection of entire mask

            // see if selection is splittable into multiple cells
            println(rm.getRoi(0).getLength())

            if(rm.getRoi(0).getLength() == 0) { // no ROIs detected; return to QuPath
                n_ROI = 0
            	IJ.run("Close All", "");
            	rm.close();

            } else if(rm.getRoi(0).getLength() > minROIlen) { // multiple ROIs detected; split, iterate, and send to QuPath
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

            } else { // one ROI detected (rm.getRoi(0).getLength() <= minROIlen); send it to QuPath
                n_ROI = 1
                IJ.run("Send ROI to QuPath", "");
                IJ.run("Close All", "");
                rm.close();
            }
            
            // print progress
            println("Identified " + n_ROI + " ROIs in tile " + counter)
            counter++
        }
    }
}

println("Done!");
