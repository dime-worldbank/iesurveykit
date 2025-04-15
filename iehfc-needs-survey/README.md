# iehfc Needs Assessment Survey – Cleaned Dataset

This dataset contains **74 responses** to the *Needs Assessment for iehfc* survey, conducted by DIME Analytics. The goal of the survey was to gather input from researchers and M&E professionals on their current practices and challenges related to **high-frequency data quality checks**. The results will inform the development of **iehfc**, a tool designed to streamline and standardize these checks across development research projects.

## Files Included

- `iehfc_needs_assessment_survey_data.csv`: Cleaned dataset with survey responses
- `iehfc-needs-survey-questionnaire.pdf`: Full survey questionnaire, including question wording and variable names

## Cleaning Summary

- Removed identifying variables and responses submitted after April 2023.
- Added a unique row ID.
- Converted "Other", "Don't Know", and "Refused to Answer" responses to `NA`.
- Removed multiple-choice variables (e.g., those with values like “1 2 3”), retaining only single-answer dummy variables.
- Recoded repeated group answers into dummy variables representing combinations of HFC tools and improvable features.
- Renamed dummy variables for clarity (e.g., `q4_responsibility_1` → `q4_responsibility_run`).
