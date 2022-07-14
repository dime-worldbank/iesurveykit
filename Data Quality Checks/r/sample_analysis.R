
########################################################################################################
#                                                                                                      #
#                       HIGH-FREQUENCY CHECKS  -- DATA QUALITY CHECKS & ANALYSIS                       #
#                                                                                                      #
########################################################################################################

## PURPOSE      Produce data quality checks by survey date and enumerator and create aggregated descriptive statistics

## CONTENTS

### 1. Time-series data quality checks by enumerators

### 2. Descriptive statistics

########################################################################################################


# Setup -----

library(pacman)

p_load(data.table, dplyr, tidyverse, magrittr, lubridate, scales, viridis, stringr, knitr, kableExtra)

if(Sys.info()["user"] == "boruis")  {
  root <- "C:/Users/sunsh/Dropbox/0. boruis_folder/dime/survey_hfc/"
}


# 1. DATA QUALITY CHECKS BY SURVEY DATE AND ENUMERATOR ----------

  # LOAD DATSET ----
surveys <- fread(paste0(root, "Demo Survey (without module completion)_WIDE.csv"))

  # Clean date variables
surveys$date  <- surveys$SubmissionDate %>%  as.Date(format = "%b %d, %Y")
surveys$starttime_format <- surveys$starttime %>%  as.POSIXct(format = "%b %d, %Y %I:%M:%S %p")
surveys$endtime_format   <- surveys$endtime %>%  as.POSIXct(format = "%b %d, %Y %I:%M:%S %p")
surveys$diff_startend    <- difftime(surveys$endtime_format, surveys$starttime_format, units = "mins")

  # PART A: Number of surveys per day  + per day/per enumerator -----

surveys %>% group_by(date) %>% 
  
  summarise(n = n()) %>%
  
    # plot
  ggplot(aes(x = date, y = n)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  geom_hline(yintercept = 0, color = NA) +
  
  theme_bw() +
  labs(y = "Number of Submissions", x = "",  color = "") +
  
  theme(legend.position = "bottom") ;  ggsave(paste0(root, "nsubmission_day.png"), width = 15, height = 15, units = "cm")


surveys %>% group_by(enumerator_name, date) %>% 
  
  summarise(n = n()) %>%
  
  # plot 
  ggplot(aes(x = date, y = n, color = enumerator_name, group = enumerator_name)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  geom_hline(yintercept = 0, color = NA) +
  
  theme_bw() +
  scale_color_brewer(palette = "Dark2") + 
  labs(y = "Number of Submissions", x = "", color = "") +
  
  theme(legend.position = "bottom") ;  ggsave(paste0(root, "nsubmission_day_enum.png"), width = 15, height = 15, units = "cm")


  # PART B: Average survey duration per day + per day/per enumerator ---------

surveys %>% group_by(date) %>% 
  
  summarise(n = mean(diff_startend)) %>%
  
  # plot 
  ggplot(aes(x = date, y = n)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  theme_bw() +
  labs(y = "Averag Survey Duration (Mins)", x = "", color = "") +
  
  theme(legend.position = "bottom") ;  ggsave(paste0(root, "avgduration_day.png"), width = 15, height = 15, units = "cm")



surveys %>% group_by(date, enumerator_name) %>% 
  
  summarise(n = mean(diff_startend)) %>%
  
  # plot 
  ggplot(aes(x = date, y = n, color = enumerator_name, group = enumerator_name)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  theme_bw() +
  scale_color_brewer(palette = "Dark2") + 
  labs(y = "Averag Survey Duration (Mins)", x = "", color = "") +
  
  theme(legend.position = "bottom") ;  ggsave(paste0(root, "avgduration_day_enum.png"), width = 15, height = 15, units = "cm")


  # PART C: Average response to a question per day + per day/per enumerator ------------

surveys %>% group_by(date) %>% 
  
  summarise(n = mean(matatu_own, na.rm = T)) %>%
  
  ggplot(aes(x = date, y = n)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  theme_bw() +
  labs(y = "Number of Matatus Owned (Average)", x = "", color = "") +
  
  theme(legend.position = "bottom");  ggsave(paste0(root, "avganswer_day.png"), width = 15, height = 15, units = "cm")


surveys %>% group_by(date, enumerator_name) %>% 
  
  summarise(n = mean(matatu_own, na.rm = T)) %>%
  
  ggplot(aes(x = date, y = n, color = enumerator_name, group = enumerator_name)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  theme_bw() +
  
  scale_color_brewer(palette = "Dark2") + 
  labs(y = "Number of Matatus Owned (Average)", x = "", color = "") +
  
  theme(legend.position = "bottom");  ggsave(paste0(root, "avganswer_day_enum.png"), width = 15, height = 15, units = "cm")




  # PART D: Share of 'other' per day + per day/per enumerator ----------

surveys %>% group_by(date) %>% 
  
  summarise(n = mean(matatu_challenge_select_10, na.rm = T)) %>% 
  
  ggplot(aes(x = date, y = n)) +
  
  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  geom_hline(yintercept = 0, color = NA) +
  
  theme_bw() +
  scale_y_continuous(label = percent) +
  labs(y = "Share of 'Other Challenges' Selected", x = "", color = "") +
  
  theme(legend.position = "bottom");  ggsave(paste0(root, "avgother_day.png"), width = 15, height = 15, units = "cm")



surveys %>% group_by(date, enumerator_name) %>% 
  
  summarise(n = mean(matatu_challenge_select_10, na.rm = T)) %>%
  
  ggplot(aes(x = date, y = n, color = enumerator_name, group = enumerator_name)) +

  geom_line(alpha = 0.7) + 
  geom_point(size = 2.5) +
  
  geom_hline(yintercept = 0, color = NA) +
  
  theme_bw() +
  scale_color_brewer(palette = "Dark2") + 
  scale_y_continuous(label = percent) +
  labs(y = "Share of 'Other Challenges' Selected", x = "", color = "") +
  
  theme(legend.position = "bottom");  ggsave(paste0(root, "avgother_day_enum.png"), width = 15, height = 15, units = "cm")






# 2. DESCRIPTIVE STATISTICS -----------

  # LOAD DATASET -------
surveys <- fread(paste0(root, "Demo Survey (without module completion)_WIDE.csv"))

surveys %<>% filter(survey_result_update == 1)

  # CREATE FUNCTION --------

produce_sumtable <- function(var, name){
  
  sum_table <- tibble(
    
    Variable = name,
    N        = sum(!is.na(var)),
    Min      = min(var, na.rm = T),
    Mean     = mean(var, na.rm = T),
    Median   = median(var, na.rm = T),
    Max      = max(var, na.rm = T),
    SD       = sd(var, na.rm = T)
    
  )
  
  cat("\n", "----------", name, "Done -------------", "\n")
  
  return(sum_table)
}





  # PART A - TABLE: HOW MANY MATATUS DO YOU OWN  ---------

produce_sumtable(
  
  surveys$matatu_own, "Matatus Owned"
  
  ) %>% 
  
  mutate_if(is.numeric, ~round(., 2)) %>% 
  
  # Latex formatting
  kable(format = "latex", format.args = list(big.mark = ","), longtable = TRUE, row.names = FALSE, booktabs = T) %>%
  row_spec(0, bold = TRUE) %>% 
  kable_styling() %>% 
  
  writeLines(paste0(root, "matatus_owned.tex"))

  # PART B - TABLE: HOW MUCH DID YOU SPEND ON REPAIRING BREAKS ------------

produce_sumtable(
  
  surveys$matatu_repair_breaks, "Break Repair Cost"
  
) %>% 
  
  mutate_if(is.numeric, ~round(., 2)) %>% 
  
  # Latex formatting
  kable(format = "latex",format.args = list(big.mark = ","), longtable = TRUE, row.names = FALSE, booktabs = T) %>%
  row_spec(0, bold = TRUE) %>% 
  kable_styling() %>% 
  
  writeLines(paste0(root, "matatu_repair.tex"))




  # PART C - GRAPH: HOW MANY MATATUS DO YOU OWN -----

ggplot(surveys, aes(x = matatu_own)) + 
  
  geom_density(fill="#69b3a2", color="#e9ecef", alpha = 0.8) +
  
  scale_x_continuous(labels = comma) +
  
  labs(x = "Number of Matatus Owned", y = "Density") +
  
  theme_bw();  ggsave(paste0(root, "nmatatus_owned.png"), width = 25, height = 15, units = "cm")

  # PART D - GRAPH: DO YOU FACE ANY CHALLENGES MANAGING YOUR MATATU -----

surveys %>% select(mid, matatu_challenge) %>% 
  
  mutate(tot = n_distinct(mid)) %>% 
  
  group_by(matatu_challenge, tot) %>% 
  
  summarise(n = n_distinct(mid)) %>% 
  
  mutate(p = n/tot) %>% 
  
  mutate(
    matatu_challenge_label = case_when(
      
      matatu_challenge == 1 ~ "Never",
      matatu_challenge == 2 ~ "Rarely",
      matatu_challenge == 3 ~ "Sometimes",
      matatu_challenge == 4 ~ "Always"
      
    )
    
  ) %>% 
  
  # plot
  ggplot(aes(x = reorder(matatu_challenge_label, matatu_challenge), y = p, fill = reorder(matatu_challenge_label, matatu_challenge))) +
  
  geom_bar(stat = "identity") + 
  
  
  scale_fill_brewer(palette = "Reds", guide = NULL) + 
  scale_y_continuous(labels = percent) +
  
  labs(x = "", y = "Share of Matatu Owners") +
  
  theme_bw(); ggsave(paste0(root, "matatu_challenge_any.png"), width = 25, height = 15, units = "cm")


  # PART E - GRAPH: WHAT ARE THE CHALLENGES YOU FACE MANAGING YOUR MATATU  -------

df_graph <- surveys %>% 
  
  # only keep owners who face challanges in managing matatus
  filter(matatu_challenge != 1) %>% 
  
  select(mid, matatu_challenge_select, starts_with("matatu_challenge_select")) %>% 
  
  select(-ends_with("_oth")) %>% 
  
  pivot_longer(
    
    cols         = -c(mid, matatu_challenge_select), 
    names_to     = "option", 
    values_to    = "yesno",
    names_prefix = "matatu_challenge_select_"
    
  ) %>% 
  
  mutate(
    option_label = case_when(
      
      option == 1 ~ "High maintenance cost",
      option == 2 ~ "Heavy competition from other matatus",
      option == 3 ~ "COVID-19 restrictions",
      option == 4 ~ "Police harassment",
      option == 5 ~ "Poor roads",
      option == 6 ~ "Difficulty attaining revenue targets",
      option == 7 ~ "Difficulty monitoring the vehicles",
      option == 8 ~ "Getting good drivers",
      option == 9 ~ "Managing current drivers",
      option == 10 ~ "Other"
      
    )
  ) 

n_sample <- df_graph$mid %>% n_distinct()
n_options <- df_graph$option_label %>% n_distinct()
  

df_graph %>%
  
  group_by(option_label) %>% 
  
  summarise(tot = n(), n = sum(yesno), p = n/tot) %>% 
  
  mutate(
    
    order = ifelse(option_label == "Other", -1, p),
    option_label = str_to_title(option_label),
    option_label = str_wrap(option_label, 40)
    
  ) %>%
  
  filter(n != 0 ) %>%
  
  # plot
  ggplot(aes(x = reorder(option_label, order), y = p, fill = reorder(option_label, order))) +
  
  geom_bar(stat = "identity") + 
  
  scale_fill_manual(values = magma(n_options), guide = NULL) +
  scale_y_continuous(labels = percent) +
  
  theme_bw() + 
  
  labs(x = "", y = paste0("Share of Matatu Owners (N = ", comma(n_sample), ")")) +
  
  coord_flip(); ggsave(paste0(root, "matatu_challenge.png"), width = 25, height = 15, units = "cm")


  # PART F - GRAPH: HOW MUCH DID YOU SPEND ON REPAIRING BREAKS -------

ggplot(surveys, aes(x = matatu_repair_breaks)) + 
  
  geom_histogram(binwidth = 50, fill = "#69b3a2", color = "#e9ecef", alpha = 0.9) +
 
  scale_y_continuous(labels = comma) +
  scale_x_continuous(labels = comma) +
  
  labs(x = "Break Repair Cost", y = "Number of Owners") +
 
  theme_bw();  ggsave(paste0(root, "matatu_repair.png"), width = 25, height = 15, units = "cm")
  