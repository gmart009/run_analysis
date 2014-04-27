Data Transformation for tidy data set

The tidy data set was derived from the following steps

1. open the following files from the source data set
a. test data set
b. test data set labels
c. train data set
d. train data set labels
e. subject test set
f. subject train set
g. feature list
h. activity labels

2. The test and train data sets were label based on the features list

3. The label (or activity) and subject data sets were appended to the test and train data sets

4. Columns that did not derive from std and mean were removed from the test and train data sets

5. The train and test data sets were merged together

6. The activity ids were replaced with their respective activity labels using the activity label set in the merged data set

7. The merged data set was group in activity and subject id, averaging each row

8. The new data set is saved to the working directory as tidy.txt

