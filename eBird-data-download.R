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
