#==============================================================================#
#                                                                              #
#           HIGH-FREQUENCY CHECKS  -- DATA QUALITY CHECKS & ANALYSIS           #
#                                                                              #
#------------------------------------------------------------------------------#
#                                                                              #
# The purpose of this script is to produce data quality checks by survey date  #
# and enumerator, and create aggregated descriptive statistics                 #
#                                                                              #
#==============================================================================#

# Folder structure is unclear!
# SETUP ------------------------------------------------------------------------

  # Install all required packages
  pacman::p_load(
    data.table, 
    dplyr, 
    tidyverse, 
    magrittr, 
    lubridate, 
    scales, 
    viridis,
    here,
    stringr, 
    knitr,
    kableExtra
  )

# FUNCTIONS --------------------------------------------------------------------

  graph_save <- 
    function(filename, width = 15, height = 15) {
      
      ggsave(
        here(
          filename
        ), 
        height = height, 
        width = width,
        units = "cm"
      )
      
    }
  
  graph_by_date <-
    function(var, label) {
      
      surveys_by_date %>%
        ggplot(
          aes(
            x = date, 
            y = get(var)
          )
        ) +
        geom_line(alpha = 0.7) + 
        geom_point(size = 2.5) +
        theme_bw() +
        labs(
          y = label, 
          x = NULL, 
          color = NULL
        ) +
        theme(legend.position = "bottom")
    }
  
  graph_by_enum_date <-
    function(var, label) {
      
    surveys_by_enum_date %>%
      ggplot(
        aes(
          x = date, 
          y = get(var), 
          color = enumerator_name, 
          group = enumerator_name
        )
      ) +
      geom_line(alpha = 0.7) + 
      geom_point(size = 2.5) +
      geom_hline(
        yintercept = 0, 
        color = NA
      ) +
      theme_bw() +
      scale_color_brewer(palette = "Dark2") + 
      labs(
        y = label, 
        x = NULL, 
        color = NULL
      ) +
      theme(legend.position = "bottom")
  }

# TIME SERIES DATA QUALITY CHECKS BY ENUMERATORS -------------------------------

 # Load the dataset
 surveys <- 
   fread(
     here(
       "Demo Survey (without module completion)_WIDE.csv"
     )
   )

 # Clean the data
 surveys <-
   surveys %>%
   mutate(
     SubmissionDate = as_date(
       SubmissionDate, 
       format = "%b %d, %Y"
     ), 
     across(
       c(starttime, endtime),
       ~ as_datetime(., format = "%b %d, %Y %I:%M:%S %p")
     ),
     duration = difftime(
       endtime_format, 
       starttime_format, 
       units = "mins"
     )
   )
     

## Summarise data by day and day+enumerator ------------------------------------
 
 surveys_by_date <-
   surveys %>% 
   group_by(date) %>%
   summarise(
     # Number of survey submissions
     n_surveys = n(),
     # Average survey duration
     av_duration = mean(duration),
     # Average response to a question
     av_matatus = mean(matatu_own, na.rm = T),
     # Average number of occurrences of an "other" selection
     share_other = mean(matatu_challenge_select_10, na.rm = T)
   )
 
 surveys_by_enum_date <-
   surveys %>%
   group_by(
     enumerator_name,
     date
   ) %>%
   summarise(
     # Number of survey submissions
     n_surveys = n(),
     # Average survey duration
     av_duration = mean(duration),
     # Average response to a question
     av_matatus = mean(matatu_own, na.rm = T),
     # Average number of occurrences of an "other" selection
     share_other = mean(matatu_challenge_select_10, na.rm = T)
   )
 
## Create graphs ---------------------------------------------------------------

 graph_by_date("n_surveys", "Number of Submissions")
 graph_save("nsubmission_day.png")
  
 graph_by_enum_date("n_surveys", "Number of Submissions")
 graph_save("nsubmission_day_enum.png")
 
 graph_by_date("av_duration", "Average Survey Duration (Mins)")
 graph_save("avgduration_day.png")
  
 graph_by_date_enum("av_duration", "Average Survey Duration (Mins)")
 graph_save("avgduration_day_enum.png")

 graph_by_date("av_matatus", "Number of Matatus Owned (Average)")
 graph_save("avganswer_day.png")
  
 graph_by_date_enum("av_matatus", "Number of Matatus Owned (Average)")
 graph_save("avganswer_day_enum.png")

 graph_by_date("share_other", "Share of 'Other Challenges' Selected")
 graph_save("avgother_day.png")
  
 graph_by_date_enum("share_other", "Share of 'Other Challenges' Selected")
 graph_save("avgother_day_enum.png")
  
  
### Average response to a question per day -------------------------------------
  
 graph_by_date(
   "av_matatus",
   "Number of Matatus Owned (Average)"
 )
  
 graph_save("avganswer_day.png")
  
  
### Average response to a question per day per enumerator ----------------------
  
 graph_by_date_enum(
   "av_matatus",
   "Number of Matatus Owned (Average)"
 )

 graph_save("avganswer_day_enum.png")
  
  
### Share of 'other' per day ---------------------------------------------------

 graph_by_date(
   "share_other",
   "Share of 'Other Challenges' Selected"
 )

 graph_save("avgother_day.png")
  
  
### Share of 'other' per day per enumerator ------------------------------------
  
 graph_by_date_enum(
   "share_other",
   "Share of 'Other Challenges' Selected"
 )
 
 graph_save("avgother_day_enum.png")
  
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