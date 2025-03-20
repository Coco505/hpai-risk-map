##ebirdst setup (only need to be completed once)
#Install ebirdst from GitHub with:
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("ebird/ebirdst")

#Store eBird Status and Trends Data Products access key where "XXXXX" is the access key provided to you.
set_ebirdst_access_key("XXXXX")

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

#test what files are available to download
ebirdst_download_status("rudduc", dry_run = TRUE)
# File list:
# 2022/rudduc/config.json
# 2022/rudduc/seasonal/rudduc_abundance_full-year_max_27km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_full-year_max_3km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_full-year_max_9km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_full-year_mean_27km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_full-year_mean_3km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_full-year_mean_9km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_max_27km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_max_3km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_max_9km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_mean_27km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_mean_3km_2022.tif
# 2022/rudduc/seasonal/rudduc_abundance_seasonal_mean_9km_2022.tif
# 2022/rudduc/seasonal/rudduc_proportion-population_seasonal_mean_27km_2022.tif
# 2022/rudduc/seasonal/rudduc_proportion-population_seasonal_mean_3km_2022.tif
# 2022/rudduc/seasonal/rudduc_proportion-population_seasonal_mean_9km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_lower_27km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_lower_3km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_lower_9km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_median_27km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_median_3km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_median_9km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_upper_27km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_upper_3km_2022.tif
# 2022/rudduc/weekly/rudduc_abundance_upper_9km_2022.tif
# 2022/rudduc/weekly/rudduc_proportion-population_median_27km_2022.tif
# 2022/rudduc/weekly/rudduc_proportion-population_median_3km_2022.tif
# 2022/rudduc/weekly/rudduc_proportion-population_median_9km_2022.tif

#download the weekly median abundance of all available common BC species at 3km resolution
sapply(na.omit(BC_species_common$ebird_code), ebirdst_download_status, pattern = "_abundance_median_3km_")
