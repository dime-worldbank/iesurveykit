
# Complementary Quality Checks Analysis

## Deep dive into the variables (see sample_analysis.R):
1. Track multiple select outcomes that are difficult to visualize using pivot tables in Google Sheets.
2. Track all of the variables in the dataset to produce a latex file that allows the team to scroll through all the variables in the dataset
  1. We produce a template code that shows how to create 1) summary statistics table; 2) bar graph (for categorical variables; 3) histogram and k-density for continuous variables.
3. Produce a list for duplicates for complete surveys (same UID submitted twice but with different answers - we need to check with FC which one to keep) (see sample_checks.R)
4. Finalize list of incomplete surveys  (sometimes preloads are not updated in a timely fashion, and may indicate that a survey is incomplete when the correct number of attempts (5) have been made and the respondent wasn’t reached OR the survey is actually complete. We need to do a more manual check to remove these cases so that the FC doesn’t go back to the team asking for more submissions) (see sample_checks.R)
5. Flag inconsistencies in incomplete surveys (the number of attempts/completion status in the tracker (which result from the limitations we discuss above in the server capturing this information). (see sample_checks.R)
6. Produce a list of outliers (see sample_checks.R)
  a. Time series deep dive (see sample_analysis.R): Track how response behaviors are changing over time. This is only really helpful for smaller survey teams where the graphs are more legible.
  b. Number of surveys per day  + per day/per enumerator
  c. Average survey duration per day + per day/per enumerator
  d. Share of ‘other’ per day + per day/per enumerator
  e. Average response to a question per day + per day/per enumerator
