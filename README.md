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
│   ├── BC-Bird-Species-List-(Avibase).csv <- A list of bird species in BC extracted from Avibase
│   ├── EMPRESi-BC-allHPAI-2022-24.csv <- A CSV of EMPRESi HPAI case data for BC
├── scripts <- Contains the R scripts for processing the data and generating the risk map
│   ├── BC-common-species-filter.R <- Script for filtering common, non-introduced bird species in BC
│   ├── eBird-data-download.R <- Script for downloading eBird data on bird species abundance
│   ├── risk-map.R <- Main script for processing data, calculating risk, and generating maps
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
### Step 1: Run scripts/eBird-data-download.R
- Aim: Download eBird abundance data for common BC bird species
- Input: data/BC-Bird-Species-List-(Avibase).csv
- Dependencies: scripts/BC-common-species-filter.R
- Output: Weekly median abundance rasters at 3km resolution for common BC bird species (saved in AppData\\Roaming/R/data/R/ebirdst)
### Step 2: Generate and visualize the risk map
```
source("scripts/risk-map.R")
```
