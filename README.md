# BC HPAI Geospatial Risk Mapping

This project aims to generate risk maps that combine bird species abundance data from eBird and EMPRESi (Emergency Prevention System for Animal Diseases) cases for Highly Pathogenic Avian Influenza (HPAI) in British Columbia (BC), Canada. The goal is to assess the potential risk of disease transmission based on bird species abundance and the spatial distribution of HPAI cases.

- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Data](#data)
- [Scripts](#scripts)

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
### **Important**: Ensure QGIS is Installed
- The `qgisprocess` package interfaces with QGIS, a powerful open-source GIS tool. You **must have QGIS installed** on your system to run the scripts that rely on this package.
- Download QGIS from the official [QGIS website](https://qgis.org/).
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
  - The kernel density estimation uses a 11.1 km radius as it aligns with HPAI control zones (typically 10 km) while providing a slight buffer. It also corresponds to 0.1 degrees in EPSG:4326 (WGS 84), simplifying calculations by avoiding additional decimal precision.
 
## Data
### 1. `data/BC-Bird-Species-List-(Avibase).csv`
- **Source**: Avibase
- **Description**: This dataset includes a list of bird species found in British Columbia.
  
### 2. `data/EMPRESi-BC-allHPAI-2022-24.csv`
- **Source**: Food and Agriculture Organization's EMPRES Global Animal Disease Information System (EMPRES-i+), filtered to include all HPAI setorypes in BC
- **Description**: This dataset contains HPAI case data from 2022 to 2024 for British Columbia.
 
## Scripts
### 1. `scripts/BC-common-species-filter.R`
- **Description***: Filters the BC-Bird-Species-List-(Avibase).csv to include common, non-introduced bird species. This step prepares the bird species data for further analysis and downloading of abundance data.
### 2. `scripts/eBird-data-download.R`
- **Description***: Downloads weekly median bird abundance rasters for BC species. The data is obtained from eBird and is available at a 3 km resolution. Parameters can be adjusted to download alternative data from eBird.
### 3. `scripts/risk-map.R`
- **Description***: This script combines bird abundance data and HPAI case data to generate a risk map of HPAI spread. It uses kernel density estimation to estimate case density and combines this with bird abundance to calculate risk scores.

## Packages
### 1. `qgisprocess`
- **Description**: Interfaces with QGIS (Quantum GIS), a powerful open-source GIS tool, to perform spatial analysis and processing within R. **Requires QGIS to be installed on your system**.
- **Reference**: [qgisprocess on CRAN](https://cran.r-project.org/web/packages/qgisprocess/index.html)
### 2. `terra`
- **Description**: Provides functions to work with spatial data (raster and vector data), and allows for geospatial analysis and modeling.
- **Reference**: [terra on CRAN](https://cran.r-project.org/web/packages/terra/index.html)
### 3. `sf`
- **Description**: Provides simple features support for R, enabling handling, analysis, and visualization of spatial data.
- **Reference**: [sf on CRAN](https://cran.r-project.org/web/packages/sf/index.html)
### 4. `bcmaps`
- **Description**: Contains spatial data for British Columbia, including maps and layers that can be used in geospatial analysis for the province.
- **Reference**: [bcmaps on CRAN](https://cran.r-project.org/web/packages/bcmaps/index.html)
### 5. `viridis`
- **Description**: Provides color palettes for visualizations that are perceptually uniform.
- **Reference**: [viridis on CRAN](https://cran.r-project.org/web/packages/viridis/index.html)
### 6. `tmap`
- **Description**: Used for thematic maps, allowing users to create interactive and static maps.
- **Reference**: [tmap on CRAN](https://cran.r-project.org/web/packages/tmap/index.html)
### 7. `dplyr`
- **Description**: Provides a set of tools for data manipulation, including functions for filtering, transforming, and summarizing data.
- **Reference**: [dplyr on CRAN](https://cran.r-project.org/web/packages/dplyr/index.html)
### 8. `ebirdst`
- **Description**: Tools for accessing and analyzing eBird Status and Trends Data Products.
- **Reference**: [ebirdst on CRAN](https://cran.r-project.org/web/packages/ebirdst/index.html)
