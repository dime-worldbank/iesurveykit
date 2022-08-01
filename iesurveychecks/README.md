# `iesurveychecks` Workflow

The `iesurveychecks` toolkit details the full workflow to create a dashboard for [real-time data quality checks](https://dimewiki.worldbank.org/High_Frequency_Checks) of survey data. This toolkit takes as an input a questionnaire programmed using SurveyCTO software and produces a dashboard using Google Sheets.

## Steps to create the real time dashboard
1. [Prepare Survey forms](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/1-prepare-scto-forms.md)
2. [Adapt Survey forms](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/2-adapt-scto-forms.md)




## Real time Google Sheets dashboard

`iesurveychecks` and the real time data quality dashboard includes the following data quality checks:

* <b> Duplicates and survey log checks </b> : These ensure that all the data collected from the field is on the server, and that there are no duplicates. In case some data is missing, or the survey forms are incomplete, share a report with the field team and identify the reasons for low completion rate. In case there are duplicate IDs, identify and resolve them.

* <b> Enumerator checks </b> : These are designed to check if data shared by any particular enumerator is significantly different from the data shared by other enumerators. Some parameters to check enumerator performance include percentage of "Don't know" responses, or average interview duration. In the first case, there might be a need to re-draft the questions, while in the second case, there might be a need to re-train enumerators.
In order to include these checks you
1. [Adapt SurveyCTO forms]()
2. [Set up HFC Dashboard](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/3-set-up-hfc-dashboard.md)

We also outline some [best practices and commonly faced issues](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/best-practices-and-issues.md) in setting up these real time HFC dashboards.

## Additional complementary analysis

The real time checks can be supplemented with some analysis on a statistical softare (such as R) which look for the following checks.

* <b> Response quality checks </b> : These checks are designed to ensure that responses are consistent for a particular survey instrument, and that the responses fall within a particular range. For example, checks to ensure that all variables are standardized, and there are no outliers in the data. Share a daily log of such errors, and check if it is an issue with enumerators, in which case there might be a need to re-train enumerators.

* <b> Other checks related to the project</b> : These include checking if start date and end date of an interview are the same, or ensuring that there is at least one variable that has a unique ID. Further, in the case of administrative data, there can be daily checks to check and compare data with previous records, and ensure that participation in a study was only offered to those who were selected for treatment. For example, in an intervention involving cash transfers, check the details of the accounts to ensure that the account is in the name of a person who was selected for treatment.

* <b> Programming checks </b> : These test for issues in logic or skip patterns that were not spotted during questionnaire programming. These also include checking for data that is missing because the programmed version of the instrument skips certain questions. In this case, program the instrument again, and double-check for errors.

A sample of how to program these checks are detailed in [Complementary analysis](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/4-complementary-analysis-r.md).

## Advanced: Including module completion
For long surveys

[Module completion checks](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/5-survey-completion-checks.md)




## Relevant Links
### SurveyCTO Forms and preload datasets </b>  
1. Without module completion
  - [Survey Form Template](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Survey%20Form%20Template%20(without%20module%20completion).xlsx)
  - [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample.xlsx)
  - [SurveyCTO form test and fill](https://boruis.surveycto.com/collect/demo_survey?caseid=)

2. With module completion
- Survey Form Template
- [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)
- [SurveyCTO form test and fill](https://boruis.surveycto.com/collect/demo_survey_module_completion?caseid= )

### Dashboard Template </b>  
1. [HFC Dashboard Template (Viewer-mode)](https://docs.google.com/spreadsheets/d/16S2GlDgdeSuzAJEeML8ieDOjKYK7QzfHlrkJE6AwdC4/edit?usp=sharing)
2. [HFC Dashboard Template (Editor-mode)](https://docs.google.com/spreadsheets/d/1iji2n0nSpS6tE4vOp9EwTb_TdvT-KC2J7wIMqw_q22M/edit?usp=sharing)  

### Complementary analysis </b>  
1. [Sample checks](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/r/sample_checks.R)
2. [Sample analysis](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/r/sample_analysis.R)
