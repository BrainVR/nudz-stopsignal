#' Title
#'
#' @param df_experiment
#'
#' @return
#' @export
#'
#' @examples
preprocess_experiment <- function(df_experiment){
  if(!("trialcode" %in% colnames(df_experiment))){
    df_experiment$trialcode <- ifelse(df_experiment$values.signal == 1,
                                      "sstrial", "nstrial")
  }
  if(!("blockcode" %in% colnames(df_experiment))){
    warning("BLOCKCODE not found. Assuming ALL TRIALS ARE TEST!")
    df_experiment$blockcode <- "testblock"
  }
  dat <- df_experiment %>%
    mutate(blocknumber = as.character(expressions.blocknumber),
           correct_response = ifelse(values.correct == 2, "correct", "error"),
           correct_key = ifelse(values.response == values.stimulus, "correct", "error"),
           correct_key = ifelse(values.response == 0, NA, correct_key),
           trialcode = recode(trialcode, sstrial = "stop", nstrial="nostop"),
           stopsignalstart = expressions.ssrt) %>%
    select(-starts_with("expressions"))

  # The any of is there as some datasets do NOT have these columns
  dat <- select(dat, -any_of(c("values.ns_ntotal", "values.ss_ntotal", "values.ssd")))
  return(dat)
}

#' Title
#'
#' @param df_experiment
#'
#' @return
#' @export
#'
#' @examples
extract_settings <- function(df_experiment){
  settings_fields <- c("build", "computer.platform", "date", "time", "subject", "group")
  settings <- sapply(settings_fields, function(x){return(dat[[x]][1])}, simplify = TRUE)
  dat <- select(df_experiment, -settings_fields)
  return(list(settings = settings, data = dat))
}
