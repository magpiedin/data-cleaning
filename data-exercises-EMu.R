# Workshop script for exercises.
# R version 3.4.0 (2017-04-21)
# KWebbink
# 29-Aug-2017

# # load libraries that will be used in the script
# install.packages("tidyr")
library("tidyr")

# Set the working directory
# Input/Output data-files will go here:
setwd("D:/data-cleaning/data01raw")


# # # # # # # #
# 0 - Plan steps for subsetting & reshaping
# # # # # # # #

# # # # # # # # # # #
#  I. Prep Data  ####
# # # # # # # # # # #

# 1 - Import Workshop data
rawData <- read.csv("WorkshopDatasetV1.csv",
                    stringsAsFactors = F)

# 2 - Add/Combine any columns as needed
rawData$CurrentID <- paste(rawData$Genus, rawData$Species)

# 3 - Subset only the necessary columns
irnID <- rawData[,c("ADP.number", 
                    "CurrentID",
                    "Former.identification")]

# 4 - Melt/Gather Loans Objects
irnID2 <- gather(irnID,
                 key = IDorder,
                 value = Identification,
                 2:3)


# 5 - Re-order & Subset rows
# 5a - Re-order to make "Current" come first
irnID3 <- irnID2[order(irnID2$ADP.number, irnID2$IDorder),]

# 5b - Subset only rows with values in "Identification"
irnID4 <- irnID3[nchar(irnID3$Identification)>0,]


# Export a list of unique Taxa to retrieve Taxonomy IRNs from EMu
write.table(unique(irnID4$Identification), 
            file="../data02output/EMuTaxaSearch.csv", 
            sep=",",
            row.names = F,
            col.names = F)


# # # # # # # #
# II. Search EMu  ####
#     for Taxonomy IRNs corresponding to species names.
# # # # # # # #

# ~6,000 unique taxa; searching in SummaryData
# (+ "Invertebrate Zoology" in Security/Department)
# returns ~17,000 Taxonomy records.
#
# Report out all ~17,000 with the "DataWorkshop - irn Summary" report.
#
# Import the resulting etaxonom.csv data here to merge
# species names with corresponding EMu IRNs (if any match)


# # # # # # # #
# III. Merge EMu irns ####
#      to replace Scientific names
# # # # # # # #

# Import Species names + EMu irns (etaxonom.csv)
emuTaxa <- read.csv(file="etaxonom.csv",
                    stringsAsFactors = F)

# Subset only necessary fields
emuTaxa2 <- emuTaxa[,-1]

# Check for and Remove dups
emuTaxaCheck <- dplyr::count(emuTaxa2, SummaryData)

# Subset unique Taxonomy IRNs
uniqueTaxa <- emuTaxaCheck$SummaryData[which(emuTaxaCheck$n==1)]
emuTaxa3 <- emuTaxa2[which(!emuTaxa2$SummaryData %in% uniqueTaxa),]


# Merge IRNs/Species Names (etaxonom.csv) & irnID4$Identification
irnTaxa <- merge(irnID4, emuTaxa2, 
                 by.x = "Identification",
                 by.y = "SummaryData")

# check unmatched

