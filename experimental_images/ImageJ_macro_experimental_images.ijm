setBatchMode(false); 
//Enter or remain in batch mode and hide active images during macro execution.
function action(input, output, filename){
open(input + filename); 
jobname = getTitle(); 
jobnamemod = indexOf(jobname, "."); 
jobname = substring(jobname, 0, jobnamemod);
//The file paths and filenames entered when starting the macro are converted to variables that become useable to the commands where they are used.
run("Split Channels"); 
selectImage(jobname + ".jpg (blue)");
close();
selectImage(jobname + ".jpg (green)");
close();
selectImage(jobname + ".jpg (red)");
red_image = getTitle();
//Convert RGB to grayscale image. Retain only the channel which presents most contrast between the areas on which vials are placed (white) and the grid (black). 
open(path);
//Open grid image using the file specified below. 
//run("Invert");
//Vial areas now appear blackish and the grid whitish. 
grid = getTitle(); 
imageCalculator("Add create", red_image, grid);
close("\\Others");
//Making grid appear as true white so that it will be detected as background in the subsequent binarization step.
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel"); 
//Remove spatial scale of active image so that measurement results (e.g., area measurements) have the unit pixel.
run("Threshold..."); 
waitForUser("Please set the threshold manually. Then press OK, or cancel to exit macro");
setOption("BlackBackground", false);
run("Convert to Mask");
selectWindow("Threshold");
run("Close");
//Create binary image from grayscale image: choose and apply cut-off value to divide image into foreground, i.e. vial areas, and background, i.e., grid. Note: This can be tricky because we normally do not find a threshold that works ideally for every particle on an image. We recommend testing a small subset (e.g., first, middle and last image) to get an idea of what works well. Define your own criteria and try to treat each image of your dataset in the same way. 
run("Fill Holes (Binary/Gray)");
//Fill holes in the areas occupied by vials to achieve a solid area. Note: This may fill up entire vial area when a biomass particle is surrounded by a ring corresponding to a vial. If this happens, you can reduce the size of the respective particle on the marker image using for example image editor Gimp and run the macro again. 
run("Morphological Filters", "operation=Opening element=Disk radius=10"); 
close("\\Others");
//Remove isolated pixels and break connections between areas occupied by vials and the grid so that it becomes less likely that the grid is accidentally considered part of the vial area. 
mask_image = getTitle();	 
//Created image becomes mask image.
run("Morphological Filters", "operation=Erosion element=Disk radius=40");
marker_image = getTitle();
//Drastically decrease the size of the detected particles on mask image to create an image that will be used for morphological reconstruction Note: Images of small granules may be removed when disk radius is too large, you may adjust the parameter disk radius depending on your images and experiment.
print("The marker image name is " + marker_image); 
print("The mask image name is " + mask_image);
//Print active marker and mask images.
run("Morphological Reconstruction", "marker=["+marker_image+"] mask=["+mask_image+"] type=[By Dilation] connectivity=4");
//Overlay mask image on marker image: keep particles from the mask image that overlap with at least one pixel on the marker image and remove the other pixels. This steps assures that only particles are retained that overlap with the area of vials. Possible erratic particles that are not part of the OPGs are removed here.
run("Set Measurements...", "area centroid fit shape display redirect=None decimal=3");
rename(jobname); 
//Specify which measurements are recorded.
run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 show=[Overlay Outlines] display exclude");
//Generate result table (see explanation at section E.)
save(output + jobname + "_final.jpg"); 
close();
saveAs("Results", output+ jobname + "_results.csv" ); 
run("Clear Results");		 
selectWindow("Log");
run("Close All");
}
//Erase any previous measurement results.
input = getDirectory("Choose an input directory with the raw images, please.");
output = getDirectory("Choose an output directory for result images and tables, please.");
waitForUser("Please open the grid image. Then click ok.");
//Select the grid image. This image allows the removal of the grid from the scanner images. 
grid = getTitle();
dir = getDirectory("image");
path = dir+grid;
close(); 
//Define input directory with raw images and output directory to save created images and open grid image. In the chronology of the script, results from these commands will be displayed once when starting the macro. 
list = getFileList(input);
for (i = 0; i < list.length; i++)
action(input, output, list[i]);
setBatchMode(false);
//Definition of a loop structure that will execute the macro function as many times as there are images found in the input directory.
