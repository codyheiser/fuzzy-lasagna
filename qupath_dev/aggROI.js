// process RGB image partition from QuPath for red-channel tubules
// identify independent ROIs and send back to QuPath
//
// @author: C Heiser
// Apr19

importClass(Packages.ij.IJ); 
importClass(Packages.ij.WindowManager);
importClass(Packages.ij.plugin.ImageCalculator);
importClass(Packages.ij.gui.GenericDialog);

imp = IJ.getImage();
bits = imp.getBitDepth();						// number of bits in image
print('bit depth: ' + bits)
maxIntensity = Math.pow(2, (bits));			// maximum intensity in each channel (24-bit image is 8-bit per channel)

// set parameters for IJ target detection
var GaussianBlurSigma = "2";					// sigma value for preliminary Gaussian blur filter
var maximaNoiseTolerance = 0.183*maxIntensity;	// noise tolerance for identifying red channel maxima
var minThreshold = 0.05*maxIntensity;			// lower threshold for raw green channel
var minParticleSize = "500";         			// minimum size particle to keep (pixels^2)
var minROIlen = 300;                    		// ROI measurement cutoff to determine when to split; rule of thumb: >50% of minParticleSize

if(bits == 24){
    // split 24-bit RGB image into stack by channels
    IJ.run(imp, "RGB Stack", "")
}

// get stacks image and remove red and blue channels to segment only on green
IJ.run(imp, "Delete Slice", "");
IJ.run(imp, "Next Slice [>]", "");
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

// clean up by tubules by size, invert selection and fill holes
imp4 = IJ.run(imp3, "Analyze Particles...", "size=" + minParticleSize + "-Infinity show=Masks exclude");
imp2.close();
imp3.close();
names = WindowManager.getImageTitles()
imp4 = WindowManager.getImage(names[1]);
IJ.run(imp4, "Invert LUT", "");
IJ.run(imp4, "Fill Holes", "");

// select mask and send to ROI manager
IJ.run(imp4, "Create Selection", "");
IJ.run("Send ROI to QuPath", "");
IJ.run("Close All", "");
