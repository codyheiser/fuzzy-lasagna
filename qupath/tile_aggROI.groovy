// tile whole-slide image in QuPath and send to ImageJ for analysis
// aggregate resulting ROIs as single, whole-slide annotation in QuPath
//
// @author: C Heiser
// Apr19

import qupath.lib.images.servers.ImageServer
import qupath.lib.regions.RegionRequest
import qupath.lib.scripting.QP
import java.awt.image.BufferedImage
import ij.IJ
import ij.ImagePlus
import ij.WindowManager
import ij.gui.GenericDialog
import ij.plugin.ImageCalculator
import ij.plugin.frame.RoiManager
import qupath.imagej.gui.IJExtension
import qupath.imagej.images.servers.ImagePlusServer
import qupath.imagej.images.servers.ImagePlusServerBuilder

// set parameters for tiling QuPath image and IJ analysis
int tileWidthPixels = 1000              // width of (final) output tile in pixels
int tileHeightPixels = tileWidthPixels  // Width of (final) output tile in pixels
double downsample = 4                   // downsampling used when extracting tiles
int minImageDimension = 50              // if a tile will have a width or height < minImageDimension, it will be skipped

// get the image server
ImageServer<BufferedImage> serverOriginal = QP.getCurrentImageData().getServer()
// get an ImagePlus server
ImagePlusServer server = ImagePlusServerBuilder.ensureImagePlusWholeSlideServer(serverOriginal)
// extract useful variables
String path = server.getPath()
String serverName = serverOriginal.getShortServerName()
double tileWidth = tileWidthPixels * downsample
double tileHeight = tileHeightPixels * downsample
int bits = serverOriginal.getBitsPerPixel()                     // number of bits in image
double maxIntensity = Math.pow(2, bits)                         // maximum intensity in each channel
print('Maximum pixel intensity of ' + maxIntensity + ' for a ' + bits + '-bit image.')

// make sure that ImageJ is open
IJExtension.getImageJInstance()
// prompt user for input parameters in IJ
gd = new GenericDialog("Parameters");
gd.addStringField("Channel: ", "R");
gd.addNumericField("Gaussian Blur Sigma: ", 2, 0);
gd.addNumericField("Max. Noise Tolerance (fraction): ", 0.244, 3);
gd.addNumericField("Color Threshold (fraction): ", 0.03, 2);
gd.addNumericField("Min. Particle Size (um): ", 500, 0);
gd.showDialog();
// extract values from dialog box
String channel = gd.getNextString();
float GaussianBlurSigma = gd.getNextNumber();                  // sigma value for preliminary Gaussian blur filter
float maximaNoiseTolerance = gd.getNextNumber()*maxIntensity;  // noise tolerance for identifying channel maxima
println('Noise tolerance: ' + maximaNoiseTolerance)
float minThreshold = gd.getNextNumber()*maxIntensity;             // lower threshold for raw channel
println('Threshold in '+ channel +' channel: ' + minThreshold)
float minParticleSize = gd.getNextNumber();                    // minimum size particle to keep (pixels^2)

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
            if(bits == 24){
                // split 24-bit RGB image into stack by channels
                IJ.run(imp, "RGB Stack", "")
            }

            // based on channel choice, remove other two channels from stack
            if(channel == "R"){
                IJ.run(imp, "Next Slice [>]", "");
                IJ.run(imp, "Next Slice [>]", "");
                IJ.run(imp, "Delete Slice", "");
                IJ.run(imp, "Delete Slice", "");
            }else if(channel == "G"){
                IJ.run(imp, "Delete Slice", "");
                IJ.run(imp, "Next Slice [>]", "");
                IJ.run(imp, "Delete Slice", "");
            }else if(channel == "B"){
                IJ.run(imp, "Delete Slice", "");
                IJ.run(imp, "Delete Slice", "");
            }

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

// Select all annotations and merge into one big annotation
selectObjects {
    return it.isAnnotation()
}
print 'Selected all annotations ... Merging'
mergeSelectedAnnotations()
print 'Done!'
