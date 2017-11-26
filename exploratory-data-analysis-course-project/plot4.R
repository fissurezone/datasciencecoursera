# download and unzip source data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              "nei.zip", mode = "wb")
unzip("nei.zip")

# read emissions data frame
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# subset of coal combustion sources
sectors <- unique(scc$EI.Sector)
coalCombustionSources <- scc[scc$EI.Sector %in% sectors[grepl("[Cc]oal", sectors)],]

# join coal sources and emissions data (implcitly by column scc)
coalEmissions <- inner_join(nei, coalCombustionSources)

# sum all emissions grouped by year
sumEmissionsByYear <- tapply(coalEmissions$Emissions, coalEmissions$year, sum)

# Start png graphic device
png(filename="plot4.png")

# plot emissions
matplot(rownames(sumEmissionsByYear), sumEmissionsByYear, type="b", lty=1, pch=19,
        xlab="Year", ylab="Total PM2.5 Emissions", xaxt="n", yaxt="n",
        main="Total PM 2.5 Emissions\nfrom coal combustion sources")
axis(1, at=rownames(sumEmissionsByYear))
axis(2, at=c(range(sumEmissionsByYear), mean(sumEmissionsByYear)))

dev.off()