library(dplyr)
library(tidyr)
DATA_DIR <- "E:/OneDrive/NUDZ/projects/OCD/data"
DATA_DIR_4 <- file.path(DATA_DIR, "RAW_DATA_final", "StopSignalTask_Inq", "stopsignal4")
DATA_DIR_5 <- file.path(DATA_DIR, "RAW_DATA_final", "StopSignalTask_Inq", "stopsignal5")

pths <- list.files(DATA_DIR_4, full.names = TRUE)

df_out_all_correct <- data.frame()
df_out_correct_signal <- data.frame()

for(filepath in pths){
  message(filepath)
  df_experiment <- load_experiment(filepath)
  if(max(df_experiment$expressions.blocknumber) != 2){
    message("does not have 3 unique setups")
    next
  }
  df_experiment <- preprocess_experiment(df_experiment)

  temp_out <- prepare_export(df_experiment, blocks_to_analyze = 0:2)
  df_out_all_correct <- bind_rows(df_out_all_correct, temp_out)

  ## Analyses only correctedness in the signal domain - if key was or was not
  # pressed, regardless of what the key was
  df_experiment$correct_response <- df_experiment$correct_signal
  temp_out <- prepare_export(df_experiment, blocks_to_analyze = 0:2)
  df_out_correct_signal <- bind_rows(df_out_correct_signal, temp_out)

}

write.csv(df_out_all_correct, "stopsignal-preprocessed-stopsignal4-everything-correct.csv",
          row.names = FALSE, quote = FALSE)

write.csv(df_out_correct_signal, "stopsignal-preprocessed-stopsignal4-signal-correct.csv",
          row.names = FALSE, quote = FALSE)

filepath <- pths[12]
