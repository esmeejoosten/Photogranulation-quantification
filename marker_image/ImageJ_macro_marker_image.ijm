jobdirectory = getDirectory("Please choose a directory for saving result files and the marker image.");
waitForUser("Please open the background image. Then click ok."); 
backgroundimage = getTitle();
run("Split Channels");
selectImage(backgroundimage + " (red)");
close();
selectImage(backgroundimage + " (green)");
close();
selectImage(backgroundimage + " (blue)");
//Convert RGB to grayscale image. Retain only the channel which presents most //contrast between the areas on which vials are placed (white) and the grid (black). 
run("Invert");
//Vial areas now appear black and the grid white. 
setAutoThreshold("Default");
run("Threshold...");
waitForUser("Please set the threshold manually. Then press OK.");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Close");
//Create binary image from grayscale image: choose and apply cut-off value to divide image into foreground, i.e. vial areas, and background, i.e., grid. This works well when the grid is darker than the biomas. Otherwise you will have to setOption (“Black background”, true).
run("Fill Holes (Binary/Gray)");
//Fill holes in the areas occupied by vials to achieve a solid area (Legland et al., 2016).
run("Morphological Filters", "operation=Opening element=Disk radius=10");
//Remove isolated pixels and break connections between areas occupied by vials and the grid so that it becomes less likely that the grid is accidentally considered part of the vial area.
run("Morphological Filters", "operation=Erosion element=Disk radius=35");
saveAs("Jpeg", jobdirectory + "marker_image.jpg");
run("Set Measurements...", "area centroid fit shape display redirect=None decimal=3");
//Specify which measurements are recorded.
run("Analyze Particles...", "  show=Overlay display exclude");
//Generate result table containing information about each particle in the image, including a running number to label detected particles, i.e., the area that a vial occupies, the particle area and the centroid X and Y coordinates of the particles (Figure 5). It furthermore overlays the particle labels with the marker image to visually relate the particle characteristics in the table to the detected particles on the image.
saveAs("Results", jobdirectory + "results_marker.csv");
//This file can be found at https://github.com/esmeejoosten/photogranulation-quantification.
