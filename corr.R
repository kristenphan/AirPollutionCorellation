# this function takes in the following parameters:
# 'direction' is a character vector of length 1 indicating the location of the CSV files
# 'threshold' is a numeric vector of length 1 indicating the number of completely observed obersations (on all veraibles) required to compute the correlation between nitrate and sulfate; the default is 0
# the function returns a vector of correlations for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the function should return a numeric vector of length 0
corr <- function(directory, threshold = 0) {
  cr <- c()
  
  if(exists("complete", mode = "function")) {
    source("complete.R")
  } else {
    stop("Could not locate complete.R")
  }
  for(id in 1:332) {
    print(paste("processing file # ",id))
    result <- complete(directory, id)
    complete_rec <- result$df$nobs
    if(complete_rec > 0) {
      if(complete_rec >= threshold) {
        sulfate_dat <- result$sulfate_dat
        nitrate_dat <- result$nitrate_dat
        cor_computed <- cor(sulfate_dat,nitrate_dat)
        cr <- c(cr, cor_computed)
      }
    } 
  }
  cr
}