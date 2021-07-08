#' Title
#'
#' @param df_experiment
#'
#' @return
#' @export
#'
#' @examples
preprocess_experiment <- function(df_experiment){
  dat <- df_experiment %>%
    mutate(correct_response = ifelse(values.correct == 2, "correct", "error"),
           correct_key = ifelse(values.response == values.stimulus, "correct", "error"),
           correct_key = ifelse(values.response == 0, NA, correct_key),
           trialcode = recode(trialcode, sstrial = "stop", nstrial="nostop"),
           stopsignalstart = expressions.ssrt,
           values.blocknumber = as.character(values.blocknumber)) %>%
    select(-starts_with("expressions"))

  dat <- select(dat, -c(values.ns_ntotal, values.ss_ntotal, values.ssd))
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
  settings <- sapply(settings_fields, function(x){return(dat[[x]][1])},
                     simplify = TRUE)
  dat <- select(df_experiment, -settings_fields)

  return(list(settings = settings, data = dat))
}
