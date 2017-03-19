library(dplyr )
library (lubridate)

#dowload and open the data frame
if(!file.exists("./data")){dir.create("./data")}
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_url, "mp1.zip", method = "curl")
data<- unzip("mp1.zip")

data

mp1_1<-read.table("./household_power_consumption.txt", sep = ";", header= F)

#rename the columns
#extract the names
p<-(mp1_1[1,])
p<- as.character.numeric_version(p)
p <- tolower(p)
#asign names to columns
names(mp1_1)<-p
names(mp1_1)
dimen <- dim(mp1_1)
mp1_1 <- mp1_1 [2:dimen[1],]


#onvert the column factor od dates
mp1_1<- mutate(mp1_1, date =as.Date(mp1_1[,1],format ="%d/%m/%Y"))

#paste the dates and the hours
mp1_2<- paste(mp1_1[ ,1], mp1_1 [ ,2])
mp1_2 <- as.character(mp1_2)

#asign posXict format
mp1_2 <- ymd_hms(mp1_2)

#mutate the data frame to include a new column with date-time
mp1_1 <- mutate(mp1_1, date_time= mp1_2)

#subset the dates
mp1_subset<- filter(mp1_1, date>="2007-02-01" & date<="2007-02-02")


#PLOT 3 (Day Week _ Energy Sub Metering)############################################################
par(mfrow = c(1,1))
mp1_char3 <- mp1_subset[complete.cases(mp1_subset) ,]
mp1_char3 <- mutate(mp1_char3, sub_metering_1= as.numeric (levels (mp1_char3 [,7])[mp1_char3 [,7]]))
mp1_char3 <- mutate(mp1_char3, sub_metering_2= as.numeric (levels (mp1_char3 [,8])[mp1_char3 [,8]]))
mp1_char3 <- mutate(mp1_char3, sub_metering_3= as.numeric (levels (mp1_char3 [,9])[mp1_char3 [,9]]))


#Ploting
par (mar= c(2,4,2,2))
with (mp1_char3, plot( date_time, sub_metering_1,"l" ,ylab = "Energy sub metering", xlab = ""))
with (mp1_char3, lines (date_time, sub_metering_2, col= "red"))
with (mp1_char3, lines (date_time, sub_metering_3, col= "blue"))
legend("topright", cex=0.6, lty=c(1,1,1),col=c("black","red", "blue"), 
       legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


#copying plots
dev.copy(png, file= "plot3.png")
dev.off()

