
##This README file gives an overview about how the code in run_analysis.R funtions.

Load the 2 needed packages plyr and dplyr
```{r}
library(plyr)
library(dplyr)
```
Read the features.txt into R which will be used to label our dataframes
```{r}
d_features= read.table("./getting_and_cleaning/features.txt")
```

Import the raw train and test data into R and name the dataframes through the use of d_features
```{r}
d_train_x = read.table("./getting_and_cleaning/train/X_train.txt")
names(d_train_x) <- d_features$V2
d_test_x = read.table("./getting_and_cleaning/test/X_test.txt")
names(d_test_x) <- d_features$V2
```
Rowbind the train and test dataframe in to one big Dataframe with 10299 obs. of 561 variables
```{r}
joined <- rbind(d_test_x, d_train_x)
```
Load the train and test activities into a dataframe rowbind them together and Rename the Columninto "Activity"
```{r}
d_train_y <-read.table("./getting_and_cleaning/train/Y_train.txt")
d_test_y <-read.table("./getting_and_cleaning/test/Y_test.txt")

y_joined <- rbind(d_test_y, d_train_y)
colnames(y_joined) <- "Activity"
```
Load the train and test subjects into a dataframe rowbind them together and Rename the Column into "Subject"
```{r}
d_train_sub <-read.table("./getting_and_cleaning/train/subject_train.txt")
d_test_sub <-read.table("./getting_and_cleaning/test/subject_test.txt")

sub_joined <- rbind(d_test_sub, d_train_sub)
colnames(sub_joined) <- "Subject"
```
Add the Activity and Subject column to the complete the big data frame which now has 10299 obs. of 563 variables
```{r}
joined$Activity <- y_joined$Activity
joined$Subject <- sub_joined$Subject
```
Remove duplicate Columns so that the columns needed can be selected with the select function of the dplyr package
```{r}
joined <- joined[ , !duplicated(colnames(joined))]
```
Select only the columns Activity, Subject and the ones which containt mean() and std()
```{r}
joined_reduced <- select(joined, Activity, Subject, contains("mean()"), contains("std()"))
```


rename the Activity observations from numbers into activity names
```{r}
joined_reduced$Activity[joined_reduced$Activity == "1"] <- "Walking"
joined_reduced$Activity[joined_reduced$Activity == "2"] <- "Walking_Upstairs"
joined_reduced$Activity[joined_reduced$Activity == "3"] <- "Walking_Downstairs"
joined_reduced$Activity[joined_reduced$Activity == "4"] <- "Sitting"
joined_reduced$Activity[joined_reduced$Activity == "5"] <- "Standing"
joined_reduced$Activity[joined_reduced$Activity == "6"] <- "Laying"
```
group the Data by Subject and Activity and write the data into a new data frame called grouped
```{r}
grouped <- joined_reduced %>% group_by(Subject,Activity)
```
compute the mean for each variable which are grouped by Subject and Activity
```{r}
tidy_data_average <-grouped %>% summarise_each(funs(mean))
```
Save the dataframe containing the average for each subject - activity - Measurement combination in the file tidy_data_average.txt
```{r}

write.table(tidy_data_average, file="tidy_data_average.txt", row.name=FALSE)
```
