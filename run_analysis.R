#read in data
subject_train <- read.table("~/UCI HAR Dataset/train/subject_train.txt", sep="")
subject_test <- read.table("~/UCI HAR Dataset/test/subject_test.txt", sep="")
X_train <- read.table("~/UCI HAR Dataset/train/X_train.txt", sep="")
X_test <- read.table("~/UCI HAR Dataset/test/X_test.txt", sep="")
Y_train <- read.table("~/UCI HAR Dataset/train/Y_train.txt", sep="")
Y_test <- read.table("~/UCI HAR Dataset/test/Y_test.txt", sep="")

#rename columns into decsriptive variable names
features <- read.table("~/UCI HAR Dataset/features.txt")[, 2]
names(X_train)<-features
names(X_test)<-features
names(Y_train)<-"activity"
names(Y_test)<-"activity"
names(subject_train)<-"subject"
names(subject_test)<-"subject"

#reduce data sets to keep only columns regarding mean and std deviations
relevant <- grep("(mean|std)\\(\\)", names(X_train)) 
X_train_reduced <- X_train[, relevant] 
X_test_reduced <- X_test[, relevant] 

#merge train and test data sets into one complete dataframe
train <- cbind(subject_train, Y_train, X_train_reduced) 
test <- cbind(subject_test, Y_test, X_test_reduced) 
completedata <- rbind(train, test)

#convert activities from numeric to descriptive records 
completedata$activity <- factor(completedata$activity, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")) 

#tidy variable names further
names(completedata) <- gsub("^t", "Time", names(completedata))
names(completedata) <- gsub("^f", "Frequency", names(completedata))

#create a new table with means for each subject & activity pair
install.packages("reshape2")
library("reshape2")
variables<-colnames(completedata[,3:68])
tidydata <- dcast(completedata, subject+activity ~ variables, mean)
write.csv(tidydata, "tidy.csv", row.names=FALSE)
