getwd()
setwd("C:/Users/Franco/Documents/Data Science - Johns Hopkins University/Getting and Cleaning Data/Week 4/UCI HAR Dataset")

#reading features and activity data
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")


#reading train data
train <- read.table("train/X_train.txt") 
colnames(train) <- features$V2

y_train <- read.table("train/y_train.txt")
train$activity <- y_train$V1

subject_train <- read.table("train/subject_train.txt")
train$subject <- factor(subject_train$V1)


#reading test data
test <- read.table("test/X_test.txt")
colnames(test) <- features$V2

y_test <- read.table("test/y_test.txt") 
test$activity <- y_test$V1

subject_test <- read.table("test/subject_test.txt")
test$subject <- factor(subject_test$V1)


#merge train and test sets
dataset <- rbind(test, train) 
names(dataset)

#filter column names
col_names <- grep("std\\(\\)|mean\\(\\)|activity|subjec", names(dataset), value=TRUE)
dataset_filtered <- dataset[, col_names]

#adding descriptive values for activity labels 
dataset_filtered$activitylabel <- factor(dataset_filtered$activity, labels=activities$V2)


#creating a tidy dataset with mean values for each subject and activity
library(reshape)
library(reshape2)
dataset_melt <- melt(dataset_filtered, id = c('activitylabel', 'subject'), measure.vars = col_names)
dataset_melt$value <- as.numeric(dataset_melt$value)
dataset_tidy <- dcast(dataset_melt, activitylabel + subject ~ variable, mean)

#creating a tidy dataset file
setwd("C:/Users/Franco/Documents/Data Science - Johns Hopkins University/Getting and Cleaning Data/Week 4/Coursera-Getting-and-Cleaning-Data-Course-Project")
write.table(dataset_tidy, file = "tidydataset.txt", row.names = FALSE)
