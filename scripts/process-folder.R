# load libraries
library(dplyr)
library(tidyr)
DATA_PATH <- "C:\\Users\\hejtm\\Downloads\\RAW_DATA_final\\StopSignalTask_Inq/stopsignal4/"

pths <- list.files(DATA_PATH, full.names = TRUE)
df_out <- data.frame()
for(filepath in pths){
  message(filepath)
  df_experiment <- load_experiment(filepath)
  if(max(df_experiment$expressions.blocknumber) != 2){
    message("does not have 3 unique setups")
    next
  }
  df_experiment <- preprocess_experiment(df_experiment)
  temp_out <- prepare_export(df_experiment)
  df_out <- rbind(df_out, temp_out)
}

write.csv(df_out, "stopsignal-preprocessed-stopsignal4.csv",
          row.names = FALSE, quote = FALSE)

