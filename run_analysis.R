## Getting and cleaning data. 

# Have the dataet 'UCI HAR Dataset' and script in the same directory.  

# Installing package
install.packages("reshape2")
library("reshape2")

# Setting Path for Data Directory
dataBaseDir <- "./UCI HAR Dataset/"
dataTestDir <- "./UCI HAR Dataset/test/"
dataTrainDir <- "UCI HAR Dataset/train/"

activity <- read.table(paste0(dataBaseDir, "activity_labels.txt"), header=FALSE, stringsAsFactors=FALSE)
features <- read.table(paste0(dataBaseDir, "features.txt"), header=FALSE, stringsAsFactors=FALSE)

# Importing and preparing Train Data
subject_train <- read.table(paste0(dataTrainDir, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDir, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDir, "y_train.txt"), header=FALSE)
df <- data.frame(Activity = factor(y_train$V1, labels = activity$V2))
trainData <- cbind(df, subject_train, x_train)

# Importing and preparing Test Data
subject_test <- read.table(paste0(dataTestDir, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDir, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDir, "y_test.txt"), header=FALSE)
df <- data.frame(Activity = factor(y_test$V1, labels = activity$V2))
testData <- cbind(df, subject_test, x_test)

# Preparing and writing Tidy Data
dfTidyData <- rbind(testData, trainData)
names(dfTidyData) <- c("Activity", "Subject", features[,2])
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidyData <- dfTidyData[c("Activity", "Subject", select)]
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)

# Preparing and averaging Tidy Data Average
tidyDataMelt <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)
tidyDataMean <- dcast(tidyDataMelt, Activity + Subject ~ variable, mean)
write.table(tidyDataMean, file="./tidyAverageData.txt", row.names=FALSE)

