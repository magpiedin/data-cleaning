# Workshop script for cleaning messy data.

# Input/Output data-files will go here:
#setwd(“C:/path/to/project/directory”)
origdir <- getwd()

setwd(paste0(origdir,"/data01input"))

messy <- read.csv("BID-data.csv")

