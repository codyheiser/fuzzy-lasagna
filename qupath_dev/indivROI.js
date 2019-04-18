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
maxIntensity = Math.pow(2, bits);				// maximum intensity in each channel (24-bit image is 8-bit per channel)

// set parameters for IJ target detection
var GaussianBlurSigma = "2";					// sigma value for preliminary Gaussian blur filter
var maximaNoiseTolerance = 0.244*maxIntensity;	// noise tolerance fraction for identifying red channel maxima
var minThreshold = 0.03*maxIntensity;			// lower threshold fraction for raw red channel
var minParticleSize = "500";         			// minimum size particle to keep (pixels^2)
var minROIlen = 300;                    		// ROI measurement cutoff to determine when to split; rule of thumb: >50% of minParticleSize

if(bits == 24){
    // split 24-bit RGB image into stack by channels
    IJ.run(imp, "RGB Stack", "")
}

// get stacks image and remove blue and green channels to segment only on red
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
IJ.run(imp4, "Add Selection...", "");
IJ.run("To ROI Manager", "");

// in ROI Manager, split selection into individual cells
rm = RoiManager.getInstance();
rm.select(0);

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
