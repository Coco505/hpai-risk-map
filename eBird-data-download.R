#Install ebirdst from GitHub with:
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("ebird/ebirdst")

#If haven't already done so, store eBird Status and Trends Data Products access key 
#via function set_ebirdst_access_key("XXXXX"), where "XXXXX" is the access key provided to you.

library(ebirdst)
library(dplyr)

BC_species <- read.csv("BC-Bird-Species-List-(Avibase).csv")

#filter only the common species and non-introduced
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


#download all abundance files and load raster
#ebirdst_download_status(species = "rudduc")
#load_raster("rudduc", resolution = "3km")
#list of files that will be downloaded:
#Downloading Status Data Products for rudduc
  # Downloading file 1 of 28: config.json
  # Downloading file 2 of 28: rudduc_abundance_full-year_max_27km_2022.tif
  # Downloading file 3 of 28: rudduc_abundance_full-year_max_3km_2022.tif
  # Downloading file 4 of 28: rudduc_abundance_full-year_max_9km_2022.tif
  # Downloading file 5 of 28: rudduc_abundance_full-year_mean_27km_2022.tif
  # Downloading file 6 of 28: rudduc_abundance_full-year_mean_3km_2022.tif
  # Downloading file 7 of 28: rudduc_abundance_full-year_mean_9km_2022.tif
  # Downloading file 8 of 28: rudduc_abundance_seasonal_max_27km_2022.tif
  # Downloading file 9 of 28: rudduc_abundance_seasonal_max_3km_2022.tif
  # Downloading file 10 of 28: rudduc_abundance_seasonal_max_9km_2022.tif
  # Downloading file 11 of 28: rudduc_abundance_seasonal_mean_27km_2022.tif
  # Downloading file 12 of 28: rudduc_abundance_seasonal_mean_3km_2022.tif
  # Downloading file 13 of 28: rudduc_abundance_seasonal_mean_9km_2022.tif
  # Downloading file 14 of 28: rudduc_proportion-population_seasonal_mean_27km_2022.tif
  # Downloading file 15 of 28: rudduc_proportion-population_seasonal_mean_3km_2022.tif
  # Downloading file 16 of 28: rudduc_proportion-population_seasonal_mean_9km_2022.tif
  # Downloading file 17 of 28: rudduc_abundance_lower_27km_2022.tif
  # Downloading file 18 of 28: rudduc_abundance_lower_3km_2022.tif
  # Downloading file 19 of 28: rudduc_abundance_lower_9km_2022.tif
  # Downloading file 20 of 28: rudduc_abundance_median_27km_2022.tif
  # Downloading file 21 of 28: rudduc_abundance_median_3km_2022.tif
  # Downloading file 22 of 28: rudduc_abundance_median_9km_2022.tif
  # Downloading file 23 of 28: rudduc_abundance_upper_27km_2022.tif
  # Downloading file 24 of 28: rudduc_abundance_upper_3km_2022.tif
  # Downloading file 25 of 28: rudduc_abundance_upper_9km_2022.tif
  # Downloading file 26 of 28: rudduc_proportion-population_median_27km_2022.tif
  # Downloading file 27 of 28: rudduc_proportion-population_median_3km_2022.tif
  # Downloading file 28 of 28: rudduc_proportion-population_median_9km_2022.tif

#test what file will be downloaded, pattern is specifying only the full-year mean 
#at 3km resolution
#ebirdst_download_status("rudduc", pattern = "_full-year_mean_3km_", dry_run = TRUE)

sapply(na.omit(BC_species_common$ebird_code), ebirdst_download_status, pattern = "_full-year_mean_3km_", dry_run = TRUE)

