# download and unzip source data
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
              "nei.zip", mode = "wb")
unzip("nei.zip")

# read emissions data frame
nei <- readRDS("summarySCC_PM25.rds")
#scc <- readRDS("Source_Classification_Code.rds")

# subset of emissions from Baltimore City, Maryland (fips == 24510)
balt <- nei[nei$fips == "24510",]

# sum all emissions grouped by year
sumBaltEmissionsByYear <- tapply(balt$Emissions, balt$year, sum)

# Start png graphic device
png(filename="plot2.png")

# plot emissions
matplot(rownames(sumBaltEmissionsByYear), sumBaltEmissionsByYear, type="b", lty=1, pch=19,
        xlab="Year", ylab="Total PM2.5 Emissions", xaxt="n", yaxt="n",
        main="Total PM 2.5 Emissions in Baltimore")
axis(1, at=rownames(sumBaltEmissionsByYear))
axis(2, at=c(range(sumBaltEmissionsByYear), mean(sumBaltEmissionsByYear)))

dev.off()