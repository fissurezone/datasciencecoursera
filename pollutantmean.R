pollutantmean <- function(directory, pollutant, id = 1:332) {
    filenames <- file.path(directory, paste(formatC(id, width=3, flag="0"), ".csv", sep=""))
    data <- do.call(rbind,lapply(filenames, read.csv, header=TRUE, sep=","))
    mean(data[, pollutant], na.rm=TRUE)
}
pollutantmean("/Users/kunalc/src/datasciencecoursera/specdata", "sulfate", 1:10)