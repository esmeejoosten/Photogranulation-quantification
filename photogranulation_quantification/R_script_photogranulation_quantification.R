##Packages --------------------------------------
require(plyr) #(Wickham, 2011)
require(ggplot2) #(Wickham, 2016) 

##Working directory --------------------------------------
rm(list=ls()) 
directory <- ("/path-to-directory/") 
setwd(directory) 

##Start time --------------------------------------
start.time <- c("2018:03:14 17:51:19") 
#Manually enter start date and time first image of the experiment. Experimental time will be calculated based on this time point, using the acquisition time of the scanner images. 

##Scaling factor --------------------------------------
scaling.factor <- 475.417/1.5 #pixels/cm
#Manually enter the scale of the images, i.e., number of pixels to cover the diameter of a vial. This value can be easily measured in ImageJ. 

##Margin --------------------------------------
margin.vial <- 212
#Manually enter average number of pixels between the centre and edges of a particle as measured in ImageJ, typically the inner radius of the vials in pixel.

##Files to be imported --------------------------------------
#A demo can be run with the files available at https://doi.org/10.5281/zenodo.3922175.
coordinates.name <- "results_marker.csv" #Information about each particle on marker image (generated using ImageJ)
raw.data.name <- "results_scanner_images.csv" #Joined result tables of scanner images (generated using ImageJ)
acquisition.time.name <- "image_acquisition.txt" #Image name, creation date and time of scanner images (generated using ExifTool)
experimental.condition.name <- "experimental_conditions.txt" #Experimental conditions per sample (manually generated) 

##Loading files --------------------------------------
coordinates <- read.csv(coordinates.name, header=T, as.is =T)
raw.data <- read.csv(raw.data.name, header = T, as.is = T)
acquisition.time <- read.delim(acquisition.time.name, header = F, as.is = T)
experimental.condition <- read.delim(experimental.condition.name, header = T, as.is = T)

###Calculate average X-, Y-coordinates of vial areas identified on the marker image (Figure 5B).

##Average X-, Y- coordinates of vial areas --------------------------------------
column.1 <- c(1,14,27,40,53,66) #Manually enter which particle label on the marker screenshot corresponds to which column, as indicated in blue (Figure 5B). The grid consists of columns alternating in starting position and size, e.g., the first particle detected corresponds to the first particle in the first column of the scanner grid, the fourteenth particle detected is situated on the grid in column 1, row 3, etc. 
column.2 <- c(8,21,34,47,60)
column.3 <- c(2,15,28,41,54,67)
column.4 <- c(9,22,35,48,61)
column.5 <- c(3,16,29,42,55,68)
column.6 <- c(10,23,36,49,62)
column.7 <- c(4,17,30,43,56,69)
column.8 <- c(11,24,37,50,63)
column.9 <- c(5,18,31,44,57,70)
column.10 <- c(12,25,38,51,64)
column.11 <- c(6,19,32,45,58,71)
column.12 <- c(13,26,39,52,65)
column.13 <- c(7,20,33,46,59,72)

row.1 <- c(1,2,3,4,5,6,7) #Manually enter which particle label on the marker screenshot corresponds to which row, as indicated in green (Figure 5B). The grid consists of rows alternating in starting position and size, e.g., the first particle detected corresponds to the most left particle in the first row of the grid, etc. 
row.2 <- c(8,9,10,11,12,13)
row.3 <- c(14,15,16,17,18,19,20)
row.4 <- c(21,22,23,24,25,26)
row.5 <- c(27,28,29,30,31,32,33)
row.6 <- c(34,35,36,37,38,39)
row.7 <- c(40,41,42,43,44,45,46)
row.8 <- c(47,48,49,50,51,52)
row.9 <- c(53,54,55,56,57,58,59)
row.10 <- c(60,61,62,63,64,65)
row.11 <- c(66,67,68,69,70,71,72)

pos.names <- c(row.1, row.2, row.3, row.4, row.5, row.6, row.7, row.8, row.9, row.10, row.11)
#Order of particle numbers from top left to bottom right.

average.x.1 <- mean(coordinates$X[coordinates$X.1 %in% column.1])
average.x.2 <- mean(coordinates$X[coordinates$X.1 %in% column.2])
average.x.3 <- mean(coordinates$X[coordinates$X.1 %in% column.3])
average.x.4 <- mean(coordinates$X[coordinates$X.1 %in% column.4])
average.x.5 <- mean(coordinates$X[coordinates$X.1 %in% column.5])
average.x.6 <- mean(coordinates$X[coordinates$X.1 %in% column.6])
average.x.7 <- mean(coordinates$X[coordinates$X.1 %in% column.7])
average.x.8 <- mean(coordinates$X[coordinates$X.1 %in% column.8])
average.x.9 <- mean(coordinates$X[coordinates$X.1 %in% column.9])
average.x.10 <- mean(coordinates$X[coordinates$X.1 %in% column.10])
average.x.11 <- mean(coordinates$X[coordinates$X.1 %in% column.11])
average.x.12 <- mean(coordinates$X[coordinates$X.1 %in% column.12])
average.x.13 <- mean(coordinates$X[coordinates$X.1 %in% column.13])
#Calculates average X coordinates.

average.y.1 <- mean(coordinates$Y[coordinates$X.1 %in% row.1])
average.y.2 <- mean(coordinates$Y[coordinates$X.1 %in% row.2])
average.y.3 <- mean(coordinates$Y[coordinates$X.1 %in% row.3])
average.y.4 <- mean(coordinates$Y[coordinates$X.1 %in% row.4])
average.y.5 <- mean(coordinates$Y[coordinates$X.1 %in% row.5])
average.y.6 <- mean(coordinates$Y[coordinates$X.1 %in% row.6])
average.y.7 <- mean(coordinates$Y[coordinates$X.1 %in% row.7])
average.y.8 <- mean(coordinates$Y[coordinates$X.1 %in% row.8])
average.y.9 <- mean(coordinates$Y[coordinates$X.1 %in% row.9])
average.y.10 <- mean(coordinates$Y[coordinates$X.1 %in% row.10])
average.y.11 <- mean(coordinates$Y[coordinates$X.1 %in% row.11])
#Calculates average Y coordinates.

average.x.a <-c(average.x.1,average.x.3,average.x.5,average.x.7,average.x.9,average.x.11,average.x.13)
average.x.b <- c(average.x.2,average.x.4,average.x.6,average.x.8,average.x.10,average.x.12)
#Calculates average Y coordinates of rows having same X coordinate.
average.y.a <- c(average.y.1,average.y.3,average.y.5,average.y.7,average.y.9,average.y.11)
average.y.b <- c(average.y.2,average.y.4,average.y.6,average.y.8,average.y.10)
#Calculates average X coordinates of rows having same Y coordinate.
first.half <- expand.grid(average.x.a, average.y.a) 
second.half <- expand.grid(average.x.b, average.y.b) 
#Couples X and Y coordinates for both a and b.
average.coordinates <- rbind(first.half, second.half) 
colnames(average.coordinates) <- c("X","Y")
#Combines first.half and second.half by rows.
average.coordinates <- average.coordinates[order(average.coordinates$Y, average.coordinates$X),] 
#Arranges coordinates to be in the same order as particle numbers that can be found on marker screenshot.
average.coordinates <- cbind(average.coordinates, pos.names, 1:72) 
colnames(average.coordinates) <- c("X","Y", "ParticleLabel", "Location") 
#Adds columns with order of particles numbers that can be found on marker screenshot and experimental vial locations (1 to 72 from top left to bottom right).

###Assign experimental time to all experimentally measured particles per image by adding a column with experimental time to the particle data obtained with ImageJ. This facilitates the plotting to temporal dynamics.

##Experimental time --------------------------------------
start.time <- strptime(start.time, "%Y:%m:%d %H:%M:%S") 
#Converts start time to calendar and time representation.
date.time <- strptime(acquisition.time[,2], "%Y:%m:%d %H:%M:%S") 
#Acquires acquisition time per image and converts it to calendar and time representation.
exp.time <- round(-1*(as.numeric(start.time - date.time, units="hours")),3)
#Converts date time to experimental time.
acquisition.time <- cbind(acquisition.time, exp.time) 
#Adds experimental time to aquisition time file.
colnames(acquisition.time) <- c("Name", "Date", "ExpTime") 
acquisition.time$Name <- gsub(".tif", "", acquisition.time$Name)
#Removes .tif from file names.
unique.images <- unique(raw.data$Label) 
#Checks number of unique images.
ExpTime.vec <- rep(0, nrow(raw.data)) 
#Creates vector with as many zeros as there are rows in the raw data file (equals number of particles per image times number of images).
for(i in 1:length(unique.images)) 
{time.i <- acquisition.time$ExpTime[which(acquisition.time$Name == unique.images[i])] 
indices.1 <- which(raw.data$Label == unique.images[i]) 
ExpTime.vec[indices.1] <- time.i} 
raw.data <- cbind(raw.data, ExpTime.vec, rep(NA, nrow(raw.data)), rep(NA, nrow(raw.data)), rep(NA, nrow(raw.data)))
colnames(raw.data)[(ncol(raw.data)-3):ncol(raw.data)] <- c("ExpTime", "Location", "ExpCondition", "ExpID")
raw.data <- raw.data[order(raw.data$ExpTime),] 
#Loops over number of scanner images (i.e., 110 images), gives experimental time of image in acquisition.time file that corresponds to image i. Gives rows that correspond to image raw.data file that corresponds to image i (each image typically has 72 particles). Replaces zeros in vector belonging to these rows by experimental time belonging to image i.

###Identify particles from a vial at a specific physical location on each image using the X-, Y-coordinates of vial areas. Relate particles to their location by assigning a location number and match them to the appropriate experimental conditions.

##Identify particles per location, add experimental conditions ------------------------------
for(j in 1:nrow(average.coordinates) ){indices.2 <- which(
    sqrt(((raw.data$X- average.coordinates$X[j])^2) + 
    ((raw.data$Y-average.coordinates$Y[j])^2)) < margin.vial)
if(length(indices.2) == length(unique.images)){print(paste(c("All looks fine for Location ", j, "."), sep = "", collapse = ""))}else{print(paste(c("Warning: there's an issue for Location ", j, "."), sep = "", collapse = ""))}
#If there is an issue for Location j, go manually through the images and make sure the issue is corrected. It may happen that a particle was not detected on all images, e.g., because it started to float, or more than one particle has been detected in the same well on one image, e.g., because there was a small piece of loose biomass. In the latter case, you can manually remove the data from the erroneous particle that is not a granule from the dataset.

raw.data$Location[indices.2] <- average.coordinates$Location[j] 
indices.1 <- which(experimental.condition$Location == average.coordinates$Location[j]) 
raw.data$Location[indices.2] <- experimental.condition$Location[indices.1]
raw.data$ExpCondition[indices.2] <- experimental.condition$ExpCondition[indices.1]
raw.data$ExpID[indices.2] <- experimental.condition$ExpID[indices.1]}
if (length(which(raw.data$Location == 0)) == 0) {print("No 0s left and all coordinates are assinged a location")} else {"Watch out! There are unidentified particles left in the data."}
#Loops over number of rows in average.coordinates file (i.e., 72 rows for 72 particles). Returns the particle that falls within the X, Y coordinates for a specific position, i.e., 110 particles for each location because there are 110 images. Note: small and not-centred particles may not be detected. Relates the location number (i.e., 1 to 72) to the X, Y position so that the particle has the same label on every image. Couples experimental conditions to locations. 

###Transform the detected surface area of particles into equivalent diameters;

##Calculation of equivalent diameter from area --------------------------------------
raw.data <- cbind(raw.data, 2*sqrt(raw.data$Area/pi), rep(NA, nrow(raw.data)))
colnames(raw.data)[(ncol(raw.data)-1):ncol(raw.data)] <- c("EquivDiam_pix", "EquivDiam_cm") 
#Assume that particle area represents a circle and calculate diameter of that circle.
raw.data$EquivDiam_cm <- raw.data$EquivDiam_pix/scaling.factor
#Convert pixels to centimeters

###Plot the average decrease in particle diameter per experimental condition over time.

##Plot diameter over experimental time per experimental condition -----------------------
treated.final.data <- ddply(raw.data, c("ExpTime", "ExpID"), summarise,
                            average.diameter = mean(EquivDiam_cm), sd.diameter = sd(EquivDiam_cm),
                            sem.diameter= sd(EquivDiam_cm)/sqrt(length(EquivDiam_cm))) 

treated.final.data$ExpID <- as.character(treated.final.data$ExpID)
average.diameter <- treated.final.data$average.diameter 
sd <- treated.final.data$sd.diameter

p <- ggplot(treated.final.data, mapping = aes(x=ExpTime, y=average.diameter, shape=ExpID, color=ExpID)) 
p <- p + geom_point() 
p <- p + scale_shape_discrete(name = "ExpID", breaks=c("1", "2"), labels=c("sludge1", "sludge2")) 
p <- p + scale_color_discrete(name = "ExpID", breaks=c("1", "2"), labels=c("sludge1", "sludge2")) 
p <- p + geom_errorbar(aes(ymin=average.diameter-sd, ymax=average.diameter+sd))
p <- p + labs(x = "Experimental time [h]", y = "Biomass diameter [cm]") 
p #This is Figure 8
