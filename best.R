best <- function(state, outcome) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## Return hospital name in that state with lowest 30-day death rate
    
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
    
    best_hospitals <- subset(data, mortality == min(data["mortality"]))
    best_hospitals[order(best_hospitals$name), ][1, "name"]
}