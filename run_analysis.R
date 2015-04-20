
# 1. Merges the training and the test sets to create one data set.
xtmp1 <- read.table("train/X_train.txt")
xtmp2 <- read.table("test/X_test.txt")
X <- rbind(xtmp1, xtmp2)

ytmp1 <- read.table("train/Y_train.txt")
ytmp2 <- read.table("test/Y_test.txt")
Y <- rbind(ytmp1, ytmp2)

sub_tmp1 <- read.table("train/subject_train.txt")
sub_tmp2 <- read.table("test/subject_test.txt")
Sub <- rbind(sub_tmp1, sub_tmp2)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt")
indices_of_good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
X <- X[, indices_of_good_features]
names(X) <- features[indices_of_good_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

# 3 . Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")
activities[, 2] <- gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] <- activities[Y[,1], 2]
names(Y) <- "activity"

# 4.  Appropriately labels the data set with descriptive variable names. 

names(Sub) <- "subject"
cleaned <- cbind(Sub, Y, X)
write.table(cleaned, "merged_clean_data.txt")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.

subjects <- unique(Sub)
noSubjects <- length(subjects)
act <- activities[,"V2"]
noActivities <- length(act)
noCol <- ncol(cleaned)

row = 1
for (i in 1:noSubjects){
  for (j in 1:noActivities){
    result[row,1] <- subjects[i,]
    result[row,2] <- act[j]
    tmp <- cleaned[cleaned$subject==i & cleaned$activity==act[j], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "dataset_average.txt", row.name=FALSE)
