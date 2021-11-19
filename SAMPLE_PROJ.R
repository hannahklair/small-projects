## START SCRIPT   // common packages to install at each fresh install
install.packages(c("tidyverse", "dslabs", "downloader", "remotes", "ggseas", "reshape2"))
installed.packages() ##check packages installed
library(data.table)
library(downloader)
library(tidyr)
library(reshape2)
library(foreign)
library(ggplot2)
library(ggseas) ##load libraries as needed
library(openxlsx)
library(remotes)

## 1 Pull data -----------------------------------------
# after download, store on github in .txt format
# read.csv(filename/url, header=FALSE)
# read.xlsx(url,sheet=1)
idea_df <- read.csv(file = "https://www.idea.int/gsod-indices/sites/default/files/inline-files/GSoDI%20v5.1%20%281975-2020%29.csv")
fhouse_df <- read.xlsx("https://freedomhouse.org/sites/default/files/2021-02/All_data_FIW_2013-2021.xlsx", sheet=1)
vdem_df <- readRDS("C:/Users/hanna/Desktop/Country_Year_V-Dem_Core_R_v11.1/V-Dem-CY-Core-v11.1.rds")
remotes::install_github("xmarquez/democracyData") ##incl polity5 (+eiu?)
## eiu and polity5
library(democracyData)
polity_df <- download_polity_annual(verbose=FALSE)