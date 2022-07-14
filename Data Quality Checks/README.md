# Data Quality Checks

### Introduction
This repository provides detailed instructions for creating a real-time high-frequency check dashboard.

As shown in the flowchart below, there are four main steps for creating a real-time HFC dashboard.
First, we need to upload a static preloaded dataset into SurveyCTO as a server dataset.
Then, we attach this server dataset to the main survey form so that we can reference preloaded data in our survey form.
Next, by using the “Publish” command, we stream data from new submissions back into the server dataset and reuse it for the next submission.
This feature allows us to turn a static preloaded dataset into a dynamic one. Therefore, we can track the completion status and survey outcomes from previous submissions.
Similarly, data from new submissions can also be exported to an external Google Sheet,
where we can set up the HFC dashboard by leveraging Google Sheet functions to create descriptive statistics tables and graphs.
As survey submissions will be automatically published to the Google Sheet, the HFC dashboard is also updated automatically.

<i> to add flowchart image & table </i>

### Data Security and Encryption
Almost all the data we collect include information that can be used to identify who the respondent is.
To protect respondents’ privacy and data security, the instructions below must be followed carefully.
Eventually we will de-identify the data so it can be shared freely among the research team; before that,
all data should be encrypted during each step of the survey collection process.

* Encrypting form data on SurveyCTO - When programming questionnaires in SurveyCTO, you need to create a public-private key pair for your survey and use the provided public key to encrypt your survey form. . Step by step process described in the [SurveyCTO encryption guidelines](https://github.com/worldbank/dime-standards/blob/master/dime-research-standards/pillar-4-data-security/data-security-resources/surveycto-encryption-guidelines.md).

* Encrypting identifiable data stored locally: When downloading survey data from SurveyCTO or preparing the preload datasets,
you need to create a safe storage place for the PII data.
A World Bank-approved software solution is VeraCrypt. Instructions on how to create secure encrypted folders on VeraCrypt can be found [here](https://github.com/worldbank/dime-standards/blob/master/dime-research-standards/pillar-4-data-security/data-security-resources/veracrypt-guidelines.md).
 <b> For the purpose of data security, it is essential that you never save unencrypted data with personally identifiable information on your computer, the cloud, or a hard disk. </b>

### Section 1 -  Preparing Survey Forms

### Section 2 -  Uploading Survey Forms
1.  Upload main form into SurveyCTO
2.  Upload preloaded data into SurveyCTO as a server dataset and attaching to the survey form:
  -   Uploading preloaded data into SurveyCTO as a server dataset:
    -   Under the SurveyCTO console’s Design tab, click “Add server dataset” -> “New dataset for data”.
      -   Select the preloaded data from your computer or Google Drive depending on the file location.
      -   More information can be found here.
    - Attaching the server dataset to survey form:
      - Under the SurveyCTO console’s Design tab, click the “Attach” icon on the selected server dataset and then check the survey form you want to attach
      - This step allows users to reference variables in the preloaded dataset.      
3. Further editing the SurveyCTO forms (with pre-load completed)         
  - Go back to the survey form (necessary): Edit your survey form to include the following fields
Since the survey form needs to actively pull data from this server dataset - your survey form needs to have calculate fields that will reference this server dataset.
NOTE: As the form is encrypted forms, all the following fields must be explicitly marked as “publishable” (with a “yes” in their publishable column). Fields explicitly marked as publishable are left unencrypted so that they can be conveniently published to cloud services or directly downloaded from the server.

    1. Generic: “Calculate” fields that pull variables from the preloaded data. There should be one “Calculate” field for each column in the preloaded data
      * Example:  pulldata('hhplotdata', 'plot1size', 'hhid_key', ${hhid}) will pull a value from an attached server dataset called hhplotdata (This is the dataset id you entered when you created the server datset). The value will come from the plot1size column of the pre-loaded data, and the hhid field will be used to identify the matching row in the pre-loaded data's hhid_key column
      * Recommended naming convention:  adding a “_pl” suffix to the original name

    2. For tracking: A “Calculate” field that updates the attempt counter variable every time the enumerator submits a survey.
    * xample: ${attempt_counter_pl} + 1, where attempt_counter_pl is the name of the pulled variable

    3. For tracking: Two “Calculate” fields that respectively update the completion status variable and the survey outcome variable every time the enumerator submits a survey
      * This can be created by setting the ifelse argument with/or coalesce argument. For specific examples, please see the surveycto form template.
      * Recommended naming convention: adding a “_update” suffix to distinguish from the pulled variables
    - Go back to the survey form (optional: module completion checks):
      1. Submission in the middle of a survey:
        - A yesno “select_one” field at the end of every module (except the last module) that asks “Is the respondent still available? (Please select “No” if you agreed to stop the survey here and start again a some other time)"
        - A “calculate” field (must be placed at the end of the survey) for every module you have in the survey. This variable tracks the completion status for each module.  It should be equal to 1 if a particular module is completed and otherwise 0.
        - A “calculate” field that adds up the last_module_completed variable pulled from the preload sheet and all the 0-1 module completion status calculate fields you created for each module.
        Add a relevance expression for every module group you have in your survey form so that only modules that are not completed in the previous submissions are visible to the respondents.
    - Go back to the survey form (optional: additional features)
      1. Duplicate submissions check:
        - This check refers to the orange “Check 1” box in the survey process flowchart.
        - After the enumerator selects a household id, the survey form will check the completion status for the selected household id from the preloaded server dataset. If the completion status is equal to 1 (“Complete”), a warning note will appear preventing the enumerator from moving forward.
        - This warning is created by adding a “Note” field with a relevance expression of “${complete_status_pl} = 1”  and “required action” option set to “Yes”.
      2. Maximum number of submissions (subject to change):
        - This check is designed to close a survey if the number of previous submissions has reached a certain threshold, which in the sample survey form is 5. In other words, if the enumerator has contacted the respondent 5 times and the respondent either never picked up the call or kept rescheduling, the enumerator DOES NOT have to contact the respondent again.
        - This check is created by pulling the attempt counter variable from the preloaded dataset. If attempt counter + 1 is equal to the threshold, completion status will be changed from “Incomplete” to “Complete”, and survey outcome will be changed from “Pending” to “Non-responded”.

       3. Next call date (subject to change):
        - This constraint refers to the 7.1 box in the survey process flowchart.
        - If no one answers the phone or the respondent reschedules with the enumerator, the enumerator needs to enter a next call date and time. The next call date must be within the next 2 days.
        - This constraint is created by adding a constraint expression of “( number(${next_call_datetime}) - number(now()) ) <= 2”.

       4. Check whether a response was changed:
         - By adding a “calculate here” field with the expression “once(${fieldname})” right after the question, we are able to capture the initial response entered to see if the enumerators/respondents fill in answers and then go back to change them.
         - As this expression only captures the initial responses, it is recommended to add one additional calculate field with the argument “if(once(${fieldname}) != ${fieldname}, 1, 0)” to create a dummy variable that returns 1 if the answer is changed.
         - For more information, see the form template or this link.

       5. Monitor Module Duration:
        - Create a “calculate here” field with the expressions “once(format-date-time(now(), '%Y-%b-%e %H:%M:%S'))” at the beginning and the end of a module to capture the start time and end time for the module.
        - This allows you to track how long an enumerator completes a module.

       6. Enumerator Check:
        - It's often better to assign enumerators to each survey ahead of time, but when you can't then we propose the following:
        - The enumerator selects their name, the village, and the farmer’s name/household ID they want to survey.
        - For every submitted survey, we track the enumerator’s name so that if the survey is not completed, a note will appear the next time the survey is opened to remind whomever is opening the survey who the previous enumerator to complete the survey was.  

4. Publishing form submissions back to the server dataset:     
  1. Under the SurveyCTO console’s Design tab, click the “Publish into” icon on the selected server dataset
  2. Click “Add a form” and then select the survey form that the preloaded data is attached to
  3. Under “Field Mapping”, the following fields should be added
    - A variable/field that identifies the unique records. In the example below, “hhid” is the unique id in both the preloaded dataset and survey form.
    - Any dynamic variables created in form design. In the case below, these are attempt counter, completion status and survey outcome. As these variables are updated after every submission, they are published back to replace the original variables in the preloaded dataset.
  4. Under “Form field to identify unique records (optional)”, select the same variable in step two-02-d-i
  5. More information can be found here


### Section 3 - Setting up a Real-time data quality checks dashboard
1. Export form submissions to a Google Sheet to create a real-time HFC dashboard.
  1. Readying the Google Sheet: Create a Google Sheet that is the exact same as the preloaded data but without any identifiable information.
  2. Publishing form submissions to the Google Sheet:  
    - Under the SurveyCTO console’s Export tab, under “Advanced” settings, click the “Configure” icon on the selected survey form
    - Click on “Add connection” and select the Google Sheet created above
    - Under “Field Mapping”,
      - Repeat steps in section II-C-iii-c
      - Add any additional variables you need for the HFC dashboard, including but not limited to survey duration for evaluating enumerator performance, outcome variables for outlier checks, etc...
2. Creating HFC tabs

Leveraging functions in Google Sheet to create HFC dashboard: After setting up the Google Sheet connection in SurveyCTO, your data will be automatically streamed into the connected Google Sheet after every submission. The final step is to build up the HFC dashboard inside the Google Sheet by using Pivot Tables and other functions. The shared template includes the following elements:

Convert all columns in google sheet into text format before exporting any data.
