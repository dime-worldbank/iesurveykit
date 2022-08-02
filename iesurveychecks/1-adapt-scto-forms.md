
# 1. Adapting SurveyCTO forms
When [programming a questionnaire for electronic data collection](https://docs.surveycto.com/02-designing-forms/01-core-concepts/02.starting-a-new-form.html), it requires to be adapted to include the data quality checks by taking into account all possible scenarios that an enumerator may encounter during the collection process.
## Prepare pre-loaded dataset

The preloaded data should include at least the following items:
[see Preload Sample](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/scto/Preloaded%20Data%20Sample.xlsx)

  1. Basic survey information such as the household/respondent id and assigned enumerator name.  Household/respondent ID should be unique.
  2. An attempt counter column with pre-assigned values of 0 (0 submissions). This variable, `attempt_counter`, describes the number of previous submissions for each survey.
  3. A completion status column with pre-assigned values of 0 (Incomplete). This variable, `complete_status`, will be changed to 1 once the survey is completed by the enumerator.
  4. A survey outcome column with pre-assigned values of 2 (Pending).  Once the completion status becomes 1, this variable, `survey_result`, will be changed to 1 if the survey is filled out by the respondent or to 0 if the survey is NOT filled out by the respondent.

## Necessary changes in the SurveyCTO form
The XLSForm you're designing for the survey requires some edits to be included to publish checks in real time. Since the survey form needs to actively pull data from a server dataset, the survey form needs to have calculate fields that will reference this server dataset. Examples of calculates field require are:
1. Generic: “Calculate” fields that pull variables from the preloaded data. There should be one “Calculate” field for each column in the preloaded data
   * Example:  `pulldata('hhplotdata', 'plot1size', 'hhid_key', ${hhid})` will pull a value from an attached server dataset called hhplotdata (This is the dataset id you entered when you created the server dataset). The value will come from the plot1size column of the pre-loaded data, and the hhid field will be used to identify the matching row in the pre-loaded data's `hhid_key` column
   * Recommended naming convention:  adding a “_pl” suffix to the original name

2. For tracking: A “Calculate” field that updates the <b?attempt counter</b> variable every time the enumerator submits a survey.
    * Example: `${attempt_counter_pl} + 1, where attempt_counter_pl` is the name of the pulled variable

3. For tracking: Two “Calculate” fields that respectively update the <b>completion status</b> variable and the <b>survey outcome variable</b> every time the enumerator submits a survey
    * This can be created by setting the if-else argument with/or coalesce argument. For specific examples, please see the SurveyCTO form template.
    * Recommended naming convention: adding a “_update” suffix to distinguish from the pulled variables
