#' Title
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

  df_out <- df_experiment %>%
    filter(blocknumber %in% blocks_to_analyze) %>%
    group_by(blocknumber, trialcode, correct_response) %>%
    summarise(mean_rt = mean(values.rt, na.rm = TRUE),
              median_rt = median(values.rt, na.rm = TRUE),
              .groups = "drop") %>%
    right_join(df_all_combinations, by=colnames(df_all_combinations)) %>%
    filter(!(trialcode == "stop" & correct_response == "correct")) %>%
    unite(col = "varname", trialcode, correct_response, blocknumber, sep = "_")

  df_out <- df_experiment %>%
    filter(blocknumber %in% blocks_to_analyze) %>%
    group_by(blocknumber, trialcode) %>%
    summarise(accuracy = sum(correct_response == "correct")/n(),
              .groups="drop") %>%
    mutate(varname = paste(trialcode, "correct", blocknumber, sep="_")) %>%
    select(-c(blocknumber,  trialcode)) %>%
    full_join(df_out, by="varname")

  df_out <- df_out %>%
    pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt)) %>%
  #%>% select(matches)
    select(-matches("accuracy.*error.*"), -matches(".*_rt_stop")) %>%
    mutate(participant = df_experiment$subject[1])

  return(df_out)
}
