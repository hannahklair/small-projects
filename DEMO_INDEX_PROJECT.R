## START SCRIPT ---------------------------------------
# common packages to install at start -----------------
installed.packages() ##check packages installed
install.packages(c("tidyverse", "dslabs", "downloader", "remotes", "ggseas", "reshape2", "openxlsx"))
library(tidyverse) ## ggplot2 tidyr dplyr readr
library(data.table)
library(reshape2)
library(ggseas)
library(foreign)
library(downloader)
library(openxlsx)
library(remotes)

## 1 Pull data ----------------------------------------
# store as .txt
# ----------------------- #
## preferred args: read.csv(filename/url, header=FALSE) read.xlsx(url,sheet=1)
idea_df <- read.csv(file = "https://www.idea.int/gsod-indices/sites/default/files/inline-files/GSoDI%20v5.1%20%281975-2020%29.csv")
vdem_df <- readRDS("C:/Users/hanna/Desktop/stats/democracy_project/Country_Year_V-Dem_Core_R_v11.1/V-Dem-CY-Core-v11.1.rds")
fhouse_df <- read.xlsx("https://freedomhouse.org/sites/default/files/2021-02/All_data_FIW_2013-2021.xlsx", sheet=2)
## eiu and polity5
remotes::install_github("xmarquez/democracyData") ##incl polity5 (+eiu?)
library(democracyData)
polity_df <- download_polity_annual(verbose=FALSE)

## 2 Clean data ---------------------------------------
# ----------------------- #
head(fhouse_df) ## Freedom House (FHI) ----------------
fhouse_df = subset(fhouse_df, select = -c(X8, X9, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19, X20, X24, X25, X26, X27, X28, X29,
                                          X30, X31, X32, X33, X34, X35, X36, X37, X38, X39, X40, X41, X42))
colnames(fhouse_df) <- c("country", "region", "ct", "edition", "status",
                         "prrating","clrating", "addq", "adda", "pr","cl", "total")
fhouse_df <- fhouse_df[-c(1), ]
fhouse_df$total <- as.numeric(fhouse_df$total)

head(polity_df) ## Polity2 ----------------------------
polity_df = subset(polity_df, select = c(scode, polity_annual_country, year, flag, democ, autoc, polity, polity2)) 

head(idea_df) ## IDEA ---------------------------------


head(vdem_df) ## V-dem --------------------------------
vdem_df = subset(country_name, country_id, year, v2x_polyarchy, v2x_libdem, v2x_partipdem, v2x_delibdem, v2x_egaldem)

## 2.1 Normalize to 0-1 -----------------------------------
# VDem (0,1)      - no change      ###Vdemvar= multiple: v2x_polyarchy, v2x_libdem, v2x_partipdem, v2x_delibdem, v2x_egaldem
# IDEA (0,1)      - no change      ###IDEAvar= multiple: C_A1 C_A2 C_A3 C_A4 + C_SD51 C_SD52 C_SD53 C_SD54
# FHI (40,0)      - (fhi*-1)/40    ###FHIVAR= total
# Polity2 (-10,10)- (poli2/-20)+1  ###POLIVAR= polity
# newvars ""scale and ""scaletest; "" = vdempol vdeml vdempart vdemd vdeme idea1 idea2 idea3 idea4 idea51 idea52 idea53 idea54 fhi poli

vdem_df$vdempolscale <- vdem_df$v2x_polyarchy
vdem_df$vdemlscale <- vdem_df$v2x_libdem
vdem_df$vdempartscale <- vdem_df$v2x_partipdem
vdem_df$vdemdscale <- vdem_df$v2x_delibdem
vdem_df$vdemescale <- vdem_df$v2x_egaldem

idea_df$idea1scale <- idea_df$C_A1
idea_df$idea2scale <- idea_df$C_A2
idea_df$idea3scale <- idea_df$C_A3
idea_df$idea4scale <- idea_df$C_A4
idea_df$idea51scale <- idea_df$C_SD51
idea_df$idea52scale <- idea_df$C_SD52
idea_df$idea53scale <- idea_df$C_SD53
idea_df$idea54scale <- idea_df$C_SD54

## transforming with mutate
fhouse_df <- fhouse_df %>%
  mutate(fhiscale = total / -40)
polity_df <- polity_df %>%
  mutate(poliscale = (polity/-20))

## transforming by defining a scale var ("scalename")
scalefhi <- -1/40
scalepoli <- -1/20

fhouse_df$fhiscaletest <- fhouse_df$total * scalefhi
polity_df$poliscaletest <- polity_df$polity * scalepoli

## compare to test accuracy:
head(fhouse_df$fhiscale)
head(fhouse_df$fhiscaletest) ##fhi scaled values

head(polity_df$poliscale)
head(polity_df$poliscaletest) ##polity scaled values

## 2.2 Normalize country names -----------------------------------
install.packages("countrycode")
install_github('vincentarelbundock/countrycode')
library(countrycode)

unique(vdem_df[c("country_name")])
unique(idea_df[c("ID_country_name")])
unique(fhouse_df[c("country")])
unique(polity_df[c("polity_annual_country")])

## 3 Summary stats --------------------------------------
# N, Mean, Med, SD, Min, Max
# Pairwise corr coefs? (w/ and w/o perfect scores)

#summary(idea_df$ideascale) ...
summary(vdem_df$polyarchy)
summary(vdem_df$libdem)
summary(vdem_df$partipdem)
summary(vdem_df$delibdem)
summary(vdem_df$egaldem)

# ----------------------- #

## 4 Difference to group average ------------------------
# grp avg = proxy for hypothetical demo scale
# plot for each respective pair
# order of pairs arbitrary, but can be chosen so that A-B = range(-0.5, +0.75)
# ----------------------- #
