setwd("./github/CALACD/R")

## load average acc data
acc <- readRDS("../data/acc_data.rds")
colnames(acc)[1] <- "participant_id"
# nrow(acc)

## load qc data
source("data_qc.r")
cali_qc <- readRDS("../data/calibration_qc.rds")
wear_qc <- readRDS("../data/wear_qc.rds")

## qc subset
res <- qc_subset(wear_qc, cali_qc)
id <- res$sub_id
acc_qc <- subset(acc, acc$participant_id %in% id)
nrow(acc_qc)

## calculate RA
source("RA_calculation.r")
RA_res <- calculate_RA(acc_qc, id_column = "participant_id", hour_prefix = "Average acceleration")
RA_res |> head(10)
nrow(RA_res)

## calculate PA metrics
source("metrics.r")
PA_res <- calculate_pa_intensity(acc_qc)
PA_res |> head(10)

## check metrics' distribution
hist(PA_res$LPA_minutes_per_week, main = "LPA", xlab = "Minutes per week", col = "lightblue")
hist(PA_res$MPA_minutes_per_week, main = "MPA", xlab = "Minutes per week", col = "lightgreen")
hist(PA_res$VPA_minutes_per_week, main = "VPA", xlab = "Minutes per week", col = "lightcoral")
