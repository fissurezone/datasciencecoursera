corr <- function(directory, threshold = 0) {
    corrs = integer()
    for (i in 1:332) {
        filename <- file.path(directory, paste(formatC(i, width=3, flag="0"), ".csv", sep=""))
        data <- read.csv(filename, header=TRUE, sep=",")
        data <- data[complete.cases(data),]
        if (nrow(data) > threshold)
            corrs <- c(corrs, cor(data[,"sulfate"], data[,"nitrate"]))
    }
    corrs
}