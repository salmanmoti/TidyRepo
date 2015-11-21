#---------------------------------------------------------------------------------------------
# This merges 'test' and 'train' datasets to create a single dataset.
#---------------------------------------------------------------------------------------------
X.test<-read.table('./UCI HAR Dataset/test/X_test.txt')
X.train<-read.table('./UCI HAR Dataset/train/X_train.txt')

y.test<-read.table('./UCI HAR Dataset/test/y_test.txt')
y.train<-read.table('./UCI HAR Dataset/train/y_train.txt')

Sub.test<-read.table('./UCI HAR Dataset/test/subject_test.txt')
Sub.train<-read.table('./UCI HAR Dataset/train/subject_train.txt')

X<-rbind(X.test,X.train)
y<-rbind(y.test,y.train)
Sub<-rbind(Sub.train,Sub.test)

#---------------------------------------------------------------------------------------------
# This extracts only the measurements on the mean and standard deviation for each measurement.
#---------------------------------------------------------------------------------------------
Features<-read.table('./UCI HAR Dataset/features.txt')
Mean.Std<-grep("-mean\\(\\)|-std\\(\\)",Features[,2])
X.Mean.Std<-X[,mean.sd]

#---------------------------------------------------------------------------------------------
# This uses descriptive activity names to name the activities in the data set.
#---------------------------------------------------------------------------------------------
names(X.Mean.Std)<-features[mean.sd,2]
names(X.Mean.Std)<-tolower(names(X.Mean.Std)) 
names(X.Mean.Std)<-gsub("\\(|\\)","",names(X.Mean.Std))

ActLab<-read.table('./UCI HAR Dataset/activity_labels.txt')
ActLab[,2]<-tolower(as.character(ActLab[,2]))
ActLab[,2]<-gsub("_","",ActLab[,2])

y[,1]=ActLab[y[,1],2]
colnames(y)<-'activity'
colnames(Sub)<-'subject'

#---------------------------------------------------------------------------------------------
# This appropriately labels the data set with descriptive variable names.
#---------------------------------------------------------------------------------------------
TheLabledData<-cbind(Sub,X.Mean.Std,y)
str(TheLabledData)
write.table(TheLabledData,'./Proj/TheLabledData.txt',row.names=FALSE)

#---------------------------------------------------------------------------------------------
# This creates a second, independent tidy data set with the average of each variable for each 
# activity and each subject.
#---------------------------------------------------------------------------------------------
AvgDf<-aggregate(x=TheLabledData,by=list(ActLab=TheLabledData$activity,Sub=TheLabledData$subject),FUN=mean)
AvgDf<-AvgDf[,!(colnames(AvgDf)%in%c("Sub","Act"))]
str(AvgDf)
write.table(AvgDf,'./Proj/AvgOfEachVarForEachActAndSub.txt',row.names=FALSE)