# Workshop script for cleaning messy data.
# R version 3.4.0 (2017-04-21)
# KWebbink
# 16-Aug-2017

# # load libraries that will be used in the script
# install.packages("tidyr")
library("tidyr")

# Set the working directory
# Input/Output data-files will go here:
setwd("D:/data-cleaning/data01raw")


# 1 - Melt/Gather Loans Objects ####

# 1a - Import the Loan data
rawLoans <- read.csv("01loans.csv", stringsAsFactors = F)


# 1b - Review the Loan data
# In the Environment pane (top right), click "rawLoans"

# Or, to peek at the first 4 rows in the console:
head(rawLoans)

# To review a specific row:
rawLoans[3,]
# ...or column:
rawLoans[,3]


# 1c - "Gather" (reduce columns/add rows) the data 
tidyLoans <- gather(rawLoans,
                    key = "ObjKey",
                    value = "Objects",
                    2:6)

# 1d - Drop columns you don't want/need
tidyLoans2 <- tidyLoans[,-2]  # drop column 2


# 1e - Drop rows with no objects
tidyLoans3 <- tidyLoans2[nchar(tidyLoans2$Objects)>0,]


# 1f - Sort by Loan number
tidyLoans4 <- tidyLoans3[order(tidyLoans3$Loan),]


# 1g - Export fixed Loan data
write.csv(tidyLoans4, file="tidyLoans.csv", row.names = F)


# # reshape2 is an alternative to tidyr:
# library("reshape2")
# 
# tidyL2 <- melt(messyLoans, 
#                id.vars = "Loan",
#                value.name = "Objects",
#                na.rm=T)


# 2 - Spread/Cast Taxon IDs ####
# Each specimen has multiple Taxon IDs.
# We need all of a specimen's data (with its multiple IDs) in a single row.
# ...But currently we have a specimen's data on multiple rows
# ...Because there is only 1 column for "Taxon ID"

# 2.1 - Import Taxonomy ID data
messyID <- read.csv("02identifications.csv")

# 2.2 - Sort by record number
messyID <- messyID[order(messyID$Cat..Numb.),]

# 2.3 - Make a new table of only the columns containing record-number and ID's
specimenID <- messyID[,c("Cat..Numb.","Full.name")]

# 2.4 - Make a sequence to count the multiple ID's
specimenID$TableSeq <- sequence(rle(as.character(specimenID$Cat..Numb.))$lengths)

# 2.5 - "Spread" (add columns/reduce rows) the table
specimenID2 <- spread(specimenID, TableSeq, Full.name, sep= "_")



# select only the irn, table-field, & irnseq fields
# if you only reported (from EMu) the irn & table-field in a group, this should be correct:
projtest2 <- projtab[,3:5]

proj3 <- spread(projtest2, irnseq, CatProjectInsects)




# In the Environment pane (top right), click "messy"

# If any values look mangled (see the Locality column),
# read.csv() may have used the wrong file encoding.

# Fortunately, you can re-import the CSV with an argument specifying "utf8" (or "latin1"):

messyBID <- read.csv("data01input/BID-data.csv",
                     fileEncoding = "utf8")  # alternatively, "latin1"


