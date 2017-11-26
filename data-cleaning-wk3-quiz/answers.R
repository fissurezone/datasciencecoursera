# qn 1: Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products.
# Assign that logical vector to the variable agricultureLogical.
# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# which(agricultureLogical)
# What are the first 3 values that result?

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "acs.csv")
d <- read.csv("acs.csv")
agricultureLogical <- d$ACR == 3 & d$AGS == 6
which(agricultureLogical)

# qn 2: Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?
# (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "jeff.jpg", mode="wb")
i<-readJPEG("jeff.jpg", native=T)
quantile(i, probs = c(0.3, 0.8))


# qn 3: Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame?

library(dplyr)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv")
gdp <- read.csv("gdp.csv", skip=5, header=F, nrows=190)
colnames(gdp) <- c("CountryCode", "Ranking", "NA1", "Name", "GDP", "NA2", "NA3", "NA4", "NA5", "NA6")
gdp <- gdp[!gdp$CountryCode == "",]
gdp <- gdp[!gdp$Ranking == "",]
gdp$GDP <- gsub(",", "", gdp$GDP)
gdp$Ranking <- as.numeric(gdp$Ranking)
gdp$GDP <- as.numeric(gdp$GDP)
gdp <- as.data.frame(gdp)
gdp <- select(gdp, c("CountryCode", "Ranking", "Name", "GDP"))

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "edu.csv")
edu <- read.csv("edu.csv")
edu <- as.data.frame(edu)

m <- merge(gdp, edu, by = "CountryCode")
arrange(m, desc(Ranking))[13,1:5]
nrow(m)

# qn 4: What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
summarise(group_by(m, Income.Group), mean(Ranking))

# qn 5: Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
# How many countries are Lower middle income but among the 38 nations with highest GDP?
table(cut2(m$Ranking, g=5), m$Income.Group)