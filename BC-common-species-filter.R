##ebirdst setup (only need to be completed once):

#Install ebirdst from GitHub with:
# if (!requireNamespace("remotes", quietly = TRUE)) {
#   install.packages("remotes")
# }
# remotes::install_github("ebird/ebirdst")

#Store eBird Status and Trends Data Products access key where "XXXXX" is the access key provided to you:
# set_ebirdst_access_key("XXXXX")

#----------------------------------------------------------------------------------------------
library(ebirdst)
library(dplyr)

BC_species <- read.csv("BC-Bird-Species-List-(Avibase).csv")

#filter only the common and non-introduced species 
BC_species_common <- filter(BC_species, Species != "" & Rarity == "")

#get ebird codes for each common species
BC_species_common <- BC_species_common %>% 
  mutate(ebird_code = get_species(Species))

#Species with missing ebird_code:
#Note:abundance data is available for download for these species on eBird website, 
#but they are 2021 data and is thus not in the ebirdst data product (2022)
#Users are strongly discouraged from comparing Status and Trends results between 
#years due to methodological differences between versions
not_in_ebird <-  BC_species_common %>%
  filter(is.na(ebird_code))

