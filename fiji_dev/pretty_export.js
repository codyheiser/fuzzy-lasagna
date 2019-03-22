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
