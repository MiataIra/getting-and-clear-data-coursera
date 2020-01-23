library(dplyr) #packge for transformation and tidy data
library(curl) #packege for to downlods the dataset
library(zip) #packege for to unzip dataset

curl_download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip")
unzip("Dataset.zip")


#step1 Merges the training and the test sets to create one data set.

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")


x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/test/X_test.txt")

X<-bind_rows(x_test, x_train)
names(X)<-features[,2]


y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/test/y_test.txt")

Y<-bind_rows(y_test, y_train)



subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Subject<-bind_rows(subject_test, subject_train)

Merged_Data<-bind_cols(Subject, Y, X)

names_mean<-grep("mean", names(Merged_Data), value=T)
names_std<-grep("std", names(Merged_Data), value=T)


Tidy_Data<-select(Merged_Data, subject, code, names_mean, names_std)





Tidy_Data[,"code"] <- activity_labels[Tidy_Data[,"code"], 2]



Final_Data <- Tidy_Data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(Final_Data, "FinalData.txt", row.name=FALSE)
