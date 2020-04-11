#Packages --------------------------------------
require(plyr) #(Wickham, 2011)
require(ggplot2) #(Wickham, 2016) 

#Working directory --------------------------------------
rm(list=ls()) 
directory <- ("/path-to-directory/") 
setwd(directory) 

#Start time --------------------------------------
start.time <- c("2018:03:14 17:51:19") 
#Manually enter start date and time first image of the experiment. Experimental time will be calculated based on this time point, using the acquisition time of the scanner images. 

#Scaling factor --------------------------------------
scaling.factor <- 475.417/1.5 #pixels/cm
#Manually enter the scale of the images, i.e., number of pixels to cover the diameter of a vial. This value can be easily measured in ImageJ. 

#Margin --------------------------------------
margin.vial <- 212
#Manually enter average number of pixels between the centre and edges of a particle as measured in ImageJ, typically the inner radius of the vials in pixel.

#Files to be imported --------------------------------------
#A demo can be run with the files available at https://github.com/esmeejoosten/photogranulation-quantification.
coordinates.name <- "results_marker.csv" #Information about each particle on marker image (generated using ImageJ)
raw.data.name <- "results_scanner_images.csv" #Joined result tables of scanner images (generated using ImageJ)
acquisition.time.name <- "image_acquisition.txt" #Image name, creation date and time of scanner images (generated using ExifTool)
experimental.condition.name <- "experimental_conditions.txt" #Experimental conditions per sample (manually generated) 

#Loading files --------------------------------------
coordinates <- read.csv(coordinates.name, header=T, as.is =T)
raw.data <- read.csv(raw.data.name, header = T, as.is = T)
acquisition.time <- read.delim(acquisition.time.name, header = F, as.is = T)
experimental.condition <- read.delim(experimental.condition.name, header = T, as.is = T)

#Generalised X, Y coordinates --------------------------------------
column.1 <- c(4,15,27,40,53,66) #e.g., the fourth particle detected corresponds to the first particle in the first column of the scanner grid, the fifteenth particle detected is situated on the grid in column 1, row 2, etc.
column.2 <- c(8,21,34,47,60)
column.3 <- c(1,14,28,41,54,67)
column.4 <- c(9,22,35,48,62)
column.5 <- c(2,16,31,42,55,68)
column.6 <- c(12,23,39,50,61)
column.7 <- c(5,17,32,45,57,70)
column.8 <- c(10,24,38,49,63)
column.9 <- c(3,18,33,43,56,71)
column.10 <- c(11,26,36,51,65)
column.11 <- c(6,19,29,46,59,69)
column.12 <- c(13,25,37,52,64)
column.13 <- c(7,20,30,44,58,72)
#Manually enter which particle label on the marker screenshot (Figure 4b) corresponds to which column. Our grid consists of columns alternating in starting position and size.

row.1 <- c(4,1,2,5,3,6,7) #e.g., the fourth particle detected corresponds to the most left particle in the first row of the grid.
row.2 <- c(8,9,12,10,11,13)
row.3 <- c(15,14,16,17,18,19,20)
row.4 <- c(21,22,23,24,26,25)
row.5 <- c(27,28,31,32,33,29,30)
row.6 <- c(34,35,39,38,36,37)
row.7 <- c(40,41,42,45,43,46,44)
row.8 <- c(47,48,50,49,51,52)
row.9 <- c(53,54,55,57,56,59,58)
row.10 <- c(60,62,61,63,65,64)
row.11 <- c(66,67,68,70,71,69,72)
#Manually enter which particle label on the marker screenshot (Figure 4b)  corresponds to which row. Our grid consists of rows alternating in starting position and size.

pos.names <- c(row.1, row.2, row.3, row.4, row.5, row.6, row.7, row.8, row.9, row.10, row.11)
#Order of particle numbers from top left to bottom right.

mean.x.1 <- mean(coordinates$X[coordinates$X.1 %in% column.1])
mean.x.2 <- mean(coordinates$X[coordinates$X.1 %in% column.2])
mean.x.3 <- mean(coordinates$X[coordinates$X.1 %in% column.3])
mean.x.4 <- mean(coordinates$X[coordinates$X.1 %in% column.4])
mean.x.5 <- mean(coordinates$X[coordinates$X.1 %in% column.5])
mean.x.6 <- mean(coordinates$X[coordinates$X.1 %in% column.6])
mean.x.7 <- mean(coordinates$X[coordinates$X.1 %in% column.7])
mean.x.8 <- mean(coordinates$X[coordinates$X.1 %in% column.8])
mean.x.9 <- mean(coordinates$X[coordinates$X.1 %in% column.9])
mean.x.10 <- mean(coordinates$X[coordinates$X.1 %in% column.10])
mean.x.11 <- mean(coordinates$X[coordinates$X.1 %in% column.11])
mean.x.12 <- mean(coordinates$X[coordinates$X.1 %in% column.12])
mean.x.13 <- mean(coordinates$X[coordinates$X.1 %in% column.13])
#Calculate mean X coordinates.

mean.y.1 <- mean(coordinates$Y[coordinates$X.1 %in% row.1])
mean.y.2 <- mean(coordinates$Y[coordinates$X.1 %in% row.2])
mean.y.3 <- mean(coordinates$Y[coordinates$X.1 %in% row.3])
mean.y.4 <- mean(coordinates$Y[coordinates$X.1 %in% row.4])
mean.y.5 <- mean(coordinates$Y[coordinates$X.1 %in% row.5])
mean.y.6 <- mean(coordinates$Y[coordinates$X.1 %in% row.6])
mean.y.7 <- mean(coordinates$Y[coordinates$X.1 %in% row.7])
mean.y.8 <- mean(coordinates$Y[coordinates$X.1 %in% row.8])
mean.y.9 <- mean(coordinates$Y[coordinates$X.1 %in% row.9])
mean.y.10 <- mean(coordinates$Y[coordinates$X.1 %in% row.10])
mean.y.11 <- mean(coordinates$Y[coordinates$X.1 %in% row.11])
#Calculate mean Y coordinates.

mean.x.a <-c(mean.x.1,mean.x.3,mean.x.5,mean.x.7,mean.x.9,mean.x.11,mean.x.13)
mean.x.b <- c(mean.x.2,mean.x.4,mean.x.6,mean.x.8,mean.x.10,mean.x.12)
#Calculate mean Y coordinates of rows having same X coordinate.
mean.y.a <- c(mean.y.1,mean.y.3,mean.y.5,mean.y.7,mean.y.9,mean.y.11)
mean.y.b <- c(mean.y.2,mean.y.4,mean.y.6,mean.y.8,mean.y.10)
#Calculate mean X coordinates of rows having same Y coordinate.
first.half <- expand.grid(mean.x.a, mean.y.a) 
second.half <- expand.grid(mean.x.b, mean.y.b) 
#Couple X and Y coordinates for both a and b.
mean.coordinates <- rbind(first.half, second.half) 
colnames(mean.coordinates) <- c("X","Y")
#Combine first.half and second.half by rows.
mean.coordinates <- mean.coordinates[order(mean.coordinates$Y, mean.coordinates$X),] 
#Arrange coordinates to be in the same order as particle numbers that can be found on marker screenshot.
mean.coordinates <- cbind(mean.coordinates, pos.names, 1:72) 
colnames(mean.coordinates) <- c("X","Y", "ParticleLabel", "Location") 
#Add columns with order of particles numbers that can be found on marker screenshot and experimental vial locations (1 to 72 from top left to bottom right).

#Experimental time --------------------------------------
start.time <- strptime(start.time, "%Y:%m:%d %H:%M:%S") 
#Convert start time to calendar and time representation.
date.time <- strptime(acquisition.time[,2], "%Y:%m:%d %H:%M:%S") 
#Get acquisition time per image and convert to calendar and time representation.
exp.time <- round(-1*(as.numeric(start.time - date.time, units="hours")),3)
#Convert date time to experimental time.
acquisition.time <- cbind(acquisition.time, exp.time) 
#Add experimental time to aquisition time file.
colnames(acquisition.time) <- c("Name", "Date", "ExpTime") 
acquisition.time$Name <- gsub(".tif", "", acquisition.time$Name)
#Remove .tif from file names.
unique.images <- unique(raw.data$Label) 
#Check number of unique images.
ExpTime.vec <- rep(0, nrow(raw.data)) 
#Create vector with as many zeros as there are rows in the raw data file (equals number of particles per image times number of images).
for(i in 1:length(unique.images)) 
{time.i <- acquisition.time$ExpTime[which(acquisition.time$Name == unique.images[i])] 
indices.1 <- which(raw.data$Label == unique.images[i]) 
ExpTime.vec[indices.1] <- time.i} 
raw.data <- cbind(raw.data, ExpTime.vec, rep(NA, nrow(raw.data)), rep(NA, nrow(raw.data)), rep(NA, nrow(raw.data)))
colnames(raw.data)[(ncol(raw.data)-3):ncol(raw.data)] <- c("ExpTime", "Location", "ExpCondition", "ExpID")
raw.data <- raw.data[order(raw.data$ExpTime),] 
#Loop over number of scanner images (i.e., 110 images), give experimental time of image in acquisition.time file that corresponds to image i. Give rows that correspond to image raw.data file that corresponds to image i (each image typically has 72 particles). Replace zeros in vector belonging to these rows by experimental time belonging to image i.

#Identify particles per location, add experimental conditions ------------------------------
for(j in 1:nrow(mean.coordinates) ){indices.2 <- which(
    raw.data$X > mean.coordinates$X[j]-margin.vial & 
    raw.data$X < mean.coordinates$X[j]+margin.vial &
    raw.data$Y > mean.coordinates$Y[j]-margin.vial &
    raw.data$Y < mean.coordinates$Y[j]+margin.vial) 
if(length(indices.2) == length(unique.images)){print(paste(c("All looks fine for Location ", j, "."), sep = "", collapse = ""))}else{print(paste(c("Warning: there's an issue for Location ", j, "."), sep = "", collapse = ""))}

raw.data$Location[indices.2] <- mean.coordinates$Location[j] 
indices.1 <- which(experimental.condition$Location == mean.coordinates$Location[j]) 
raw.data$Location[indices.2] <- experimental.condition$Location[indices.1]
raw.data$ExpCondition[indices.2] <- experimental.condition$ExpCondition[indices.1]
raw.data$ExpID[indices.2] <- experimental.condition$ExpID[indices.1]}
if (length(which(raw.data$Location == 0)) == 0) {print("No 0s left and all coordinates are assinged a location")} else {"Watch out! There are unidentified particles left in the data."}
#Loop over number of rows in mean.coordinates file (i.e., 72 rows for 72 particles). Return the particle that falls within the X, Y coordinates for a specific position, i.e., 110 particles for each location because there are 110 images. Note: small and not-centred particles may not be detected. Relate the location number (i.e., 1 to 72) to the X, Y position so that the particle has the same label on every image. Couple experimental conditions to locations. 

#Calculation of equivalent diameter from area --------------------------------------
raw.data <- cbind(raw.data, 2*sqrt(raw.data$Area/pi), rep(NA, nrow(raw.data)))
colnames(raw.data)[(ncol(raw.data)-1):ncol(raw.data)] <- c("EquivDiam_pix", "EquivDiam_cm") 
#Assume that particle area represents a circle and calculate diameter of that circle.
raw.data$EquivDiam_cm <- raw.data$EquivDiam_pix/scaling.factor
#Convert pixels to centimeters

#Plot diameter over experimental time per experimental condition -----------------------
treated.final.data <- ddply(raw.data, c("ExpTime", "ExpID"), summarise,
                            mean.diameter = mean(EquivDiam_cm), sd.diameter = sd(EquivDiam_cm),
                            sem.diameter= sd(EquivDiam_cm)/sqrt(length(EquivDiam_cm))) 

treated.final.data$ExpID <- as.character(treated.final.data$ExpID)
mean.diameter <- treated.final.data$mean.diameter 
sd <- treated.final.data$sd.diameter

p <- ggplot(treated.final.data, mapping = aes(x=ExpTime, y=mean.diameter, shape=ExpID, color=ExpID)) 
p <- p + geom_point() 
p <- p + scale_shape_discrete(name = "ExpID", breaks=c("1", "2"), labels=c("sludge1", "sludge2")) 
p <- p + scale_color_discrete(name = "ExpID", breaks=c("1", "2"), labels=c("sludge1", "sludge2")) 
p <- p + geom_errorbar(aes(ymin=mean.diameter-sd, ymax=mean.diameter+sd))
p <- p + labs(x = "Experimental time [h]", y = "Biomass diameter [cm]") 
p #This is Figure 7