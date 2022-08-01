
# Complementary Quality Checks Analysis

In addition to the real time data quality checks published on the dashboard using [the HFC dashboard](), additional checks can be done on statistical software for checks that are difficult to visualize using pivot tables or those which require a deeper dive. These checks include:  

1. <b> Duplicates check </b>: Produce a list for duplicates for complete surveys (same unique ID submitted twice but with different answers - we need to check with field team which one to keep) (see [sample_checks.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R))
2. <b> Advanced survey logs checks </b> Finalize list of incomplete surveys  (sometimes preloads are not updated in a timely fashion, and may indicate that a survey is incomplete when the correct number of attempts (5) have been made and the respondent wasn’t reached OR the survey is actually complete. We need to do a more manual check to remove these cases so that the FC doesn’t go back to the team asking for more submissions) (see [sample_checks.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R))
3. Flag inconsistencies in incomplete surveys (the number of attempts/completion status in the tracker (see [sample_checks.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R))
4. <b> Response Quality Checks</b>: Track all of the variables in the dataset to produce a latex file that allows the team to scroll through summary statistics of all the variables in the dataset. [sample_checks.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R))produce a template code that shows how to create
    * summary statistics table
    * bar graph (for categorical variables)
    * histogram and k-density (for continuous variables)
5. <b> Response Quality Checks</b>:Produce a list of outliers (see [sample_checks.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R))
  a. Time series deep dive (see [sample_analysis.R](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_analysis.R)): Track how response behaviors are changing over time. This is only really helpful for smaller survey teams where the graphs are more legible.
  b. Number of surveys per day  + per day/per enumerator
  c. Average survey duration per day + per day/per enumerator
  d. Share of ‘other’ per day + per day/per enumerator
  e. Average response to a question per day + per day/per enumerator
