# Advanced: Module Completion Checks

A module completion tracker is useful for very long surveys which are broken down in parts. You can create your survey forms such that module completion is tracked along with the HFCs.

## How to add survey completion checks
Prepare the high frequency checks survey form as detailed in [Adapt Survey Forms](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/1-adapt-scto-forms.md) and supplement with the following instructions.


## Advanced changes in the survey form for module completion checks:
1. <b> Submission in the middle of a survey: </b>
- A yesno “select_one” field at the end of every module (except the last module) that asks “Is the respondent still available? (Please select “No” if you agreed to stop the survey here and start again a some other time)"
- A “calculate” field (must be placed at the end of the survey) for every module you have in the survey. This variable tracks the completion status for each module.  It should be equal to 1 if a particular module is completed and otherwise 0.
- A “calculate” field that adds up the <b>last_module_completed</b> variable pulled from the preload sheet and all the 0-1 module completion status calculate fields you created for each module.
Add a relevance expression for every module group you have in your survey form so that only modules that are not completed in the previous submissions are visible to the respondents.
2. <b>Duplicate submissions check:</b>
- This check refers to the orange “Check 1” box in the survey process flowchart.
- After the enumerator selects a household id, the survey form will check the completion status for the selected household id from the preloaded server dataset. If the completion status is equal to 1 (“Complete”), a warning note will appear preventing the enumerator from moving forward.
- This warning is created by adding a “Note” field with a relevance expression of “${complete_status_pl} = 1”  and “required action” option set to “Yes”.
<img src="https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/img/image3.png"><!--- Image is read from master branch or use full URL-->
3. <b>Maximum number of submissions (subject to change):</b>
- This check is designed to close a survey if the number of previous submissions has reached a certain threshold, which in the sample survey form is 5. In other words, if the enumerator has contacted the respondent 5 times and the respondent either never picked up the call or kept rescheduling, the enumerator DOES NOT have to contact the respondent again.
- This check is created by pulling the attempt counter variable from the preloaded dataset. If attempt counter + 1 is equal to the threshold, completion status will be changed from “Incomplete” to “Complete”, and survey outcome will be changed from “Pending” to “Non-responded”.
4. <b>Next call date (subject to change):</b>
- This constraint refers to the 7.1 box in the survey process flowchart.
- If no one answers the phone or the respondent reschedules with the enumerator, the enumerator needs to enter a next call date and time. The next call date must be within the next 2 days.
- This constraint is created by adding a constraint expression of `“( number(${next_call_datetime}) - number(now()) ) <= 2”`.
5. <b>Check whether a response was changed:</b>
 - By adding a “calculate here” field with the expression “once(${fieldname})” right after the question, we are able to capture the initial response entered to see if the enumerators/respondents fill in answers and then go back to change them.
 - As this expression only captures the initial responses, it is recommended to add one additional calculate field with the argument “if(once(${fieldname}) != ${fieldname}, 1, 0)” to create a dummy variable that returns 1 if the answer is changed.
 - For more information, see the form template or this [link](https://www.surveycto.com/best-practices/using-calculations/).
6. <b>Monitor Module Duration:</b>
- Create a “calculate here” field with the expressions “once(format-date-time(now(), '%Y-%b-%e %H:%M:%S'))” at the beginning and the end of a module to capture the start time and end time for the module.
- This allows you to track how long an enumerator completes a module.
7. <b>Enumerator Check:</b>
- It's often better to assign enumerators to each survey ahead of time, but when you can't then we propose the following:
- The enumerator selects their name, the village, and the farmer’s name/household ID they want to survey.
- For every submitted survey, we track the enumerator’s name so that if the survey is not completed, a note will appear the next time the survey is opened to remind whomever is opening the survey who the previous enumerator to complete the survey was.  


In addition to the variables listed in [# Setting up a Real-time data quality checks dashboard](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/2-set-up-hfc-dashboard.md), the original preloaded data should also include the following item:
[(see Preload Sample (with Module Completion) - Part A)](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)

  5. last module completion status column with pre-assigned values of 0 (0 module completed):  This variable describes the last module completed by the respondent. Assuming your survey has 5 modules in total and the 5 modules are organized in a sequential order, in the cases where the respondent left in the middle of the survey, this variable will be changed from 0 to X (X is the number of modules completed by the respondent before leaving). Next time when the enumerator opens the same survey, it will start from the (X + 1)th module instead of the first module.

You will also need to prepare another preload data sheet (extra!) with 2 columns:
[(see Preload Sample (with Module Completion)- Part B)](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/iesurveychecks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)

  1. module name: the name of each module
  2. module index: the corresponding index of each module (e.g. index = 1 if it is the first module appeared in the survey, index = 2 if it is the second module appeared in the survey)

## The benefits/drawbacks of module completion

1. <b> Advantages </b> - In long surveys or surveys dealing with sensitive topics it may be difficult to get respondents to stay for the whole duration in one sitting so this allows submission of partial surveys and can be picked up on a later date / time, even by another enumerator.
2. <b> Disadvantages </b>  - It can be time consuming to code up and the code is prone to errors. Next, when you start up an incomplete survey, it will start after the last module not question so if halfway through module X the respondent drops off, the next time the survey will begin at module X’s first question, so you lose data.
  - Cleaning is also difficult: you have to collapse different submissions for the same survey into 1 and it becomes hard to track
  - The issues related to duplicates that we detail in the limitation section below are further exacerbated.

Module trackers are great for long surveys but come with a set of challenges, so if your survey is short we advice considering the pros and cons of adding module completion trackers to the surveys.


## How it works (if you’re interested)

When you submit module A, and then you go back to do the survey again and submit module B - in principle we would think that SurveyCTO would overwrite module A and show an incomplete survey but it seems to be keeping the data from module A in the first submission.

- Explanation: In SurveyCTO, an empty field can take on two potential statuses. It can be an implicit null value or an explicit null value. Implicit null values are fields INACCESSIBLE to the enumerators during the survey because they do not meet the relevance condition(s). Explicit null values are fields accessible to the enumerators but with an empty value.
- When SurveyCTO exports data to the Google Sheet, explicit null values are exported to the Google Sheet and will REPLACE all existing values in the matched columns. However, implicit null values will NOT be exported and therefore, the existing values in the Google Sheet will NOT be replaced/updated.  
- Example (1): In the form template, we asked the enumerators to enter the next call date (field label: `next_call_datetime`) if the respondent is unavailable right now. If the enumerator is able to complete the survey with the respondent, this question will not be shown to the enumerator. Therefore, this field (`next_call_datetime`) will have an implicit null value under such circumstances. However, in the form template, there is a calculate field that formats results from the `next_call_datetime` field. Since it is a “calculate” field, though hidden, it is always updated with every submission. Therefore, this field will have an explicit null value even if the enumerator is never asked to enter a next call date.
  - This means that if the survey is submitted a second time (and completed that second time) the enumerator will not have to fill this out, and the `next_call_datetime` field will remain empty. However, because it is an explicit null value due to the presence of calculate field that formats the result, this data will overwrite any previously stored `next_call_datetime` from an incomplete survey submitted earlier.
- Example (2): Say an enumerator completes Module A on the first attempt, and then when he calls back he is brought to Module B (because module A was already completed). Then in this second survey, all the values from Module A are implicit null (never prompted to fill these out because it was already completed); and values from Module B are filled in. When google sheets exports the data Module A will not be ‘overwritten’ because they are implicit nulls.



## Ease of reading the checks

The template real time data quality checks dashboard uses conditional formatting to highlight different types of Completion and Survey Outcomes.

- <b> Completion Status (complete vs incomplete) </b>: This variable describes the result of the survey from the perspective of the enumerators. “Complete” surveys are surveys requiring NO FURTHER action from the enumerators regardless of whether the survey is filled out by the respondent or not. Specifically, in the survey process flowchart, “complete” surveys refer to the end node boxes highlighted in green and red, while “incomplete” surveys are the box highlighted in yellow.
- <b> Survey Outcomes (pending vs responded vs non-responded) </b>: This variable describes the result of survey from the research perspective. It further divides “complete” surveys into “responded” surveys and “non-response” surveys.  Specifically,
  - “Pending” surveys are incomplete surveys (yellow box)
  - “Responded” surveys are “complete” surveys filled out by the respondents (green box)
  - “Non-responded” surveys are “complete” surveys but NOT filled out by the respondents (red box). This could happen if the respondent is unavailable, refuses to participate or keeps rescheduling.


| Completion Status | Survey Outcome  | Color of End Node Box |Without Module Completion | With Module Completion|
| ------------- | ------------- | ------------ | ------------ | ------------ |
| Complete | Responded | Green | Respondent agreed to participate and completed the survey | Respondent agreed to participate and completed all modules |
| Complete | Non-responded | Red | Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |
| Incomplete (Call Back) | Pending | Yellow | Respondent did not answer the call or was busy and wanted to reschedule   (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) | a. Respondent did not answer the call or was busy and wanted to reschedule. b. Respondent agreed to participate but did not complete all modules (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) |


## Relevant Links

### SurveyCTO Forms and preload datasets </b>  
1. With module completion
- Survey XLSForm Template
- [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)
- [Deployed SurveyCTO form test and fill](https://boruis.surveycto.com/collect/demo_survey_module_completion?caseid= )
