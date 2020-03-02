library(dplyr) #packge for transformation and tidy data
library(curl) #packege for to downlods the dataset
library(zip) #packege for to unzip dataset

curl_download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip")

if (!file.exists("UCI HAR Dataset")) { 
    unzip("Dataset.zip") 
}

# 1. Merges the training and the test sets to create one data set.

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))


x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

X<-bind_rows(x_test, x_train)
names(X)<-features[,2]


y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

Y<-bind_rows(y_test, y_train)



subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

Subject<-bind_rows(subject_test, subject_train)

Merged_Data<-bind_cols(Subject, Y, X)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

names_mean<-grep("mean", names(Merged_Data), value=T)
names_std<-grep("std", names(Merged_Data), value=T)


Tidy_Data<-select(Merged_Data, subject, code, all_of(names_mean), all_of(names_std))


# 3. Uses descriptive activity names to name the activities in the data set

Tidy_Data[,"code"] <- activity_labels[Tidy_Data[,"code"], 2]


# 4. Appropriately labels the data set with descriptive variable names.
names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



Final_Data <- Tidy_Data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

write.table(Final_Data, "FinalData.txt", row.name=FALSE)

