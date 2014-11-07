#######################################
## run_analysis.R
##
## a program for processing UCI HAR data
## based on the Samsung Galaxy S Smartphone
##
## Oct 2014
#######################################
# setwd("/Users/submarine/Git/Getting_and_Cleaning_Data/peer assessment")
# make sure you move 7 .txt files into the same branch with run_analysis.R

#.1  Merges the training and the test sets to create one data set.
library(data.table)
# cannot use fread, oh!
trainData <- read.table("X_train.txt") # 7352*561
trainLable <- read.table("y_train.txt") # 7352*1
testData <- read.table("X_test.txt") # 2947*561
testLable <- read.table("y_test.txt") # 2947*1
trainSubject <- read.table("subject_train.txt") # 7352*1
testSubject <- read.table("subject_test.txt") # 7352*1
# vertically merge Data, Lable and Subject
mergeData <- rbind(trainData,testData) # 10299*561
mergeLable <- rbind(trainLable,testLable) # 10299*1
mergeSubject <- rbind(trainSubject,testSubject) # 10299*1

#.2  Extracts only the measurements on the mean and standard deviation 
#    for each measurement.
features <- read.table("features.txt",colClasses="character") # 561*2
mean_std <- grep("mean\\(\\)|std\\(\\)", features[, 2])  # 66
# dim(mean_std)=66 means that only 66 rows of the 561 rows features refers to mean or std
mergeData <- mergeData[,mean_std] # 10299*66
names(mergeData) <- gsub("\\(\\)", "", features[mean_std, 2]) # remove "()"
names(mergeData) <- gsub("mean", "Mean", names(mergeData)) # capitalize M
names(mergeData) <- gsub("std", "Std", names(mergeData)) # capitalize S
names(mergeData) <- gsub("-", "", names(mergeData)) # remove "-" in column names 
names(mergeData)

#.3  Uses descriptive activity names to name the activities in 
#    the data set
activity <- read.table("activity_labels.txt",colClasses="character")
activity[, 2] <- tolower(gsub("_", "", activity[, 2])) # lower cases, no "_"
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))
activityLabel <- activity[mergeLable[, 1], 2]
mergeLable[, 1] <- activityLabel
names(mergeLable) <- "activity"

#.4  Appropriately labels the data set with descriptive activity 
#    names. 
names(mergeSubject) <- "subject"
cleanedData <- cbind(mergeSubject, mergeLable, mergeData)  # 10299*68
# write the first required dataset
write.table(cleanedData, "Sum_data.txt") 

#.5  Creates a second, independent tidy data set with the average of 
#    each variable for each activity and each subject. 
subjectLen <- length(table(mergeSubject)) # 30
activityLen <- dim(activity)[1] # 6
columnLen <- dim(cleanedData)[2] # 68
result <- matrix(0, nrow=subjectLen*activityLen, ncol=columnLen) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleanedData)
row <- 1
for(i in 1:subjectLen) {
    for(j in 1:activityLen) {
        result[row, 1] <- sort(unique(mergeSubject)[, 1])[i]
        result[row, 2] <- activity[j, 2]
        bool1 <- i == cleanedData$subject
        bool2 <- activity[j, 2] == cleanedData$activity
        result[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
        row <- row + 1
    }
}
# the required second dataset
write.table(result, "tidy.txt") 

