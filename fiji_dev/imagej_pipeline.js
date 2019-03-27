// process region from QuPath for red-channel tubules, select resulting ROIs and send back to QuPath
// @author: C Heiser
// Mar19

importClass(Packages.ij.IJ); 
importClass(Packages.ij.WindowManager);
importClass(Packages.ij.plugin.ImageCalculator);
importClass(Packages.ij.gui.GenericDialog);

imp = IJ.getImage();

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
IJ.run(imp, "Smooth", "stack");
Prefs.blackBackground = true;
IJ.run(imp, "Convert to Mask", "method=Default");

// calculate intersection of two above masks
names = WindowManager.getImageTitles()
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
