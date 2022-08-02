
########################################################################################################
#                                                                                                      #
#                                HIGH-FREQUENCY CHECKS  -- DUPLICATES & OUTLIERS                       #
#                                                                                                      #
########################################################################################################

## PURPOSE      Check and flag duplicates and outliers in the data

## CONTENTS

### 1. Duplicate checks for consented surveys 
    
### 2. Duplicate checks for incompleted surveys 

### 3. Outlier checks

########################################################################################################



# Setup -----

library(pacman)

p_load(data.table, dplyr, tidyverse, magrittr, lubridate, scales, viridis, stringr, knitr, kableExtra)

if(Sys.info()["user"] == "boruis")  {
  root <- "C:/Users/sunsh/Dropbox/0. boruis_folder/dime/survey_hfc/"
}


# Load survey data 
surveys <- fread(paste0(root, "Demo Survey (without module completion)_WIDE.csv"))


## 1. DUPLICATE CHECKS ----------------

  ## PART A: FOR CONSENTED SURVEYS -------

id_consented_dups <- surveys %>% 
    # Only keep consented surveys
  filter(survey_result_update == 1) %>% 
    # How many surveys were submitted under this mid
  group_by(mid) %>% summarise(n = n()) %>% 
    # Only keep consented surveys that were submitted more than once
  filter(n > 1) %>% 
    # Get the list of mid
  pull(mid) %>% unique()


if(is_empty(id_consented_dups)){
  
  cat("\n No Duplicate Survey Was Found. Please Proceed. \n")
  
}else{
  
  output <- surveys %>% 
      # select the duplicated surveys
    filter(survey_result_update == 1, mid %in% id_consented_dups) %>% 
      # keep relevant variables for FCs to investigate 
    select(mid, SubmissionDate, enumerator_name, KEY)
    
  fwrite(output, paste0(root, "consented_duplicates.csv"))
  
  cat("\n", length(id_consented_dups), "Duplicate Surveys Were Found in the Data. Please Investigate this with FC. \n")
  
}

  ## PART B: FOR INCOMPLETED SURVEYS -------

  # STEP 1: DOWNLOAD THE MOST RECENT PRELOAD SHEET 
preload <- paste0(root, "prefill_data.csv") %>% fread()
preload %<>% filter(attempt_counter > 0) %>% select(mid, attempt_counter, complete_status, survey_result)

  # STEP 2: COMPARE THE PRELOAD SHEET WITH THE ACTUAL SITUATION
completion_status <- surveys %>% 
  
  group_by(mid) %>% 
  
  summarise(
    
    attempt_counter_hc = n_distinct(KEY),
    complete_status_hc = sum(complete_status_update == 1) > 0,
    complete_status_hc = as.numeric(complete_status_hc),
    
    survey_result_hc   = sum(survey_result_update == 1) > 0,
    survey_result_hc   = as.numeric(survey_result_hc),
    survey_result_hc   = ifelse(complete_status_hc == 1, survey_result_hc, 2)
    
  )
  
check_df <- preload %>% full_join(completion_status, by = "mid")
check_df %<>% mutate(
  
  attempt_counter_check = is.na(attempt_counter_hc)|is.na(attempt_counter)| attempt_counter != attempt_counter_hc,
  complete_status_check = is.na(complete_status_hc)|is.na(complete_status)| complete_status != complete_status_hc,
  survey_result_check   = is.na(survey_result_hc)  |is.na(survey_result)  | survey_result != survey_result_hc
  
) %>% filter(
  
  attempt_counter_check | complete_status_check | survey_result_check
  
)

uids_inconsist <- check_df$mid %>% unique()

if(is_empty(uids_inconsist)){
  
  cat("No Duplicate Survey Was Found. Please Proceed.")
  
}else{
  
  cat("\n The Survey Submission Do Not Match with the Preload Sheet. Please Investigate the Submission Status For the Following UID: \n")
  
  for(i in uids_inconsist){
    
    cat("\n UID:", i, "\n")
  }
  
}



## 2. OUTLIER CHECKS -----------

vars <- c(
  
  "Number of Matatus Owned" = "matatu_own", 
  "Break Repair Costs"      = "matatu_repair_breaks"
  
  )

outlier_check <- function(data, var, name){
  substitute(
    
    data %>% 
      
      select(mid, starts_with(var_str)) %>% 
      
      select(-ends_with("_oth")) %>% 
      
      pivot_longer(
        
        cols         = -c(mid, var), 
        names_to     = "option", 
        values_to    = "yesno",
        names_prefix = paste0(var_str, "_")
        
      )  
    
  ) %>% eval
  
}
  
outlier_df <- data.frame()

for(i in seq_along(vars)){
  
  df <- surveys %>% rename(value = as.character(vars[i])) %>% 
      # Only keep variables relevant for outlier checks
    select(mid, enumerator_name, KEY, SubmissionDate, value) 
  
    # Outlier threshold
  threshold <- quantile(df$value, probs = 0.98)
  
    # Only keep value greater than 0.98 percentile 
  out <- df %>% filter(value > threshold)
  
  out$percentile98 <- threshold 
  out$variable <- as.character(vars[i])
  out$question <- names(vars[i])
  
  outlier_df %<>% bind_rows(out)
}

  # Rename columns 
outlier_df %<>% `colnames<-`(
  
  c("Mid", "Enumerator", "Survey Key", "Submission Date", "Value", 
    "Value (98 Percentile)", "Variable Name", "Question")
  
  )

  # Save output
fwrite(outlier_df, paste0(root, "outlier_check.csv"))
