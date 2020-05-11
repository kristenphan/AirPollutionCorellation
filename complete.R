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
