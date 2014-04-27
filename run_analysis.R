# The extractData function does not take any parameters
# It merges the test and train data sets into one data set
# the merged data set is saved in the current working directory as tidy.txt

extractData <- function(){
  
  library(data.table)
  path <- "UCI HAR Dataset"
  #----------------
  # Setup path variables
  #----------------
  x_testpath <- paste0(path, "/test/X_test.txt")
  y_testpath <- paste0(path, "/test/y_test.txt")
  subject_testpath <- paste0(path, "/test/subject_test.txt")
  x_trainpath <- paste0(path, "/train/X_train.txt")
  y_trainpath <- paste0(path, "/train/y_train.txt")
  subject_trainpath <- paste0(path, "/train/subject_train.txt")
  featurepath <- paste0(path, "/features.txt")
  activitylabels <- paste0(path, "/activity_labels.txt")
  
  #----------------
  # Open test set
  #----------------
  y_test_data <- read.table(y_testpath, header=F, col.names=c("ActivityID"))
  subject_test_data <- read.table(subject_testpath, header=F, col.names=c("SubjectID"))
  data_cols <- read.table(featurepath, header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  subset_data <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)
  x_test_data <- read.table(x_testpath, header=F, col.names=data_cols$MeasureName)
  x_test_data <- x_test_data[,subset_data]
  
  # Add labels and subject to test data
  x_test_data$ActivityID <- y_test_data$ActivityID
  x_test_data$SubjectID <- subject_test_data$SubjectID
  

  #----------------
  # Open train set
  #----------------
  y_train_data <- read.table(y_trainpath, header=F, col.names=c("ActivityID"))
  subject_train_data <- read.table(subject_trainpath, header=F, col.names=c("SubjectID"))
  data_cols <- read.table(featurepath, header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  subset_data <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)
  x_train_data <- read.table(x_trainpath, header=F, col.names=data_cols$MeasureName)
  x_train_data <- x_train_data[,subset_data]
  
  # Add labels and subject to train data
  x_train_data$ActivityID <- y_train_data$ActivityID
  x_train_data$SubjectID <- subject_train_data$SubjectID

  #----------------
  #merge test set and train set into one data set
  #----------------
  data <- rbind(x_train_data, x_test_data)
  
  #----------------
  # rename variable columns to more friendly names
  #----------------
  cols <- colnames(data)
  cols <- gsub("\\.+mean\\.+", cols, replacement="Mean")
  cols <- gsub("\\.+std\\.+",  cols, replacement="Standard")
  colnames(data) <- cols
  
  # link activity name to records based on activity id
  activity_labels <- read.table(activitylabels, header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
  activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
  data <- merge(data, activity_labels)
  
  #----------------
  # group and average the dataset
  #----------------
  library(reshape2)
  
  variables = c("ActivityID", "ActivityName", "SubjectID")
  measurevariables = setdiff(colnames(data), variables)
  melted_data <- melt(data, id=variables, measure.vars=measurevariables)
  
  data <- dcast(melted_data, ActivityName + SubjectID ~ variable, mean)    
  
  #----------------
  # Write output
  #----------------
  write.table(data, "tidy.txt")

}

