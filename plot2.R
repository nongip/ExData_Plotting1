print("Hello, this is my version")
print(version)

yourdirectory<-"H:/CasaUfficio/R notes/Expoloratory Data Analysis/W1/week1project" #here you plug in yours
#create dir
setwd(yourdirectory)
if(!file.exists("data")) {
  dir.create("data")
}
setwd(".\\data")
#download data
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("data.zip")) {
  download.file(url,destfile="data.zip")
  dateDownloaded<-date()
  print(dateDownloaded)
}
mydir<-getwd()
print(mydir)
#unzip data
if(!file.exists("household_power_consumption.txt")) {
  unzip("data.zip", exdir=mydir)  
}
fileslist<-list.files(path=mydir,pattern="*.txt", full.names=TRUE, recursive=TRUE) #browse through the unzipped folder
fileslist
filename<-fileslist
df<-read.table(fileslist,skip=grep("31/1/2007", readLines(filename)),nrows=(1439+1440*2),sep=";") #"skip"-mode read of only lines starting from the day before the of interest. Then choose an adequate number of rows to have the full of the next two days as well
firstrow<-read.table(fileslist,nrows=1,sep=";",header=T) #read a 1-row df for the sake of collecting the var names
names(df)<-names(firstrow) #assign the right names to data
head(df) #see shape of data and number of columns
dim(df) #see number of rows
table(df$Date) #see what dates have been included in the "skip"-mode read table
df$Date<-as.Date(as.character(df$Date),format="%d/%m/%Y") #change format of Date for easier subsetting
dfRedux<-subset(df, (Date==as.Date(as.character("2007-02-01",format="%Y-%m-%d")) | Date==as.Date(as.character("2007-02-02",format="%Y-%m-%d"))))
table(dfRedux$Date) #make sure we have the right amount of observations per date
grep("\\?",dfRedux$Global_active_power) #make sure no "?", which should be treated as NA are around
Sys.setlocale("LC_TIME", "English") #set system language to english, so weeknames will be in english
DateTime<-as.POSIXct(paste(dfRedux$Date, dfRedux$Time), format="%Y-%m-%d %H:%M:%S") #create DateTime var
png(filename ="plot2.png") #create png device for plot2

plot(DateTime,dfRedux$Global_active_power, type="n",ylab="Global Active Power (kilowatts)",xlab="") #an empty graph with the right labels
lines(DateTime,dfRedux$Global_active_power) #the requested time series visualization
dev.off() #close the device

