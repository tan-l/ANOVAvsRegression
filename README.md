# Project Description

This GitHub project repository contains the simulation code for the paper "Regression Over ANOVA: A Methodological Reevaluation and Discussion for Engineering Education Research". Please note that all data files used in these scripts are from the public versions of the respective datasets and are included in the folder `data`.

## Included Scripts

This project includes four scripts:

1. `data_ies.R`: Reads in the raw IES data and prepares it for the simulation. The resulting dataframe is saved as an RDS file for easy retrieval in subsequent scripts.
2. `data_mf.R`: Reads in the raw MIEFIELD data and prepares it for the simulation. The resulting dataframe is saved as an RDS file for easy retrieval in subsequent scripts.
3. `data_nsf.R`: Reads in the raw NSF SDR data and prepares it for the simulation. The resulting dataframe is saved as an RDS file for easy retrieval in subsequent scripts.
4. `simulation.R`: Performs the simulation tasks based on the data prepared in the previous scripts. The results are then aggregated and saved in both RDS and CSV formats.

## Prerequisites

Running these scripts requires R and the following R package: `tidyverse`. Please ensure you have these installed on your machine.

## Running the Scripts

First, place your data files in the working directory or adjust the paths in the scripts to match your data locations. Set your working directory in R to the location where the scripts are saved using the `setwd()` function.

Scripts should be run in the order they are listed. You can run each script using the `source()` function in R. For example, to run the first script, you would use the command `source("data_ies.R")`.

## Results

The final output of these scripts are the RDS and CSV files created by `simulation.R`, please refer to the paper for their interpretations.
