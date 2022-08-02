
################################################################################
#                                                                              #                       
#           HIGH-FREQUENCY CHECKS  -- DATA QUALITY CHECKS & ANALYSIS           #            
#                                                                              #                         
################################################################################

### PURPOSE ###

# The purpose of this script is to produce data quality checks by survey date 
# and enumerator, and create aggregated descriptive statistics 

### -------------------------------------------------------------------------###

### CONTENTS ###

  ## A.) Setup
  
  ## B.) Time-series data quality checks by enumerators
  
  ## v.) Descriptive statistics

###--------------------------------------------------------------------------###

###  A.) SETUP  ###

  ## Install all required packages. 
    
     library(pacman)
      
     p_load(data.table, dplyr, tidyverse, magrittr, lubridate, scales, viridis,
              stringr, knitr, kableExtra)

  ## Set working directory.

     if(Sys.info()["user"] == "boruis")  {
      root <- "C:/Users/sunsh/Dropbox/0. boruis_folder/dime/survey_hfc/"
     }

###--------------------------------------------------------------------------###

###  B.) TIME SERIES DATA QUALITY CHECKS BY ENUMERATORS ###
  
  ## In this section, we take a look at analysis based on quality checks done 
  ## by enumerators.

  ## Load the dataset.
     
     surveys <- 
       fread(paste0(root, # Reads data from working directory folder
                    "Demo Survey (without module completion)_WIDE.csv"))

  ## Clean date variables.
     
     surveys$date <- 
       surveys$SubmissionDate %>%  
       as.Date(format = "%b %d, %Y")
     
     surveys$starttime_format <- 
       surveys$starttime %>%  
       as.POSIXct(format = "%b %d, %Y %I:%M:%S %p")
     
     surveys$endtime_format <- 
       surveys$endtime %>%  
       as.POSIXct(format = "%b %d, %Y %I:%M:%S %p")
     
     surveys$diff_startend <- 
       difftime(surveys$endtime_format, 
                surveys$starttime_format, 
                units = "mins")

  ## Part 1) Number of surveys per day + per day/per enumerator.

    ## 1.1) Number of surveys per day.
     
            surveys %>% # Call upon loaded dataset
                group_by(date) %>% # Group by date
                summarise(n = n()) %>%
                  ggplot(aes(x = date, # Add the plot
                             y = n)) + 
                    geom_line(alpha = 0.7) + # Add plot options 
                    geom_point(size = 2.5) +
                    geom_hline(yintercept = 0, color = NA) +
                    theme_bw() +
                    labs(y = "Number of Submissions", # Axis labels
                         x = "",  color = "") +
                    theme(legend.position = "bottom") ; # Legend position
                      ggsave(paste0(root, # Save plot and export to working dir.
                                    "nsubmission_day.png"), 
                             width = 15, # Specify width and height of file 
                             height = 15, 
                             units = "cm")

    ## 1.2) Number of surveys per day per enumerator.
            
            surveys %>% 
              group_by(enumerator_name, # Group by enumerator and date
                       date) %>% 
              summarise(n = n()) %>%
                ggplot(aes(x = date, 
                           y = n, 
                           color = enumerator_name, 
                           group = enumerator_name)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  geom_hline(yintercept = 0, color = NA) +
                  theme_bw() +
                  scale_color_brewer(palette = "Dark2") + 
                  labs(y = "Number of Submissions", 
                       x = "", color = "") +
                  theme(legend.position = "bottom") ;  
                    ggsave(paste0(root, "nsubmission_day_enum.png"), 
                          width = 15, 
                          height = 15, 
                          units = "cm")

  ## Part 2) Average survey duration per day + per day/per enumerator.
            
    ## 2.1) Average survey duration per day.
            
            surveys %>% 
              group_by(date) %>% 
              summarise(n = mean(diff_startend)) %>%
                ggplot(aes(x = date, 
                           y = n)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  theme_bw() +
                  labs(y = "Average Survey Duration (Mins)", 
                       x = "", color = "") +
                  theme(legend.position = "bottom") ;  
                    ggsave(paste0(root, "avgduration_day.png"), 
                          width = 15, 
                          height = 15, 
                          units = "cm")

    ## 2.2) Average survey duration per day per enumerator.

            surveys %>% 
              group_by(date, 
                       enumerator_name) %>% 
              summarise(n = mean(diff_startend)) %>%
                ggplot(aes(x = date, 
                           y = n, 
                           color = enumerator_name, 
                           group = enumerator_name)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  theme_bw() +
                  scale_color_brewer(palette = "Dark2") + 
                  labs(y = "Average Survey Duration (Mins)", 
                       x = "", 
                       color = "") +
                  theme(legend.position = "bottom") ;  
                    ggsave(paste0(root, "avgduration_day_enum.png"), 
                          width = 15, 
                          height = 15, 
                          units = "cm")


  ## PART 3) Average response to a question per day + per day/per enumerator.

            
    ## 3.1) Average response to a question per day.
            
            surveys %>% 
              group_by(date) %>% 
              summarise(n = mean(matatu_own, 
                                 na.rm = T)) %>%
                ggplot(aes(x = date, 
                           y = n)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  theme_bw() +
                  labs(y = "Number of Matatus Owned (Average)", 
                       x = "", 
                       color = "") +
                  theme(legend.position = "bottom");  
                    ggsave(paste0(root, "avganswer_day.png"), 
                           width = 15, 
                           height = 15, 
                           units = "cm")
            
            
    ## 3.2) Average response to a question per day per enumerator.

            surveys %>% 
              group_by(date, enumerator_name) %>% 
              summarise(n = mean(matatu_own, 
                                 na.rm = T)) %>%
                ggplot(aes(x = date, 
                           y = n, 
                           color = enumerator_name, 
                           group = enumerator_name)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  theme_bw() +
                  scale_color_brewer(palette = "Dark2") + 
                  labs(y = "Number of Matatus Owned (Average)", 
                       x = "", 
                       color = "") +
                  theme(legend.position = "bottom");  
                    ggsave(paste0(root, "avganswer_day_enum.png"), 
                           width = 15, 
                           height = 15, 
                           units = "cm")


  ## PART 4) Share of 'other' per day + per day/per enumerator.
            
            
    ## 4.1) Share of 'other' per day.

            surveys %>% 
              group_by(date) %>% 
              summarise(n = mean(matatu_challenge_select_10, 
                                 na.rm = T)) %>% 
                ggplot(aes(x = date, y = n)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  geom_hline(yintercept = 0, color = NA) +
                  theme_bw() +
                  scale_y_continuous(label = percent) +
                  labs(y = "Share of 'Other Challenges' Selected", 
                       x = "", color = "") +
                  theme(legend.position = "bottom");  
                    ggsave(paste0(root, "avgother_day.png"), 
                           width = 15, 
                           height = 15, 
                           units = "cm")


    ## 4.2) Share of 'other' per day per enumerator.

            surveys %>% 
              group_by(date, 
                       enumerator_name) %>% 
              summarise(n = mean(matatu_challenge_select_10, 
                                 na.rm = T)) %>%
                ggplot(aes(x = date, y = n, 
                           color = enumerator_name, 
                           group = enumerator_name)) +
                  geom_line(alpha = 0.7) + 
                  geom_point(size = 2.5) +
                  geom_hline(yintercept = 0, 
                             color = NA) +
                  theme_bw() +
                  scale_color_brewer(palette = "Dark2") + 
                  scale_y_continuous(label = percent) +
                  labs(y = "Share of 'Other Challenges' Selected", 
                       x = "", 
                       color = "") +
                  theme(legend.position = "bottom");  
                    ggsave(paste0(root, "avgother_day_enum.png"), 
                           width = 15, 
                           height = 15, 
                           units = "cm")

###--------------------------------------------------------------------------###
            
###  C.) DESCRIPTIVE STATISTICS ###
  
  ## In this section, we create some descriptive tables and graphs based on 
  ## variables included in the data quality checks.

  ## Load the dataset.

    surveys <- 
      fread(paste0(root, 
                   "Demo Survey (without module completion)_WIDE.csv"))

    surveys %<>% filter(survey_result_update == 1)

  ## Create a function,

    produce_sumtable <- 
      function(var, 
               name){
                      sum_table <- 
                        tibble(Variable = name,
                               N        = sum(!is.na(var)),
                               Min      = min(var, na.rm = T),
                               Mean     = mean(var, na.rm = T),
                               Median   = median(var, na.rm = T),
                               Max      = max(var, na.rm = T),
                               SD       = sd(var, na.rm = T))
                                            
                      cat("\n", 
                          "----------", 
                          name, 
                          "Done -------------", 
                          "\n")
                    
                      return(sum_table)
                      
    }


  ## PART 1) TABLE: How many matatus do you own?


              produce_sumtable( # Call on above function
                
                surveys$matatu_own, "Matatus Owned"
                
                ) %>% 
                mutate_if(is.numeric, 
                          ~round(., 2)) %>% # Formatting appearance of stats
                kable(format = "latex", # LaTeX formatting
                      format.args = list(big.mark = ","), 
                      longtable = TRUE, 
                      row.names = FALSE, 
                      booktabs = T) %>%
                row_spec(0, 
                         bold = TRUE) %>% 
                kable_styling() %>% 
                writeLines(paste0(root, 
                                  "matatus_owned.tex")) # Export .tex file

  ## PART 2) TABLE: How much did you spend on repairing breaks?
              
            produce_sumtable(
  
              surveys$matatu_repair_breaks, "Break Repair Cost"
  
              ) %>% 
              mutate_if(is.numeric, 
                        ~round(., 2)) %>% 
              kable(format = "latex", 
                    format.args = list(big.mark = ","), 
                    longtable = TRUE, row.names = FALSE, 
                    booktabs = T) %>%
              row_spec(0, 
                       bold = TRUE) %>% 
              kable_styling() %>% 
              writeLines(paste0(root, 
                                "matatu_repair.tex")) 


  ## PART 3) GRAPH: How many matatus do you own?

             ggplot(surveys, # Create the plot
                    aes(x = matatu_own)) + 
               geom_density(fill="#69b3a2", # Plot options
                            color="#e9ecef", 
                            alpha = 0.8) +
               scale_x_continuous(labels = comma) +
               labs(x = "Number of Matatus Owned", # Label axes
                    y = "Density") +
               theme_bw();  
                ggsave(paste0(root, # Save the plot and export to working dir.
                              "nmatatus_owned.png"), 
                       width = 25, # Specify height and width of graph
                       height = 15, 
                       units = "cm")

  ## PART 4) GRAPH: Do you face any challenges managing your matatu?

             surveys %>% # Call upon loaded dataset
               select(mid, matatu_challenge) %>% # Select variables of interest
               mutate(tot = n_distinct(mid)) %>% # Create a new variable "tot"
               group_by(matatu_challenge, # Group obs. by mutatu_challenge and
                        tot) %>%          # tot - the new variable created
               summarise(n = n_distinct(mid)) %>% 
               mutate(p = n/tot) %>% # Create a new variable "p" (proportion)
               mutate(
                 matatu_challenge_label = # Create a new variable 
                    case_when( # Labels based on value of matatu_challenge                          
                      matatu_challenge == 1 ~ "Never", 
                      matatu_challenge == 2 ~ "Rarely",
                      matatu_challenge == 3 ~ "Sometimes",
                      matatu_challenge == 4 ~ "Always"
                                
                    )
                 ) %>% 
               ggplot(aes(x = reorder(matatu_challenge_label, # Create plot
                                      matatu_challenge), 
                          y = p, 
                          fill = reorder(matatu_challenge_label, 
                                         matatu_challenge))) +
                geom_bar(stat = "identity") + # Add plot options
                scale_fill_brewer(palette = "Reds", 
                                  guide = NULL) + 
                scale_y_continuous(labels = percent) + 
                labs(x = "", # Label X and Y axes
                     y = "Share of Matatu Owners") +
                theme_bw(); 
                  ggsave(paste0(root, # Save and export to working dir.
                                "matatu_challenge_any.png"), 
                         width = 25, # Specify height and width of graph
                         height = 15, 
                         units = "cm")


  ## PART 5) GRAPH: What challenges do you face in managing your matatu?

          # First we define a new object, df_graph. Then we filter to only
          # consider only those obs. which faced challenges in managing matatus.
             
             df_graph <- surveys %>% 
               filter(matatu_challenge != 1) %>% 
               select(mid, # Select only certain variables for analysis
                      matatu_challenge_select, 
                      starts_with("matatu_challenge_select")) %>% 
               select(-ends_with("_oth")) %>% 
               pivot_longer( # Convert wide data to long form
                cols         = -c(mid, matatu_challenge_select), # Columns from
                names_to     = "option", # Specifies new name
                values_to    = "yesno", # Specifies choice list for values
                names_prefix = "matatu_challenge_select_") %>% 
              mutate(
                option_label = # Relabel based on challenge faced
                  case_when(
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

                          
          # Now we define some other objects. 
             
            n_sample <- 
              df_graph$mid %>% # Using 'mid' variable from df_graph
              n_distinct() # Only distinct values, no duplicates
            
            n_options <- 
              df_graph$option_label %>% # Using values from 'option_label' var
              n_distinct() 
          
          # Now we start creating the plot using df_graph and objects defined

            
            df_graph %>%
              group_by(option_label) %>% # Group by 'option_label"
              summarise(tot = n(),       # Collapses dataset into variable of 
                        n = sum(yesno),  # interest, which is, 'p', which gives
                        p = n/tot) %>%   # share of owners who faced a challenge
              mutate( 
                order = ifelse( 
                  option_label == "Other", # Changes 'option_label' to 1 if 
                  -1,                      # challenge is "Other", otherwise 
                  p),                      # it changes to p
                option_label = str_to_title(option_label), 
                option_label = str_wrap(option_label, 40)
              ) %>%
              filter(n != 0 ) %>% # Only keep obs with non-zero values of n
                ggplot(aes( # Create plot after we have data in desired form
                           x = reorder(option_label, # X axis
                                       order), 
                           y = p, fill = reorder(option_label, # Y axis
                                                 order))) + 
                  geom_bar(stat = "identity") + # Add plot options
                  scale_fill_manual(values = magma(n_options), 
                                    guide = NULL) +
                  scale_y_continuous(labels = percent) +
                  theme_bw() + 
                  labs(x = "", 
                       y = paste0("Share of Matatu Owners (N = ", 
                                  comma(n_sample), 
                                  ")")) +
                  coord_flip(); 
                    ggsave(paste0(root, 
                                  "matatu_challenge.png"), 
                           width = 25, 
                           height = 15, 
                           units = "cm")


  ## PART 6) GRAPH: How much did you spend on repairing breaks?

             ggplot(surveys, aes(x = matatu_repair_breaks)) + 
               geom_histogram(binwidth = 50, 
                              fill = "#69b3a2", 
                              color = "#e9ecef", 
                              alpha = 0.9) + 
               scale_y_continuous(labels = comma) +
               scale_x_continuous(labels = comma) +
               labs(x = "Break Repair Cost", 
                    y = "Number of Owners") +
               theme_bw();  
                ggsave(paste0(root, 
                              "matatu_repair.png"), 
                       width = 25, 
                       height = 15, 
                       units = "cm")
             
             
################################################################################
# #                                                                          # #
#--------------------------- END OF SCRIPT ------------------------------------#
# #                                                                          # #
################################################################################          