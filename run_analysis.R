
library(plyr)
library(dplyr)

d_features= read.table("./features.txt")
d_train_x = read.table("./train/X_train.txt")
names(d_train_x) <- d_features$V2
d_test_x = read.table("./test/X_test.txt")
names(d_test_x) <- d_features$V2
joined <- rbind(d_test_x, d_train_x)


d_train_y <-read.table("./train/Y_train.txt")
d_test_y <-read.table("./test/Y_test.txt")

y_joined <- rbind(d_test_y, d_train_y)
colnames(y_joined) <- "Activity"

d_train_sub <-read.table("./train/subject_train.txt")
d_test_sub <-read.table("./test/subject_test.txt")

sub_joined <- rbind(d_test_sub, d_train_sub)
colnames(sub_joined) <- "Subject"


joined$Activity <- y_joined$Activity
joined$Subject <- sub_joined$Subject


joined <- joined[ , !duplicated(colnames(joined))]

joined_reduced <- select(joined, Activity, Subject, contains("mean()"), contains("std()"))




joined_reduced$Activity[joined_reduced$Activity == "1"] <- "Walking"
joined_reduced$Activity[joined_reduced$Activity == "2"] <- "Walking_Upstairs"
joined_reduced$Activity[joined_reduced$Activity == "3"] <- "Walking_Downstairs"
joined_reduced$Activity[joined_reduced$Activity == "4"] <- "Sitting"
joined_reduced$Activity[joined_reduced$Activity == "5"] <- "Standing"
joined_reduced$Activity[joined_reduced$Activity == "6"] <- "Laying"


grouped <- joined_reduced %>% group_by(Subject,Activity)
tidy_data_average <-grouped %>% summarise_each(funs(mean))

write.table(tidy_data_average, file="tidy_data_average.txt", row.name=FALSE)

