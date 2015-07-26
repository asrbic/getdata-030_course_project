library(plyr)

outputDir <- './'
baseDir <- './UCI HAR Dataset/'
testDir <- paste0(baseDir, 'test/')
trainDir <- paste0(baseDir, 'train/')

x_test <-       read.table(paste0(testDir, 'X_test.txt'))
y_test <-       read.table(paste0(testDir, 'y_test.txt'))
subject_test <- read.table(paste0(testDir, 'subject_test.txt'))
names(subject_test) <- c('subject')

x_train <-      read.table(paste0(trainDir, 'X_train.txt'))
y_train <-      read.table(paste0(trainDir, 'y_train.txt'))
subject_train <-read.table(paste0(trainDir, 'subject_train.txt'))
names(subject_train) <- c('subject')

x_test <- data.frame(mean=rowMeans(x_test), stdev=apply(x_test, 1, sd))
x_train <- data.frame(mean=rowMeans(x_train), stdev=apply(x_train, 1, sd))

test <- cbind(y_test, subject_test, x_test)
train <- cbind(y_train, subject_train, x_train)

all <- rbind(train, test)

action_labels  <- read.table(paste0(baseDir, 'activity_labels.txt'))
names(action_labels) <- c('activity_id', 'activity')
all <- merge(all, action_labels, by.x=1, by.y=1)[,c(5,2,3,4)]
allSplit <- split(x=all, f=list(all$activity, all$subject))

cleanData <- data.frame(row.names = names(all))
for (df in allSplit)
{
  cleanData <- rbind(cleanData, cbind(df[1,1:2], mean(df[,3]), mean(df[,4])))
  
}
names(cleanData) <- names(all)
rownames(cleanData) <- 1:nrow(cleanData)
write.table(cleanData,file = paste0(outputDir, 'tidy_data.txt'), row.names = FALSE)