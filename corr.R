# this function creates and returns a file path from the passed in directory and filename
# example:
# input: directory = "specdata"; file_name = 1
# output: file_path = "specdata/001.csv"
create_file_path <- function(directory,file_name) {
  if (file_name < 10) {
    file_name <- paste("00",file_name,sep="")
  }
  if (file_name >= 10 && file_name <= 99) {
    file_name <- paste("0",file_name,sep="")
  }
  file_path <- paste(directory,"/",file_name,".csv",sep="")
}

# this function takes in the following parameters:
# 'directory' is a character vector of length 1 indicating the location of the CSV files
# 'id' is an integer vector indicating one monitor ID numbers to be used
# the function returns a data frame of the form:
# id nobs
# 1  117
# where 'id' is the monitor ID number and 'nobs' is the number of complete cases
# with complete cases are records in the CSV file where there is no missing data in any column
complete <- function(directory, id) {
  sulfate_col_idx <- 2
  nitrate_col_idx <- 3
  nobs <- c() 
  sulfate_dat <- c()
  nitrate_dat <- c()
  rec_count <- 0 
  file_path <- create_file_path(directory,id)
  data <- read.csv(file_path)
  for (i in 1:nrow(data)) {
    sulfate_val <- data[i,sulfate_col_idx]
    nitrate_val <- data[i,nitrate_col_idx]
    if ((is.na(sulfate_val) == FALSE) & (is.na(nitrate_val) == FALSE)) {
      sulfate_dat <- c(sulfate_dat, sulfate_val)
      nitrate_dat <- c(nitrate_dat, nitrate_val)
      rec_count <- rec_count + 1 
    }
  }
  nobs <- rec_count
  matrix <- cbind(id,nobs)
  df <-data.frame("##",matrix)
  list(df = df, sulfate_dat = sulfate_dat, nitrate_dat = nitrate_dat)
}


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
