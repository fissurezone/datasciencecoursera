# Question 1: Download the 2006 microdata survey about housing for the state of Idaho using download.file()
# from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# and load the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Apply strsplit() to split all the names of the data frame on the characters "wgtp".
# What is the value of the 123 element of the resulting list?

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv")
d <- read.csv("acs.csv")
lapply(names(d), strsplit, "wgtp")[123]

# Question 2: Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
gdp <- read.csv("gdp.csv", skip=5, header=F, nrows=190)
mean(as.numeric(str_trim(gsub(",", "", gdp$V5))))

# Question 3:In the data set from Question 2 what is a regular expression that would allow you to count
# the number of countries whose name begins with "United"? Assume that the variable with the country

countryNames <- gdp[,4]
length(grep("^United", countryNames))

# Question 4: Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode.
# Of the countries for which the end of the fiscal year is available, how many end in June?


library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
gdp <- read.csv("gdp.csv", skip=5, header=F, nrows=190)
colnames(gdp) <- c("CountryCode", "Ranking", "NA1", "Name", "GDP", "NA2", "NA3", "NA4", "NA5", "NA6")
gdp <- gdp[!gdp$CountryCode == "",]
gdp <- gdp[!gdp$Ranking == "",]
gdp <- select(gdp, c("CountryCode", "Ranking", "Name", "GDP"))
gdp$GDP <- gsub(",", "", gdp$GDP)
gdp$Ranking <- as.numeric(gdp$Ranking)
gdp$GDP <- as.numeric(gdp$GDP)
gdp <- as.data.frame(gdp)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv")
edu <- read.csv("edu.csv")
edu <- as.data.frame(edu)

m <- merge(gdp, edu, by = "CountryCode")
length(grep("Fiscal year end: June", m$Special.Notes))

# Question 4: You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices
# for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data on
# Amazon's stock price and get the times the data was sampled.
# How many values were collected in 2012? How many values were collected on Mondays in 2012?

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

library(lubridate)
sampleTimes2012 <- sampleTimes[year(sampleTimes)==2012]
length(sampleTimes2012)
length(sampleTimes2012[weekdays(sampleTimes2012)=="Monday"])
