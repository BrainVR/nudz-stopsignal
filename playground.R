library(dplyr)
library(tidyr)


dat <- read.table("data/iq/stopsignaltask5_CZ_raw_zk210612kt_2021-06-12-17-04-00-099.iqdat",
           header=TRUE, sep="\t")

settings_fields <- c("build", "computer.platform", "date", "time", "subject", "group")
settings <- sapply(settings_fields, function(x){return(dat[[x]][1])},
                   simplify = TRUE)

dat <- select(dat, -settings_fields)

dat <- dat %>%
  mutate(correct_response = ifelse(values.correct == 2, "correct", "error"),
         correct_key = ifelse(values.response == values.stimulus, "correct", "error"),
         correct_key = ifelse(values.response == 0, NA, correct_key),
         trialcode = recode(trialcode, sstrial = "stop", nstrial="nostop"),
         stopsignalstart = expressions.ssrt) %>%
  select(-starts_with("expressions"))

dat <- select(dat, -c(values.ns_ntotal, values.ss_ntotal, values.ssd))

df_out <- dat %>%
  filter(blockcode == "testblock") %>%
  group_by(values.blocknumber, trialcode, correct_response) %>%
  summarise(mean_rt = mean(values.rt),
            median_rt = median(values.rt),
            .groups = "drop") %>%
  # removing reaction times of trials where no realctions were given - correct stop signal trials
  filter(!(trialcode == "stop" & correct_response == "correct")) %>%
  unite(col = "varname", trialcode, correct_response, values.blocknumber, sep = "_")

df_out <- dat %>%
  filter(blockcode == "testblock") %>%
  group_by(values.blocknumber, trialcode) %>%
  summarise(accuracy = sum(correct_response == "correct")/n(),
            .groups="drop") %>%
  mutate(varname = paste(trialcode, "correct", values.blocknumber, sep="_")) %>%
  select(-c(values.blocknumber,  trialcode)) %>%
  full_join(df_out, by="varname")

df_out %>%
  pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt)) %>%
  select_if(function(x) any(!is.na(x)))
