#' Title
#'
#' @param df_experiment
#'
#' @return
#' @export
#'
#' @examples
prepare_export <- function(df_experiment){
  df_all_combinations <- data.frame(values.blocknumber = as.character(c(1,1,1,1,2,2,2,2,3,3,3,3)),
                                    correct_response = rep(c("error", "correct", "error", "correct"), 3),
                                    trialcode = rep(c("stop", "stop", "nostop", "nostop"), 3))

  df_out <- df_experiment %>%
    filter(blockcode == "testblock") %>%
    group_by(values.blocknumber, trialcode, correct_response) %>%
    summarise(mean_rt = mean(values.rt),
              median_rt = median(values.rt),
              .groups = "drop") %>%
    right_join(df_all_combinations) %>%
    filter(!(trialcode == "stop" & correct_response == "correct")) %>%
    unite(col = "varname", trialcode, correct_response, values.blocknumber, sep = "_")

  df_out <- df_experiment %>%
    filter(blockcode == "testblock") %>%
    group_by(values.blocknumber, trialcode) %>%
    summarise(accuracy = sum(correct_response == "correct")/n(),
              .groups="drop") %>%
    mutate(varname = paste(trialcode, "correct", values.blocknumber, sep="_")) %>%
    select(-c(values.blocknumber,  trialcode)) %>%
    full_join(df_out, by="varname")

  df_out <- df_out %>%
    pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt)) %>%
  #%>% select(matches)
    select(-matches("accuracy.*error.*"), -matches(".*_rt_stop")) %>%
    mutate(participant = df_experiment$subject[1])

  return(df_out)
}
