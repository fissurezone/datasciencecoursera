complete <- function(directory, id = 1:332) {
    complete_obs <- data.frame(id=integer(), nobs=integer())
    for (i in id) {
        filename <- file.path(directory, paste(formatC(i, width=3, flag="0"), ".csv", sep=""))
        data <- read.csv(filename, header=TRUE, sep=",")
        data <- data[complete.cases(data),]
        complete_obs[nrow(complete_obs) + 1,] = list(i, nrow(data))
    }
    complete_obs
}