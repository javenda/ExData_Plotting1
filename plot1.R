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

#PLOT 1 (GLOBAL ACTIVE POWER FREQUENCY)

par(mfrow = c(1,1))
mp1_char1 <- mutate(mp1_subset, global_active_power= as.numeric (levels (mp1_subset[,3])[mp1_subset[,3]]))
hist (mp1_char1$global_active_power, col="red", xlab = "Global Active Power (kilowatts)", ylab= "Frequency", main = "Global Active Power")
#copying plots
dev.copy(png, file= "plot1.png")
dev.off()
