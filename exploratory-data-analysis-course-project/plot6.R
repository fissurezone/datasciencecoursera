# download and unzip source data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              "nei.zip", mode = "wb")
unzip("nei.zip")

# read emissions data frame
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# subset of emissions from Baltimore City, Maryland (fips == 24510)
baltAndLA <- nei[nei$fips %in% c("24510","06037"),]

# subset of motor vehicle sources
sectors <- unique(scc$EI.Sector)
motorVehicleSources <- scc[scc$EI.Sector %in% sectors[grepl("^Mobile - On-Road", sectors)],]

# join motor vehicle sources and emissions data (implcitly by column scc)
motorVehicleEmissions <- inner_join(baltAndLA, motorVehicleSources)

# add descriptive city names
motorVehicleEmissions$city <- ifelse(motorVehicleEmissions$fips == "24510",
                                     "Baltimore",
                                     "Los Angeles")


# sum all emissions grouped by year
sumEmissionsByYearAndCity <- aggregate(Emissions ~ city + year, FUN=sum, data=motorVehicleEmissions)

# plot emissions
ggplot(sumEmissionsByYearAndCity, aes(x=year, y=Emissions, group=city, colour=city)) +
  geom_line() + labs(x="Year", y="Total PM2.5 Emissions",
                     title="Total PM 2.5 Emissions\nfrom motor vehicles\nin Baltimore and Los Angeles") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.margin = margin(1.5, 0.5, 0.5, 0.5, "cm"))

# save plot as png
ggsave("plot6.png")