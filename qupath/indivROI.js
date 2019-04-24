// process RGB image region from QuPath to find thresholded ROI in single channel
// send results back to QuPath as individual ROI annotations
//
// @author: C Heiser
// Apr19

importClass(Packages.ij.IJ); 
importClass(Packages.ij.WindowManager);
importClass(Packages.ij.plugin.ImageCalculator);
importClass(Packages.ij.gui.GenericDialog);

imp = IJ.getImage();
bits = imp.getBitDepth();						            // number of bits in image
maxIntensity = Math.pow(2, (bits));			                // maximum intensity in each channel
print('Maximum pixel intensity of ' + maxIntensity + ' for a ' + bits + '-bit image.')

// prompt user for input parameters
gd = new GenericDialog("Parameters");
gd.addStringField("Channel: ", "R");
gd.addNumericField("Gaussian Blur Sigma: ", 2, 0);
gd.addNumericField("Max. Noise Tolerance (fraction): ", 0.244, 3);
gd.addNumericField("Color Threshold (fraction): ", 0.03, 2);
gd.addNumericField("Min. Particle Size (um): ", 500, 0);
gd.addNumericField("Min. ROI Split (px): ", 300, 0);
gd.showDialog();
// extract values from dialog box
channel = gd.getNextString();
GaussianBlurSigma = gd.getNextNumber();                     // sigma value for preliminary Gaussian blur filter
maximaNoiseTolerance = gd.getNextNumber()*maxIntensity;     // noise tolerance for identifying channel maxima
print('Noise tolerance: ' + maximaNoiseTolerance)
minThreshold = gd.getNextNumber()*maxIntensity;             // lower threshold for raw channel
print('Threshold in '+ channel +' channel: ' + minThreshold)
minParticleSize = gd.getNextNumber();                       // minimum size particle to keep (pixels^2)
minROIlen = gd.getNextNumber();                          	// ROI measurement cutoff to determine when to split; rule of thumb: >50% of minParticleSize

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

// segment by maxima in channel and create mask
IJ.run(imp, "Find Maxima...", "noise=" + maximaNoiseTolerance + " output=[Segmented Particles]");

// adjust threshold in channel to get tubule areas in separate mask
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
