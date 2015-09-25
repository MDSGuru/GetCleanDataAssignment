#Getting and Cleaning Data Class Project
#Wearable Computing
#Summarizing data for Accelerometers from the Samsung Galaxy S smartphone

setwd("C:\\Users\\Kristeen.Kratz\\Documents\\DataScience_Training\\GetCleanData\\UCI HAR Dataset")

#Read in and name Activity and Features Labels
activityLabels<-read.table(".\\activity_labels.txt", sep="")
names(activityLabels)<-c("ActivityID","Activity")

featuresRaw<-read.table(".\\features.txt", sep="")
#Keep labels only
featuresRaw2<-featuresRaw["V2"]
#Identify mean and std rows in the Features labels
MeanStd<-grep("mean\\(|std\\(",featuresRaw2$V2)
featuresRaw3<-featuresRaw2[MeanStd,]
#Create clean feature labels
CleanFeatureNames <- sapply(featuresRaw3, function(x) {gsub("[()]", "",x)})

#Read in and name all Training Data

#Training Subject ID's
subjTrain<-read.table(".\\train\\subject_train.txt", sep="")
names(subjTrain)<-c("SubjectID") 

#Training Data
XTrain<-read.table(".\\train\\X_train.txt", sep="")
#Use this to keep the appropriate mean and std columns
XTrain<-XTrain[,MeanStd]
names(XTrain)<-CleanFeatureNames

#Training Activity Codes
YTrain<-read.table(".\\train\\Y_train.txt", sep="")
names(YTrain)<-c("ActivityID")
#merge in Activity Labels
YTrain<-merge(YTrain,activityLabels)

#Join Training Data into a single Data Frame
rawTrain<-cbind(subjTrain,XTrain,YTrain) #7352 obs

#Read in all Test Data

#Test Subject ID's
subjTest<-read.table(".\\test\\subject_test.txt", sep="")
names(subjTest)<-c("SubjectID")

#Test Data
XTest<-read.table(".\\test\\X_test.txt", sep="")
#Use this to keep the appropriate mean and std columns
XTest<-XTest[,MeanStd]
names(XTest)<-CleanFeatureNames

#Test Activity Codes
YTest<-read.table(".\\test\\Y_test.txt", sep="")
names(YTest)<-c("ActivityID")
#merge in Activity Labels
YTest<-merge(YTest,activityLabels)

#Join Test Data into a single Data Frame
rawTest<-cbind(subjTest,XTest,YTest) #2747 obs

#Stack Training and Test Data Frames
CleanTotal<-rbind(rawTrain,rawTest) #10299 obs


#Creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject

#Drop Activity
temp<-CleanTotal[-69]
#Compute Means
tempmeans<-aggregate(temp, by = list(temp$SubjectID, temp$ActivityID), FUN = "mean", na.rm=TRUE)


#merge Activity back in and clean up
tempmeansact<-merge(tempmeans,activityLabels)
tempmeansact2<-tempmeansact[c(-2,-3)]
tempmeansact3<-tempmeansact2[,c(2,1,69,3:67)]
colnames(tempmeansact3)[colnames(tempmeansact3)=="Activity.y"] <- "Activity"

CleanTotalMeans<-tempmeansact3

#export to text file
write.table(CleanTotalMeans, "CleanTotalMeans.txt",row.names=FALSE)




