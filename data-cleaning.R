# Workshop script for cleaning messy data.

# # load libraries that will be used in the script
# install.packages("tidyr")
library("tidyr")

# Set the working directory
# Input/Output data-files will go here:
setwd("D:/data-cleaning/data01")


# 1 - Melt/Gather Loans Objects ####

# 1a - Import the Loan data
messyLoans <- read.csv("01loans.csv", stringsAsFactors = F)


# 1b - Review the Loan data
# In the Environment pane (top right), click "messyLoans"

# Or, to peek at the first 4 rows in the console:
head(messyLoans)

# To review a specific row:
messyLoans[3,]
# ...or column:
messyLoans[,3]


# 1c - "Gather" (reduce columns/add rows) the data 
tidyLoans <- gather(messyLoans,
                    key = "ObjKey",
                    value = "Objects",
                    2:6)


# 1d - Drop columns you don't want/need
tidyLoans <- tidyLoans[,-2]  # drop column 2


# 1e - Drop rows with no objects
tidyLoans <- tidyLoans[nchar(tidyLoans$Objects)>0,]


# 1f - Sort by Loan number
tidyLoans <- tidyLoans[order(tidyLoans$Loan),]


# 1g - Export fixed Loan data
write.csv(tidyLoans, file="tidyLoans.csv", row.names = F)


# # reshape2 is an alternative to tidyr:
# library("reshape2")
# 
# tidyL2 <- melt(messyLoans, 
#                id.vars = "Loan",
#                value.name = "Objects",
#                na.rm=T)


# 2 - Spread/Cast Taxon IDs ####

# Import Taxonomy ID data
messyID <- read.csv("02identifications.csv")

specimenID <- messyID[,c("Cat..Numb.","Full.name")]

# "Spread" (add columns/reduce rows) the table
spread(messyLoans, Loan, Obj)


# In the Environment pane (top right), click "messy"

# If any values look mangled (see the Locality column),
# read.csv() may have used the wrong file encoding.

# Fortunately, you can re-import the CSV with an argument specifying "utf8" (or "latin1"):

messyBID <- read.csv("data01input/BID-data.csv",
                     fileEncoding = "utf8")  # alternatively, "latin1"


