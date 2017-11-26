# download and unzip source data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              "nei.zip", mode = "wb")
unzip("nei.zip")

# read emissions data frame
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# subset of emissions from Baltimore City, Maryland (fips == 24510)
balt <- nei[nei$fips == "24510",]

# subset of motor vehicle sources
sectors <- unique(scc$EI.Sector)
motorVehicleSources <- scc[scc$EI.Sector %in% sectors[grepl("^Mobile - On-Road", sectors)],]

# join motor vehicle sources and baltimore emissions data (implcitly by column scc)
motorVehicleBaltimoreEmissions <- inner_join(balt, motorVehicleSources)

# sum all emissions grouped by year
sumEmissionsByYear <- tapply(motorVehicleBaltimoreEmissions$Emissions,
                             motorVehicleBaltimoreEmissions$year, sum)

# Start png graphic device
png(filename="plot5.png")

# plot emissions
matplot(rownames(sumEmissionsByYear), sumEmissionsByYear, type="b", lty=1, pch=19,
        xlab="Year", ylab="Total PM2.5 Emissions", xaxt="n", yaxt="n",
        main="Total PM 2.5 Emissions in Baltimore\nfrom motor vehicle sources")
axis(1, at=rownames(sumEmissionsByYear))
axis(2, at=c(range(sumEmissionsByYear), mean(sumEmissionsByYear)))

dev.off()