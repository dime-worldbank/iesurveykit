
# 1. Adapting SurveyCTO forms
When [programming a questionnaire for electronic data collection](https://docs.surveycto.com/02-designing-forms/01-core-concepts/), it requires to be adapted to include the data quality checks by taking into account all possible scenarios that an enumerator may encounter during the collection process. (Instructions on how to create a SurveyCTO form can be found [here). When designing your survey form, it is important to take into account all possible scenarios that an enumerator may encounter during the collection process.

### Prepare pre-loaded dataset

The preloaded data should include at least the following items:
[(see Preload Sample (without Module Completion))](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/scto/Preloaded%20Data%20Sample.xlsx))

  1. Basic survey information such as the household/respondent id and assigned enumerator name.  Household/respondent ID should be unique
  2. An attempt counter column with pre-assigned values of 0 (0 submissions). This variable describes the number of previous submissions for each survey
  3. A completion status column with pre-assigned values of 0 (Incomplete). This variable will be changed to 1 once the survey is completed by the enumerator
  4. A survey outcome column with pre-assigned values of 2 (Pending).  Once the completion status becomes 1, this variable will be changed to 1 if the survey is filled out by the respondent or to 0 if the survey is NOT filled out by the respondent

## Necessary changes in the SurveyCTO form
Edit your survey form to include the following fields:
Since the survey form needs to actively pull data from this server dataset - your survey form needs to have calculate fields that will reference this server dataset.
NOTE: As the form is encrypted forms, all the following fields must be explicitly marked as “publishable” (with a “yes” in their publishable column). Fields explicitly marked as publishable are left unencrypted so that they can be conveniently published to cloud services or directly downloaded from the server.
1. Generic: “Calculate” fields that pull variables from the preloaded data. There should be one “Calculate” field for each column in the preloaded data
  * Example:  `pulldata('hhplotdata', 'plot1size', 'hhid_key', ${hhid})` will pull a value from an attached server dataset called hhplotdata (This is the dataset id you entered when you created the server dataset). The value will come from the plot1size column of the pre-loaded data, and the hhid field will be used to identify the matching row in the pre-loaded data's `hhid_key` column
  * Recommended naming convention:  adding a “_pl” suffix to the original name

2. For tracking: A “Calculate” field that updates the <b?attempt counter</b> variable every time the enumerator submits a survey.
* Example: `${attempt_counter_pl} + 1, where attempt_counter_pl` is the name of the pulled variable

3. For tracking: Two “Calculate” fields that respectively update the <b>completion status</b> variable and the <b>survey outcome variable</b> every time the enumerator submits a survey
  * This can be created by setting the if-else argument with/or coalesce argument. For specific examples, please see the SurveyCTO form template.
  * Recommended naming convention: adding a “_update” suffix to distinguish from the pulled variables
