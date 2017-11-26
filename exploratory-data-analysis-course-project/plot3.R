library(ggplot2)
library(dplyr)

# download and unzip source data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              "nei.zip", mode = "wb")
unzip("nei.zip")

# read emissions data frame
nei <- readRDS("summarySCC_PM25.rds")
#scc <- readRDS("Source_Classification_Code.rds")

# subsets of emissions from Baltimore City, Maryland (fips == 24510)
balt <- nei[nei$fips == "24510",]

# sum all emissions grouped by year and by type
sumBaltEmissionsByYearAndType <- aggregate(Emissions ~ type + year, FUN=sum, data=balt)

# plot emissions
ggplot(sumBaltEmissionsByYearAndType, aes(x=year, y=Emissions, group=type, colour=type)) +
  geom_line() + labs(x="Year", y="Total PM2.5 Emissions",
                     title="Total PM 2.5 Emissions in Baltimore\nby source type") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.margin = margin(1.5, 0.5, 0.5, 0.5, "cm"))

# save plot as png
ggsave("plot3.png")