##### Getting and Cleaning Data #########


##################################################################################################
##################################################################################################
##########################                 COURSE PROJECT               ##########################
##################################################################################################
##################################################################################################
##################################################################################################



rm(list = ls())
library(plyr)

###Obtetndo o Dado - Getting the data


if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/Dataset.zip")

## dezipando o arquivo =  unzip the file Dataset.zip
unzip(zipfile = "./data/Dataset.zip", exdir = "./data") # unzip the file Dataset.zip

#obtendo o dado dezipado - getting the files unzipped

path_file <- file.path("./data", "UCI HAR Dataset/")
files <- list.files(path_file, recursive = T)
files

###############################################################################################
###############################################################################################
##############   1. Merges the training and the test sets to create one data set.##############
###############################################################################################
###############################################################################################
###############################################################################################


x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt") 
y_train  <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")



x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")


# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)




########################################################################################
########################################################################################
#Extracts only the measurements on the mean and standard deviation for each measurement#
########################################################################################
########################################################################################


features <- read.table("./data/UCI HAR Dataset/features.txt")
names(features)



# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]


#################################################################################################
#################################################################################################
######## Uses descriptive activity names to name the activities in the data set   ###############
#################################################################################################
#################################################################################################


activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"



#################################################################################################
#################################################################################################
########    Appropriately labels the data set with descriptive variable names.    ###############
#################################################################################################
#################################################################################################



# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)



#################################################################################################
#################################################################################################
########    Create a second, independent tidy data set with the average of each variable ########
######################      for each activity and each subject                    ###############
#################################################################################################
#################################################################################################


# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "./data/UCI HAR Dataset/averages_data.txt", row.name=FALSE)
head(averages_data)


