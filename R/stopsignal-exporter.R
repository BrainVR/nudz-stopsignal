#' Creates a list of results for a single participant
#'
#' @param df_experiment
#'
#' @return
#' @export
#'
#' @examples
prepare_export <- function(df_experiment, blocks_to_analyze = c(1,2,3)){
  blocknumbers <- unlist(lapply(blocks_to_analyze, function(x){rep(x, 4)}))

  df_all_combinations <- data.frame(blocknumber = as.character(blocknumbers),
                                    correct_response = rep(c("error", "correct", "error", "correct"),
                                                           length(blocks_to_analyze)),
                                    trialcode = rep(c("stop", "stop", "nostop", "nostop"),
                                                    length(blocks_to_analyze)))
  df_experiment <- filter(df_experiment, blocknumber %in% blocks_to_analyze)

  ## Calculating average response times
  df_out <- df_experiment %>%
    group_by(blocknumber, trialcode, correct_response) %>%
    summarise(mean_rt = mean(values.rt, na.rm = TRUE),
              median_rt = median(values.rt, na.rm = TRUE),
              .groups = "drop") %>%
    right_join(df_all_combinations, by = colnames(df_all_combinations)) %>%
    # removing reaction times of trials where no realctions were given - correct stop signal trials
    filter(!(trialcode == "stop" & correct_response == "correct")) %>%
    unite(col = "varname", trialcode, correct_response, blocknumber, sep = "_")

  ## Calculating accuracy of correct responses
  df_out <- df_experiment %>%
    group_by(blocknumber, trialcode) %>%
    summarise(accuracy = sum(correct_response == "correct")/n(),
              .groups="drop") %>%
    mutate(varname = paste(trialcode, "correct", blocknumber, sep="_")) %>%
    select(-c(blocknumber,  trialcode)) %>%
    full_join(df_out, by="varname")

  ## Calculates summative stats for all analyzed blocks together
  df_all <- df_experiment %>%
    group_by(trialcode, correct_response) %>%
    summarise(mean_rt = mean(values.rt, na.rm = TRUE),
              median_rt = median(values.rt, na.rm = TRUE),
              .groups = "drop") %>%
    mutate(varname=paste(trialcode, correct_response,
                         paste0(blocks_to_analyze, collapse=""), sep="_")) %>%
    select(mean_rt, median_rt, varname)  %>%
    pivot_wider(names_from = varname, values_from = c(mean_rt, median_rt))

  ## Accuracies for all analyzed blocks together
  df_all_accuracy <- df_experiment %>%
    group_by(trialcode) %>%
    summarise(accuracy = sum(correct_response == "correct")/n(),
              .groups="drop") %>%
    mutate(varname=paste("accuracy", trialcode,
                         paste0(blocks_to_analyze, collapse=""), sep="_")) %>%
    select(varname, accuracy) %>%
    pivot_wider(names_from = varname, values_from = accuracy)

  df_all <- cbind(df_all, df_all_accuracy)

  df_out <- df_out %>%
    pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt)) %>%
    select(-matches("accuracy.*error.*"), -matches(".*_rt_stop")) %>%
    mutate(participant = as.character(df_experiment$subject[1]))

  df_out <- cbind(df_all, df_out)

  return(df_out)
}
