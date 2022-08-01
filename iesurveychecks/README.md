# `iesurveychecks` Workflow

The `iesurveychecks` toolkit details the full workflow to create a dashboard for [real-time data quality checks](https://dimewiki.worldbank.org/High_Frequency_Checks) of survey data. This toolkit takes as an input a questionnaire programmed using SurveyCTO software and produces a dashboard using Google Sheets.


## Real time Google Sheets dashboard

`iesurveychecks` and the real time data quality dashboard includes the following data quality checks:

* <b> Survey log checks </b> : These checks are designed to track the progress of surveys through the data collection period. Number of surveys complete, average response rate, and average survey duration.
* <b> Response quality checks </b> : These checks are designed to ensure that responses are consistent for a particular survey instrument, and that the responses fall within a particular range. For example, checks to ensure that all variables are standardized, and there are no outliers in the data.
* <b> Enumerator checks </b> : These are designed to check if data shared by any particular enumerator is significantly different from the data shared by other enumerators. Some parameters included are survey logs/survey completion tracking at the enumerator level, data quality per enumerator

The following steps should be followed to set up the high frequency checks dashboard

1. [Adapt SurveyCTO forms](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/1-adapt-scto-forms.md)
2. [Set up HFC Dashboard](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/2-set-up-hfc-dashboard.md)

We also outline some [best practices and commonly faced issues](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/best-practices-and-issues.md) in setting up these real time HFC dashboards.

## Additional complementary analysis

The real time checks can be supplemented with some analysis on a statistical software (such as R) which take a deeper dive into the above mentioned checks or look at some additional checks such as:

* <b> Programming checks </b> : These test for issues in logic or skip patterns that were not spotted during questionnaire programming. These also include checking for data that is missing because the programmed version of the instrument skips certain questions.
* <b> Other checks related to the project</b> : These include checking if start date and end date of an interview are the same, or ensuring that there is at least one variable that has a unique ID. Further, in the case of administrative data, there can be daily checks to check and compare data with previous records, and ensure that participation in a study was only offered to those who were selected for treatment.

A sample of how to program these checks are detailed in [Complementary analysis]https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/3-complementary-analysis-r.md).

## Advanced: Including module completion
Long surveys or surveys dealing with sensitive topics it may be difficult to get respondents to stay for the whole duration in one sitting so this allows submission of partial surveys and can be picked up on a later date / time, even by another enumerator. In such cases, [module completion checks](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/4-module-completion-checks.md) help keep track of completion at the module level.  Please note that module completion tracker should be used judiciously as it is useful for very long surveys but is complex to set up with it's own set of challenges.

## Relevant Links
### SurveyCTO Forms and preload datasets </b>  
1. Without module completion
  - [Survey Form Template](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/scto/Survey%20Form%20Template%20(without%20module%20completion).xlsx)
  - [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/scto/Preloaded%20Data%20Sample.xlsx)
  - [SurveyCTO form test and fill](https://boruis.surveycto.com/collect/demo_survey?caseid=)

2. With module completion
- Survey Form Template
- [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)
- [SurveyCTO form test and fill](https://boruis.surveycto.com/collect/demo_survey_module_completion?caseid= )

### Dashboard Template </b>  
1. [HFC Dashboard Template (Viewer-mode)](https://docs.google.com/spreadsheets/d/16S2GlDgdeSuzAJEeML8ieDOjKYK7QzfHlrkJE6AwdC4/edit?usp=sharing)
2. [HFC Dashboard Template (Editor-mode)](https://docs.google.com/spreadsheets/d/1iji2n0nSpS6tE4vOp9EwTb_TdvT-KC2J7wIMqw_q22M/edit?usp=sharing)  

### Complementary analysis </b>  
1. [Sample checks](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_checks.R)
2. [Sample analysis](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/r/sample_analysis.R)
