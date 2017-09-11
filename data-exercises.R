# Workshop script for exercises.
# R version 3.4.1 (2017-06-30)
# [your emu user name]
# [today's date]

#install.packages("tidyr")
library("tidyr")

# Input data-files will go here:
setwd("C:/Users/kwebbink/Desktop/data-cleaning")

# 1 - Import workshop data
raw_data <- read.csv("data01raw/WorkshopDataset.csv")   #, stringsAsFactors = F)

# 2 - Add/Combine any columns as needed
raw_data$CurrentID <- paste(raw_data$Genus, raw_data$Species)

# 3 - Subset only the necessary columns
raw_id <- raw_data[,c("ADP.number", "CurrentID", "Former.identification")]

# 4 - Gather the current and former ID's
gather_id <- gather(raw_id, 
                    key = IDorder, 
                    value = Identification, 
                    2:3)

# 5 - Re-order rows to make "Current" IDs come first
gather_id2 <- gather_id[order(gather_id$ADP.number, gather_id$IDorder),]

# 6 - Subset only rows with values in "Identification"
#     ...and drop the 2nd column
gather_id3 <- gather_id2[nchar(gather_id2$Identification) > 0, -2]


#  Re-spread the gathered dataframe  ####
# spread-1: Set the ADP.number field to type "Character"
gather_id3$ADP.number <- as.character(gather_id3$ADP.number)

# spread-2: Prep data for spreading by adding a key column
gather_id3$id_row <- sequence(rle(gather_id3$ADP.number)$lengths)

# spread-3: Spread the dataset
spread_id <- spread(gather_id3,
                    key = id_row,
                    value = Identification,
                    fill = "",
                    sep = "_")


#  Export data ####
# export-1.1: Create directory for output
dir.create("data02exports")

# export-1.2: Export the dataframe
write.csv(gather_id3,
          file = "data02exports/gatherID3.csv", 
          row.names = F)


#  Overload :)  ####

install.packages("visdat")
library(visdat)

raw_data2 <- read.csv(file="data01raw/WorkshopDataset.csv",
                      na.strings = "",
                      stringsAsFactors = F)

vis_dat(raw_data2)

# export-2.1: Set up a vector of new column-headings
spread_header <- c("irn", 
                   "IdeIdentificationNotes_tab(1)",
                   "IdeIdentificationNotes_tab(2)")

# export-2.2: Combine the heading-vector with the dataframe
spread_export <- rbind(spread_header, spread_id)

# export-2.3: Export with write.table()
write.table(spread_export,
            file="../data02output/spreadIDs.csv",
            sep = ",",
            row.names = F,
            col.names = F)


# # # # # # # # # # # # # # # # # # # # # #
#  IV. Reshape Data Again... (spread)  ####
# # # # # # # # # # # # # # # # # # # # # #

# 3. Re-Export
spread_header <- c("irn", 
                   "IdeIdentificationNotes_tab(1)",
                   "IdeIdentificationNotes_tab(2)")

spread_export <- rbind(spread_header, spread_id)

write.table(spread_export,
            file="../data02output/spreadIDs.csv",
            sep = ",",
            row.names = F,
            col.names = F)



#### orig! ####

# Workshop script for exercises.
# R version 3.4.1 (2017-06-30)
# KWebbink
# 29-Aug-2017

# # load libraries that will be used in the script
# install.packages("tidyr")
library("tidyr")

# Set the working directory
# Input/Output data-files will go here:
setwd("D:/data-cleaning")


# # # # # # # # # # # # # # # # # # # # # # # #
#  0 - Plan steps for subsetting & reshaping  #
# # # # # # # # # # # # # # # # # # # # # # # #


# # # # # # # # # # # # # # # #
#  I. Import & Prep Data   ####
# # # # # # # # # # # # # # # #

# 1 - Import Workshop data
raw_data <- read.csv("data01raw/WorkshopDatasetV1.csv",
                    stringsAsFactors = F)

# 2 - Add/Combine any columns as needed
raw_data$CurrentID <- paste(raw_data$Genus, raw_data$Species)

# 3 - Subset only the necessary columns
raw_id <- raw_data[,c("ADP.number", 
                      "CurrentID",
                      "Former.identification")]


# # # # # # # # # # # # # # # # # #
#  II. Reshape Data  (gather)  ####
# # # # # # # # # # # # # # # # # #

# 4 - Gather current & former ID's
clean_id <- gather(raw_id,
                   key = IDorder,
                   value = Identification,
                   2:3)


# 5 - Re-order & Subset rows
# 5a - Re-order to make "Current" come first
clean_id2 <- clean_id[order(clean_id$ADP.number, clean_id$IDorder),]

# 5b - Subset only rows with values in "Identification"
#      ...and drop the 2nd column
clean_id3 <- clean_id2[nchar(clean_id2$Identification)>0,-2]


# # # # # # # # # # # # # # # # # #
#  III. Export Reshaped Data   ####
# # # # # # # # # # # # # # # # # #

id_header <- c("irn", 
               "IdeIdentificationNotes_tab(+)")

id4_export <- rbind(id_header, clean_id3) 

write.table(id4_export,
            file="../data02output/cleanIDs.csv", 
            sep=",",
            row.names = F,
            col.names = F)


# # # # # # # # # # # # # # # # # # # # # #
#  IV. Reshape Data Again... (spread)  ####
# # # # # # # # # # # # # # # # # # # # # #

# 1. Prep data for spreading by adding a new column for ID-row-number
clean_id3$id_row <- sequence(rle(clean_id3$ADP.number)$lengths)
clean_id3$id_row <- paste("id", clean_id3$id_row, sep="_")

# 2. Spread the dataset
spread_id <- spread(clean_id3,
                    key = id_row,
                    value = Identification,
                    fill = "")

# 3. Re-Export
spread_header <- c("irn", 
                   "IdeIdentificationNotes_tab(1)",
                   "IdeIdentificationNotes_tab(2)")

spread_export <- rbind(spread_header, spread_id)

write.table(spread_export,
            file="../data02output/spreadIDs.csv",
            sep = ",",
            row.names = F,
            col.names = F)

