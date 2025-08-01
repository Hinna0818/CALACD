setwd("./github/CALACD/R")
acc <- readRDS("../data/acc_data.rds")
colnames(acc)[1] <- "participant_id"

source("data_qc.r")
cali_qc <- readRDS("../data/calibration_qc.rds")
wear_qc <- readRDS("../data/wear_qc.rds")

res <- qc_subset(wear_qc, cali_qc)
id <- res$sub_id

source("RA_calculation.r")
ddd <- subset(acc, acc$participant_id %in% id)

source("RA_calculation.r")
res <- calculate_RA(ddd, id_column = "participant_id", hour_prefix = "Average acceleration")
res |> head()
