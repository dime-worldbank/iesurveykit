# Preparing Survey Forms

### Design Survey Forms
The first step is to create a SurveyCTO data-collection form. Instructions on how to create one can be found [here](https://docs.surveycto.com/02-designing-forms/01-core-concepts/). When designing your survey form, it is important to take into account all possible scenarios that an enumerator may encounter during the collection process. The form templates shared in this documentation, for example, provide a sample questionnaire for phone surveys with 3 possible outcomes. Before moving forward, we clarify two concepts used frequently across this document - completion status and survey outcome.
  - <b> Completion Status (complete vs incomplete) </b>: This variable describes the result of the survey from the perspective of the enumerators. “Complete” surveys are surveys requiring NO FURTHER action from the enumerators regardless of whether the survey is filled out by the respondent or not. Specifically, in the survey process flowchart, “complete” surveys refer to the end node boxes highlighted in green and red, while “incomplete” surveys are the box highlighted in yellow.
  - <b> Survey Outcomes (pending vs responded vs non-responded) </b>: This variable describes the result of survey from the research perspective. It further divides “complete” surveys into “responded” surveys and “non-responsed” surveys.  Specifically,
    - “Pending” surveys are incomplete surveys (yellow box)
    - “Responded” surveys are “complete” surveys filled out by the respondents (green box)
    - “Non-responded” surveys are “complete” surveys but NOT filled out by the respondents (red box). This could happen if the respondent is unavailable, refuses to participate or keeps rescheduling.


  | Completion Status | Survey Outcome  | Color of End Node Box |Without Module Completion | With Module Completion|
  | ------------- | ------------- | ------------ | ------------ | ------------ |
  | Complete | Responded | Green | Respondent agreed to participate and completed the survey | Respondent agreed to participate and completed all modules |
  | Complete | Non-responded | Red | Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |
  | Incomplete (Call Back) | Pending | Yellow | Respondent did not answer the call or was busy and wanted to reschedule   (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) |
  | a. Respondent did not answer the call or was busy and wanted to reschedule. b. Respondent agreed to participate but did not complete all modules (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) }|

### Prepare pre-loaded dataset

1.  Without modules tracker
The preloaded data should include at least the following items:
(see Preload Sample (without Module Completion))

  1. basic survey information such as the household/respondent id and assigned enumerator name.  Household/respondent ID should be unique
  2. an attempt counter column with pre-assigned values of 0 (0 submissions). This variable describes the number of previous submissions for each survey
  3. a completion status column with pre-assigned values of 0 (Incomplete). This variable will be changed to 1 once the survey is completed by the enumerator
  4. a survey outcome column with pre-assigned values of 2 (Pending).  Once the completion status becomes 1, this variable will be changed to 1 if the survey is filled out by the respondent or to 0 if the survey is NOT filled out by the respondent


2. With module completion status
Please note that module tracker is useful for very long surveys but comes with a set of challenges, so if your survey is short please proceed with the template/explanation above.

In addition to the variables listed above, the original preloaded data should also include the following item:
(see Preload Sample (with Module Completion) - Part A)

  5. last module completion status column with pre-assigned values of 0 (0 module completed):  This variable describes the last module completed by the respondent. Assuming your survey has 5 modules in total and the 5 modules are organized in a sequential order, in the cases where the respondent left in the middle of the survey, this variable will be changed from 0 to X (X is the number of modules completed by the respondent before leaving). Next time when the enumerator opens the same survey, it will start from the (X + 1)th module instead of the first module.

You will also need to prepare another preload data sheet (extra!) with 2 columns:
(see Preload Sample (with Module Completion)- Part B)

  1. module name: the name of each module
  2. module index: the corresponding index of each module (e.g. index = 1 if it is the first module appeared in the survey, index = 2 if it is the second module appeared in the survey)


### The benefits/drawbacks of module completion
1. <b> Advantages </b> - In long surveys or surveys dealing with sensitive topics it may be difficult to get respondents to stay for the whole duration in one sitting so this allows submission of partial surveys and can be picked up on a later date / time, even by another enumerator.
2. <b> Disadvantages </b>  - It can be time consuming to code up and the code is prone to errors. Next, when you start up an incomplete survey, it will start after the last module not question so if halfway through module X the respondent drops off, the next time the survey will begin at module X’s first question, so you lose data.
  - Cleaning is also difficult: you have to collapse different submissions for the same survey into 1 and it becomes hard to track
  - The issues related to duplicates that we detail in the limitation section below are further exacerbated.






### How it works (if you’re interested)

When you submit module A, and then you go back to do the survey again and submit module B - in principle we would think that SurveyCTO would overwrite module A and show an incomplete survey but it seems to be keeping the data from module A in the first submission.

- Explanation: In surveyCTO, an empty field can take on two potential statuses. It can be an implicit null value or an explicit null value. Implicit null values are fields INACCESSIBLE to the enumerators during the survey because they do not meet the relevance condition(s). Explicit null values are fields accessible to the enumerators but with an empty value.
- When SurveyCTO exports data to the Google Sheet, explicit null values are exported to the Google Sheet and will REPLACE all existing values in the matched columns. However, implicit null values will NOT be exported and therefore, the existing values in the Google Sheet will NOT be replaced/updated.  
- Example (1): In the form template, we asked the enumerators to enter the next call date (field label: next_call_datetime) if the respondent is unavailable right now. If the enumerator is able to complete the survey with the respondent, this question will not be shown to the enumerator. Therefore, this field (next_call_datetime) will have an implicit null value under such circumstances. However, in the form template, there is a calculate field that formats results from the next_call_datetime field. Since it is a “calculate” field, though hidden, it is always updated with every submission. Therefore, this field will have an explicit null value even if the enumerator is never asked to enter a next call date.
  - This means that if the survey is submitted a second time (and completed that second time) the enumerator will not have to fill this out, and the next_call_datetime field will remain empty. However, because it is an explicit null value due to the presence of calculate field that formats the result, this data will overwrite any previously stored next_call_datetime from an incomplete survey submitted earlier.
- Example (2): Say an enumerator completes Module A on the first attempt, and then when he calls back he is brought to Module B (because module A was already completed). Then in this second survey, all the values from Module A are implicit null (never prompted to fill these out because it was already completed); and values from Module B are filled in. When google sheets exports the data Module A will not be ‘overwritten’ because they are implicit nulls.
