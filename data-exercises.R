# Workshop script for exercises.
# R version 3.4.1 (2017-06-30)
# [your emu user name]
# [today's date]

#install.packages("tidyr")
library("tidyr")

# Input data-files will go here:
setwd("C:/Users/kwebbink/Desktop/data-cleaning")

# I: Import & Setup data  ####
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


# II: Re-spread the gathered dataframe  ####
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


# III: Export data ####
# export-1.1: Create directory for output
dir.create("data02exports")

# export-1.2: Export the dataframe
write.csv(gather_id3,
          file = "data02exports/gatherID3.csv", 
          row.names = F)


#  Extras...
#  extra-I: visdat Package ####
install.packages("visdat")
library(visdat)

raw_data2 <- read.csv(file="data01raw/WorkshopDataset.csv",
                      na.strings = "",
                      stringsAsFactors = F)

vis_dat(raw_data2)


#  extra-II: export with write.table()  ####
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
