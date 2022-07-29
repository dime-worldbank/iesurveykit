
# 2. Adapting SurveyCTO forms


Go back to the survey form uploaded to the server using [these instructions]()

1. <b> Necessary changes </b>:  Edit your survey form to include the following fields
Since the survey form needs to actively pull data from this server dataset - your survey form needs to have calculate fields that will reference this server dataset.
NOTE: As the form is encrypted forms, all the following fields must be explicitly marked as “publishable” (with a “yes” in their publishable column). Fields explicitly marked as publishable are left unencrypted so that they can be conveniently published to cloud services or directly downloaded from the server.

    1. Generic: “Calculate” fields that pull variables from the preloaded data. There should be one “Calculate” field for each column in the preloaded data
      * Example:  `pulldata('hhplotdata', 'plot1size', 'hhid_key', ${hhid})` will pull a value from an attached server dataset called hhplotdata (This is the dataset id you entered when you created the server dataset). The value will come from the plot1size column of the pre-loaded data, and the hhid field will be used to identify the matching row in the pre-loaded data's `hhid_key` column
      * Recommended naming convention:  adding a “_pl” suffix to the original name

    2. For tracking: A “Calculate” field that updates the <b?attempt counter</b> variable every time the enumerator submits a survey.
    * Example: `${attempt_counter_pl} + 1, where attempt_counter_pl` is the name of the pulled variable

    3. For tracking: Two “Calculate” fields that respectively update the <b>completion status</b> variable and the <b>survey outcome variable</b> every time the enumerator submits a survey
      * This can be created by setting the ifelse argument with/or coalesce argument. For specific examples, please see the SurveyCTO form template.
      * Recommended naming convention: adding a “_update” suffix to distinguish from the pulled variables
2. <b> Additional optional changes </b> : module completion checks:
      1. <b> Submission in the middle of a survey: </b>
        - A yesno “select_one” field at the end of every module (except the last module) that asks “Is the respondent still available? (Please select “No” if you agreed to stop the survey here and start again a some other time)"
        - A “calculate” field (must be placed at the end of the survey) for every module you have in the survey. This variable tracks the completion status for each module.  It should be equal to 1 if a particular module is completed and otherwise 0.
        - A “calculate” field that adds up the <b>last_module_completed</b> variable pulled from the preload sheet and all the 0-1 module completion status calculate fields you created for each module.
        Add a relevance expression for every module group you have in your survey form so that only modules that are not completed in the previous submissions are visible to the respondents.
      2. <b>Duplicate submissions check:</b>
        - This check refers to the orange “Check 1” box in the survey process flowchart.
        - After the enumerator selects a household id, the survey form will check the completion status for the selected household id from the preloaded server dataset. If the completion status is equal to 1 (“Complete”), a warning note will appear preventing the enumerator from moving forward.
        - This warning is created by adding a “Note” field with a relevance expression of “${complete_status_pl} = 1”  and “required action” option set to “Yes”.

    <img src="https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/img/image3.png"><!--- Image is read from master branch or use full URL-->

      3. <b>Maximum number of submissions (subject to change):</b>
        - This check is designed to close a survey if the number of previous submissions has reached a certain threshold, which in the sample survey form is 5. In other words, if the enumerator has contacted the respondent 5 times and the respondent either never picked up the call or kept rescheduling, the enumerator DOES NOT have to contact the respondent again.
        - This check is created by pulling the attempt counter variable from the preloaded dataset. If attempt counter + 1 is equal to the threshold, completion status will be changed from “Incomplete” to “Complete”, and survey outcome will be changed from “Pending” to “Non-responded”.
      4. <b>Next call date (subject to change):</b>
        - This constraint refers to the 7.1 box in the survey process flowchart.
        - If no one answers the phone or the respondent reschedules with the enumerator, the enumerator needs to enter a next call date and time. The next call date must be within the next 2 days.
        - This constraint is created by adding a constraint expression of “( number(${next_call_datetime}) - number(now()) ) <= 2”.
      5. <b>Check whether a response was changed:</b>
         - By adding a “calculate here” field with the expression “once(${fieldname})” right after the question, we are able to capture the initial response entered to see if the enumerators/respondents fill in answers and then go back to change them.
         - As this expression only captures the initial responses, it is recommended to add one additional calculate field with the argument “if(once(${fieldname}) != ${fieldname}, 1, 0)” to create a dummy variable that returns 1 if the answer is changed.
         - For more information, see the form template or this link.
       6. <b>Monitor Module Duration:</b>
        - Create a “calculate here” field with the expressions “once(format-date-time(now(), '%Y-%b-%e %H:%M:%S'))” at the beginning and the end of a module to capture the start time and end time for the module.
        - This allows you to track how long an enumerator completes a module.
      7. <b>Enumerator Check:</b>
        - It's often better to assign enumerators to each survey ahead of time, but when you can't then we propose the following:
        - The enumerator selects their name, the village, and the farmer’s name/household ID they want to survey.
        - For every submitted survey, we track the enumerator’s name so that if the survey is not completed, a note will appear the next time the survey is opened to remind whomever is opening the survey who the previous enumerator to complete the survey was.  
