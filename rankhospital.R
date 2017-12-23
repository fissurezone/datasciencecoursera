rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with the given rank 30-day death rate
    
    data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    if (! (state %in% unique(data[, 7])) ) {
        stop("invalid state")
    }
    
    outcomes <- list(11, 17, 23)
    names(outcomes) <- c("heart attack", "heart failure", "pneumonia")
    
    if (! (outcome %in% names(outcomes)) ) {
        stop("invalid outcome")
    }
    
    options(warn=-1)
    data[, outcomes[[outcome]]] <- as.numeric(data[, outcomes[[outcome]]])
    options(warn=0)
    
    data <- subset(data, State == state, select = c(2, outcomes[[outcome]]))
    data <- data[complete.cases(data), ]
    names(data) <- c("name", "mortality")
    
    if (num == "best") {
        num <- 1
    } else if (num == "worst") {
        num <- nrow(data)
    }
    
    data[order(data$mortality, data$name), ][num, "name"]
}