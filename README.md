# BC HPAI Geospatial Risk Mapping

This project aims to generate risk maps that combine bird species abundance data from eBird and EMPRESi (Emergency Prevention System for Animal Diseases) cases for Highly Pathogenic Avian Influenza (HPAI) in British Columbia (BC), Canada. The goal is to assess the potential risk of disease transmission based on bird species abundance and the spatial distribution of HPAI cases.

- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Data](#data)

## Repository Structure
```
├── .gitignore
├── README.md
├── data <- Contains the raw data files used in the project
│   ├── BC-Bird-Species-List-(Avibase).csv     --> A list of bird species in BC extracted from Avibase
│   ├── EMPRESi-BC-allHPAI-2022-24.csv         --> A CSV of EMPRESi HPAI case data for BC
├── scripts                                    --> Contains the R scripts for processing the data and generating the risk map
│   ├── BC-common-species-filter.R             --> Script for filtering common, non-introduced bird species in BC
│   ├── eBird-data-download.R                  --> Script for downloading eBird data on bird species abundance
│   ├── risk-map.R                             --> Main script for processing data, calculating risk, and generating maps
```
## Quick Start
### Clone the repository to your local machine
```bash
git clone https://github.com/Coco505/hpairiskmap.git
cd hpairiskmap
```
### Open R and install required packages (if not already installed)
```
install.packages(c("qgisprocess", "terra", "sf", "bcmaps", 
                   "viridis", "tmap", "dplyr", "ebirdst"))
```
### Step 1: `Run scripts/eBird-data-download.R`
- **Aim**: This script sources the BC-common-species-filter.R script which imports BC-Bird-Species-List-(Avibase).csv and filters it to obtain a dataframe of common, non-introduced BC bird species and their corresponding eBird codes. It then downloads the weekly median abundance raster at 3km resolution for each species with available data. Parameters can be modified if alternative data (e.g., mean full-year abundance) is needed.
- **Input**: `data/BC-Bird-Species-List-(Avibase).csv`
- **Dependencies**: `scripts/BC-common-species-filter.R`
- **Output**: Weekly median abundance rasters downloaded at 3km resolution for common BC bird species
- **Note**:
  - The estimated total size of all the weekly median abundance rasters at 3km resolution is ~**20GB**.
  - After the initial run, re-running the script is unnecessary unless new data is required. The data path to the downloaded rasters can be located via the `ebirdst_data_dir()` function.
### Step 2: Run `scripts/risk-map.R`
- **Aim**: This is the main script of the project. It processes the normalized eBird bird abundance rasters and the EMPRESi case data to generate a risk map of HPAI (Highly Pathogenic Avian Influenza) spread, based on bird abundance and case density. It performs kernel density estimation (KDE) on the EMPRESi case data and calculates a risk score by combining the normalized bird abundance with the EMPRESi KDE output.
- **Input**: `data/EMPRESi-BC-allHPAI-2022-24.csv` and downloaded eBird species abundance rasters
- **Dependencies**: `scripts/BC-common-species-filter.R`
- **Output**:
  - `EMPRESi_kde.tif` --> KDE raster representing HPAI case density
  - `risk_EMPRESi_abundance.tif` --> Raster representing HPAI risk based on bird abundance and case density
  - Interactive map displaying `risk_EMPRESi_abundance.tif`
- **Note**:
  - Output rasters are in EPSG:4326 (WGS 84) projection.
  - The kernel density estimation (KDE) uses a 11.1 km radius as it aligns with HPAI control zones (typically 10 km) while providing a slight buffer. It also corresponds to 0.1 degrees in EPSG:4326 (WGS 84), simplifying calculations by avoiding additional decimal precision.
