# Survey Completion

A Module completion tracker is useful for very long surveys which are broken down in parts. You can create your survey forms such that module completion is tracked along with the HFCs.

### How to add survey completion checks
Prepare the high frequency checks survey form as detailed in [Prepare Survey Forms]() and supplement with the following instructions.

#### With module completion status

In addition to the variables listed in (Preparing Survey Forms](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/1-prepare-scto-forms.md), the original preloaded data should also include the following item:
[(see Preload Sample (with Module Completion) - Part A)](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)

  5. last module completion status column with pre-assigned values of 0 (0 module completed):  This variable describes the last module completed by the respondent. Assuming your survey has 5 modules in total and the 5 modules are organized in a sequential order, in the cases where the respondent left in the middle of the survey, this variable will be changed from 0 to X (X is the number of modules completed by the respondent before leaving). Next time when the enumerator opens the same survey, it will start from the (X + 1)th module instead of the first module.

You will also need to prepare another preload data sheet (extra!) with 2 columns:
[(see Preload Sample (with Module Completion)- Part B)](https://github.com/dime-worldbank/iesurveykit/blob/initial-update/Survey%20Checks/scto/Preloaded%20Data%20Sample%20(With%20Module%20Completion).xlsx)

  1. module name: the name of each module
  2. module index: the corresponding index of each module (e.g. index = 1 if it is the first module appeared in the survey, index = 2 if it is the second module appeared in the survey)


### The benefits/drawbacks of module completion

1. <b> Advantages </b> - In long surveys or surveys dealing with sensitive topics it may be difficult to get respondents to stay for the whole duration in one sitting so this allows submission of partial surveys and can be picked up on a later date / time, even by another enumerator.
2. <b> Disadvantages </b>  - It can be time consuming to code up and the code is prone to errors. Next, when you start up an incomplete survey, it will start after the last module not question so if halfway through module X the respondent drops off, the next time the survey will begin at module X’s first question, so you lose data.
  - Cleaning is also difficult: you have to collapse different submissions for the same survey into 1 and it becomes hard to track
  - The issues related to duplicates that we detail in the limitation section below are further exacerbated.

Module trackers are great for long surveys but come with a set of challenges, so if your survey is short we advice considering the pros and cons of adding module completion trackers to the surveys.


### How it works (if you’re interested)

When you submit module A, and then you go back to do the survey again and submit module B - in principle we would think that SurveyCTO would overwrite module A and show an incomplete survey but it seems to be keeping the data from module A in the first submission.

- Explanation: In SurveyCTO, an empty field can take on two potential statuses. It can be an implicit null value or an explicit null value. Implicit null values are fields INACCESSIBLE to the enumerators during the survey because they do not meet the relevance condition(s). Explicit null values are fields accessible to the enumerators but with an empty value.
- When SurveyCTO exports data to the Google Sheet, explicit null values are exported to the Google Sheet and will REPLACE all existing values in the matched columns. However, implicit null values will NOT be exported and therefore, the existing values in the Google Sheet will NOT be replaced/updated.  
- Example (1): In the form template, we asked the enumerators to enter the next call date (field label: `next_call_datetime`) if the respondent is unavailable right now. If the enumerator is able to complete the survey with the respondent, this question will not be shown to the enumerator. Therefore, this field (`next_call_datetime`) will have an implicit null value under such circumstances. However, in the form template, there is a calculate field that formats results from the `next_call_datetime` field. Since it is a “calculate” field, though hidden, it is always updated with every submission. Therefore, this field will have an explicit null value even if the enumerator is never asked to enter a next call date.
  - This means that if the survey is submitted a second time (and completed that second time) the enumerator will not have to fill this out, and the `next_call_datetime` field will remain empty. However, because it is an explicit null value due to the presence of calculate field that formats the result, this data will overwrite any previously stored `next_call_datetime` from an incomplete survey submitted earlier.
- Example (2): Say an enumerator completes Module A on the first attempt, and then when he calls back he is brought to Module B (because module A was already completed). Then in this second survey, all the values from Module A are implicit null (never prompted to fill these out because it was already completed); and values from Module B are filled in. When google sheets exports the data Module A will not be ‘overwritten’ because they are implicit nulls.
