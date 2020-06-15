library(xlsx)
library(foreign)

# Convert a SPSS file to an XLSX file to be read in R
spss_to_R <- function(file, save){
  d <- read.spss(file)
  d <- do.call(cbind.data.frame, d)
  d[d == -9999] <- NA
  write.xlsx(d, save)
}


