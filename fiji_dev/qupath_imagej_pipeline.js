// process region from QuPath for red-channel tubules, select mask results and send back to QuPath
// @author: C Heiser
// 20Mar19

importClass(Packages.ij.IJ); 
importClass(Packages.ij.WindowManager);
importClass(Packages.ij.plugin.ImageCalculator);

imp = IJ.getImage();

// segment by maxima in red channel and create mask
imp1 = IJ.run(imp, "Find Maxima...", "noise=20000 output=[Segmented Particles]"); // 'exclude' at end of string to exclude on edges

// adjust threshold in red channel to get tubule areas in separate mask
IJ.setRawThreshold(imp, 1500, 65535, null);
IJ.run(imp, "Smooth", "");
Prefs.blackBackground = true;
IJ.run(imp, "Convert to Mask", "");

// calculate intersection of two above masks
names = WindowManager.getImageTitles()
ic = new ImageCalculator();
imp1 = WindowManager.getImage(names[0]);
imp2 = WindowManager.getImage(names[1]);
imp3 = ic.run("AND create", imp1, imp2);
imp3.show();

// clean up by tubules 100 sq pixels or larger, invert selection and fill holes
IJ.run(imp3, "Analyze Particles...", "size=100-Infinity show=Masks"); // 'exclude' 'display' 'clear' 'summarize'
imp2.close();
imp3.close();
names = WindowManager.getImageTitles()
imp4 = WindowManager.getImage(names[1]);
IJ.run(imp4, "Invert LUT", "");
IJ.run(imp4, "Fill Holes", "");

// create selection from mask and return to QuPath
IJ.run(imp4, "Create Selection", "");
IJ.run("Send ROI to QuPath", "");