## START SCRIPT ---------------------------------------
# common packages to install at start
# ----------------------- #
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
# store on github as .txt
# ----------------------- #
# read.csv(filename/url, header=FALSE)
# read.xlsx(url,sheet=1)
idea_df <- read.csv(file = "https://www.idea.int/gsod-indices/sites/default/files/inline-files/GSoDI%20v5.1%20%281975-2020%29.csv")
fhouse_df <- read.xlsx("https://freedomhouse.org/sites/default/files/2021-02/All_data_FIW_2013-2021.xlsx", sheet=1)
vdem_df <- readRDS("C:/Users/hanna/Desktop/Country_Year_V-Dem_Core_R_v11.1/V-Dem-CY-Core-v11.1.rds")
remotes::install_github("xmarquez/democracyData") ##incl polity5 (+eiu?)
## eiu and polity5
library(democracyData)
polity_df <- download_polity_annual(verbose=FALSE)

## 2 Clean data -----------------------------------------
# ----------------------- #
head(idea_df) ## IDEA
head(fhouse_df) ## Freedom House (FHI)
head(vdem_df) ## V-dem
head(polity_df) ## Polity2

#summary(idea_df$)

## 3 Normalize to 0-1 -----------------------------------
# V-Dem - no change
# FHI - reverse (*-1) and scale (0-1)
# Polity2 - scale (0-1)
# Idea - 
# ----------------------- #


## 4 Summary stats --------------------------------------
# N, Mean, Med, SD, Min, Max
# Pairwise corr coefs? (w/ and w/o perfect scores)
# ----------------------- #

## 5 Difference to group average ------------------------
# grp avg = proxy for hypothetical demo scale
# plot for each respective pair
# order of pairs arbitrary, but can be chosen so that A-B = range(-0.5, +0.75)
# ----------------------- #
