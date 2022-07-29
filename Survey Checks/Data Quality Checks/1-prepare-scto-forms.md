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
  | Complete | Non-responded | Red | Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |
  | Incomplete (Call Back) | Pending | Yellow | Respondent did not answer the call or was busy and wanted to reschedule   (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) |
  | a. Respondent did not answer the call or was busy and wanted to reschedule. b. Respondent agreed to participate but did not complete all modules (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) }|

### Prepare pre-loaded dataset

#### Without modules tracker
The preloaded data should include at least the following items:
(see Preload Sample (without Module Completion))

  1. basic survey information such as the household/respondent id and assigned enumerator name.  Household/respondent ID should be unique
  2. an attempt counter column with pre-assigned values of 0 (0 submissions). This variable describes the number of previous submissions for each survey
  3. a completion status column with pre-assigned values of 0 (Incomplete). This variable will be changed to 1 once the survey is completed by the enumerator
  4. a survey outcome column with pre-assigned values of 2 (Pending).  Once the completion status becomes 1, this variable will be changed to 1 if the survey is filled out by the respondent or to 0 if the survey is NOT filled out by the respondent
