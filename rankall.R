rankall <- function(outcome, num = 1) {
    ## Read outcome data
    ## Check that state and outcome are valid
    ## For each state, find the hospital of the given rank
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
 
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
    
    data <- data[, c(2, 7, outcomes[[outcome]])]
    data <- data[complete.cases(data), ]
    names(data) <- c("name", "state", "mortality")
    
    decreasing = F
    if (num == "best") {
        num <- 1
    } else if (num == "worst") {
        decreasing = T
        num <- 1
    }
    
    split.data <- split(data, data$state)
    split.data <- lapply(split.data, function(x) x[order(x$mortality, x$name, decreasing = decreasing), ][num, "name"])
    rank.all.states <- as.data.frame(do.call(rbind, split.data))
    rank.all.states$state <- rownames(rank.all.states)
    names(rank.all.states) <- c("hospital", "state")
    rank.all.states
}