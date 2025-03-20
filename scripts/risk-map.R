library(qgisprocess)
library(terra)
library(sf)
library(bcmaps)
library(viridis)
library(tmap)
library(dplyr)
library(ebirdst)

#Load BC-common-species-filter.R Script which contains the 'BC_species_common' dataset
source("BC-common-species-filter.R")

#Load weekly abundance data for each species in the 'BC_species_common' dataset.
#Handle missing data by skipping species with errors
species_raster_list <- lapply(na.omit(BC_species_common$ebird_code), function(species) {
  tryCatch(
    load_raster(species, product = "abundance", period = "weekly", resolution = "3km"),
    error = function(e) NULL  # Skip missing files
  )
})

#Combine loaded rasters into a single raster stack.
species_raster_stack <- do.call(c, raster_list)

#------------------------------------------------------------------------------------------------------
##Cropping to BC and reproject to EPSG:4326 for later mapping

#Set bc boundary
bc_boundary <- bc_bound() #Get the BC boundary polygon
bc_boundary <- st_transform(bc_boundary,crs = crs(species_raster_stack)) #Match species raster's CRS
bc_boundary_vect <- vect(bc_boundary) #Convert to SpatVector

#Crop each raster layer in the species stack to the BC boundary 
abundance_rasters_bc <- rast(lapply(species_raster_stack, function(r) crop(r, ext(bc_boundary_vect))))

#Reproject the cropped abundance rasters to EPSG:4326 (WGS 84) for global compatibility in mapping
abundance_rasters_bc <- project(abundance_rasters_bc, "EPSG:4326", res=0.02664496)

#Optionally plot the first two layers of the reprojected abundance rasters for visual inspection:
#plot(abundance_rasters_bc[[1:2]], main = "Species Abundance Raster")

#-------------------------------------------------------------------------------------------------------
##Normalize bird abundances

#Function to normalize an abundance raster layer:
#Normalization scales the raster values to a 0-1 range based on the min and max values of the layer.
#If all values in the layer are the same (min = max), the layer is returned as 0.
normalize <- function(layer) {
  min_val <- as.numeric(global(layer, "min", na.rm = TRUE))
  max_val <- as.numeric(global(layer, "max", na.rm = TRUE))
  
  if (max_val == min_val) {
    return(layer * 0)  # If all values are the same, return 0
  } else {
    return((layer - min_val) / (max_val - min_val))
  }
}

#Apply normalization to each abundance layer separately
normalized_stack <- rast(lapply(1:nlyr(abundance_rasters_bc), function(i) normalize(abundance_rasters_bc[[i]])))

#Optionally plot the first two layers of the normalized abundance raster stack for visual inspection:
#plot(normalized_stack[[1:2]], main = "Normalized Species Abundance")

#Calculate the sum of all normalized eBird abundance layers.
#The result represents the combined abundance of all species across the study area.
sum_norm_ebird <- sum(normalized_stack, na.rm = TRUE)

#Optionally, plot the summed normalized eBird abundance raster.
#This shows the total relative abundance across all species in the study area.
#plot(sum_norm_ebird)

#----------------------------------------------------------------------------------------------------
##Generate Kernel Density Estimate (KDE) from EMPRESi cases

#Load EMPRESi case data from CSV, skipping the first 14 rows (metadata) and setting the header.
EMPRESi_cases <- read.csv("../data/EMPRESi-BC-allHPAI-2022-24.csv", skip = 14, header = T)

#Convert the case data to an SF (Simple Features) object with Longitude and Latitude as coordinates.
#Set the CRS to EPSG:4326 (WGS 84) initially.
EMPRESi_sf <- st_as_sf(EMPRESi_cases, coords = c("Longitude", "Latitude"), crs = 4326)

#Transform the EMPRESi cases to match the CRS of the normalized bird abundance raster for spatial alignment.
EMPRESi_sf <- st_transform(EMPRESi_sf, crs = st_crs(sum_norm_ebird))

#Save as a shapefile for QGIS processing
st_write(EMPRESi_sf, "EMPRESi_BC_allHPAI_2022-24.shp", delete_layer = TRUE)


#Run the Kernel Density Estimation in QGIS using the heatmap algorithm:
qgis_run_algorithm(
  "qgis:heatmapkerneldensityestimation",
  INPUT = "EMPRESi_BC_allHPAI_2022-24.shp",
  RADIUS = 0.1,  #Approx. 11.1km search radius
  PIXEL_SIZE = res(sum_norm_ebird)[1],  #Match resolution of bird abundance raster
  OUTPUT_VALUE = 0,
  OUTPUT = "EMPRESi_kde.tif"  #Save output as raster
)


#Load the resulting KDE raster and normalize it to a 0-1 range
EMPRESi_kde<- rast("EMPRESi_kde.tif")
EMPRESi_kde <- normalize(EMPRESi_kde)

#Optionally, plot the normalized KDE to visualize the density of EMPRESi cases across BC
#plot(EMPRESi_kde)

#Ensure that both the EMPRESi KDE raster and the bird abundance raster have the same extent and resolution.
EMPRESi_kde <- resample(EMPRESi_kde,sum_norm_ebird)

#Compute risk score: (normalized EMPRESi KDE) × (sum of all normalized bird abundance)
risk_EMPRESi_abundance <- EMPRESi_kde * sum_norm_ebird

#Save the resulting risk score raster
writeRaster(risk_EMPRESi_abundance, "risk_EMPRESi_abundance.tif", overwrite = TRUE)

#Optionally, plot the risk score raster to visualize areas of high risk.
#plot(risk_EMPRESi_abundance)

#------------------------------------------------------------------------------------------------------------
##Visualization 

#Set tmap mode to 'view' for interactive mapping
tmap_mode("view")

#Filter out rows with empty 'animal.type'
EMPRESi_sf_filtered <- EMPRESi_sf %>%
  filter(Animal.type != "")

#Create an interactive map visualizing risk and EMPRESi cases
tm_shape(risk_EMPRESi_abundance) +
  tm_raster(col.legend=tm_legend("Risk Level"), col.scale = tm_scale_continuous(values = "viridis")) +
  tm_shape(EMPRESi_sf_filtered) +  # Add the cases as another layer
  tm_dots(
    col = "Animal.type",  # Use 'animal.type' to color the dots
    palette = c("red","orange","green","yellow","grey"),
    size = 1,  # Adjust size of the points
    border.col = "black",  # Optional border color for dots
    fill_alpha = 0.7,  # Transparency for the cases
  )+
  tm_options(basemap.server = "OpenStreetMap") # Set basemap to OpenStreetMap for background
