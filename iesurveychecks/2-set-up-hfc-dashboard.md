
# Setting up a Real-time data quality checks dashboard

Once you have adapted your SurveyCTO form and preload datasets as detailed in [Adapt SurveyCTO forms](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/1-adapt-scto-forms.md), as shown in the flowchart below, there are four main steps for creating a real-time HFC dashboard.
<img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image7.png"><!--- Image is read from master branch or use full URL-->

  1. First, we need to upload a static preloaded dataset into SurveyCTO as a server dataset.
  2. Then, we attach this server dataset to the main survey form so that we can reference preloaded data in our survey form.
  3. Next, by using the “Publish” command, we stream data from new submissions back into the server dataset and reuse it for the next submission. This feature allows us to turn a static preloaded dataset into a dynamic one. Therefore, we can track the completion status and survey outcomes from previous submissions.
  4. Similarly, data from new submissions can also be exported to an external Google Sheet, where we can set up the HFC dashboard by leveraging Google Sheet functions to create descriptive statistics tables and graphs. As survey submissions will be automatically published to the Google Sheet, the HFC dashboard is also updated automatically.

The HFC dashboard provides snapshot of a subset of the data including:

1. Enumerator Tracking tab: Completion / Responses
2. Enumerator Productivity tab (time):
3. A few data points (1 per module mapped out - especially focusing on questions that lead the survey to be longer as enumerators may be inclined to answer a certain way to shorten survey)

These outputs can be complemented with some analysis in statistical software (such as R) to deep dive into the data and provide more insights on the data quality. More details on the complementary analysis can be found [here](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/3-complementary-analysis-r.md).

## How to create the dashboard
1. Export form submissions to a Google Sheet to create a real-time HFC dashboard.
  1. Readying the Google Sheet: Create a Google Sheet that is the exact same as the preloaded data but without any identifiable information.
  2. Publishing form submissions to the Google Sheet:  
    - Under the SurveyCTO console’s Export tab, under “Advanced” settings, click the “Configure” icon on the selected survey form
    - Click on “Add connection” and select the Google Sheet created above
    - Under “Field Mapping”,
      - Add any additional variables you need for the HFC dashboard, including but not limited to survey duration for evaluating enumerator performance, outcome variables for outlier checks, etc...
      <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image9.png"><!--- Image is read from master branch or use full URL-->

## Elements to include in HFC Dashboard

Leveraging functions in Google Sheet to create HFC dashboard: After setting up the Google Sheet connection in SurveyCTO, your data will be automatically streamed into the connected Google Sheet after every submission. The final step is to build up the HFC dashboard inside the Google Sheet by using Pivot Tables and other functions.

REMEMBER - Convert all columns in Google Sheets into text format before exporting any data.

  1. <b>Tracking Sheet</b>: This sheet is designed for the field team to track the progress of each survey. It is created by first referencing relevant information from the exported sheet and then using conditional formatting to highlight “incomplete” surveys (definitions of “complete” vs “incomplete” surveys are detailed in section I-A). This sheet should be similar to the raw, exported data but with finer formatting.

  2. <b>Aggregated Tracking (Enumerator-level)</b>: This sheet provides data monitoring at the enumerator-level. Specifically, it tracks:
    - Number of surveys completed
    - Average response rate
    - Average survey duration and number of attempts to contact

  3. <b>Aggregated Tracking (Village-level)</b>: This sheet provides data monitoring at the village-level. Similar to the enumerator-level tracking, it calculates:
    - Number of surveys completed
    - Average response rate

  4. <b>Data Quality (by Enumerator, full data)</b>: The purpose of this sheet is to give a preview of the outcome variables and check for abnormal patterns, illogical values and outliers. For each module, we create
    - Summary statistics tables that describe the distributions of outcome variables
    - (optional) Percentage of times that an answer is changed (by using conditional formatting, we highlight values that surpass a certain threshold - in the template it is 10%)

  5. <b>Data Quality (by Enumerator, recent data only)</b>:  Considering that during later stages of data collection, recent trends might be neglected and unnoticeable due to the large volume of existing data, therefore, it is important to create a separate data quality sheet just for data submitted over the past 7 days. This also allows us to capture if enumerators have rectified any early mistakes that we catch. The most easiest way to do this is
    - Duplicate the Data Quality Full Data sheet
    - Add a filter argument to each PivotTable you’ve created and under “filter by condition”, select “Date is within past week”
      - Note: you need to first export the “SubmissionDate” variable to your Google Sheet dashboard and then convert it to datetime format
      <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image6.png"><!--- Image is read from master branch or use full URL-->

  6. <b>Data Quality (by Enumerator or by a particular date)</b>:  For the same reasons as mentioned above, it is necessary to have the option to filter for specific enumerators or specific dates. The easiest way to do this is
      - Duplicate the Data Quality Full Data sheet twice (one for filtering for enumerator, one for date). Remove any tables which are not relevant for these tabs like those tabulating responses by date and by enumerator in a single table.
      - Go to “Data” in the Google Sheets Toolbar and select “Add a slicer”.
      - Then select the sheet that your pivot tables are pulling data from (in our sample dashboard, this is the “trackdata” sheet) and select the entire dataset.  
      - Select the variable you want to filter by. In our sample dashboard, we use enumerator name to filter under (`Enum_Wise`) and date in (`Date_Wise`). Ensure that the box is checked to apply this slicer to all pivot tables on that sheet.
      <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image4.png"><!--- Image is read from master branch or use full URL-->

      - `Enum_Wise` demonstrates how to view performance of one or more enumerators over time. Similarly, `Date_Wise` allows us to view performance on a particular day or selected dates by all enumerators. This is relevant if there are some dates which are crucial to monitor, or if a single or group of enumerators’ performance needs to be observed. The filters can be updated even without access to edit the dashboard.

Details on how to use the Google sheets functions used in the real time HFC dashboard can be found [here](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/google-functions.md).


## Ease of reading the checks

The template real time data quality checks dashboard uses conditional formatting to highlight different types of Completion and Survey Outcomes.

- <b> Completion Status (complete vs incomplete) </b>: This variable describes the result of the survey from the perspective of the enumerators. “Complete” surveys are surveys requiring NO FURTHER action from the enumerators regardless of whether the survey is filled out by the respondent or not. Specifically, in the survey process flowchart, “complete” surveys refer to the end node boxes highlighted in green and red, while “incomplete” surveys are the box highlighted in yellow.
- <b> Survey Outcomes (pending vs responded vs non-responded) </b>: This variable describes the result of survey from the research perspective. It further divides “complete” surveys into “responded” surveys and “non-response” surveys.  Specifically,
  - “Pending” surveys are incomplete surveys (yellow box)
  - “Responded” surveys are “complete” surveys filled out by the respondents (green box)
  - “Non-responded” surveys are “complete” surveys but NOT filled out by the respondents (red box). This could happen if the respondent is unavailable, refuses to participate or keeps rescheduling.


| Completion Status | Survey Outcome  | Color of End Node Box |Explanation |
| ------------- | ------------- | ------------ | ------------ |
| Complete | Responded | Green | Respondent agreed to participate and completed the survey |
| Complete | Non-responded | Red | Respondent refused to participate or was unable to conduct the survey due to illness, death, wrong number |
| Incomplete (Call Back) | Pending | Yellow | Respondent did not answer the call or was busy and wanted to reschedule   (NOTE: if enumerators have called 3 times but the respondent never answered the call or kept rescheduling, the survey status will then become “Completed, Non-responded”) |




## Relevant Links
### SurveyCTO Forms and preload datasets
1. [Survey XLSForm Template](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/scto/Survey%20Form%20Template%20(without%20module%20completion).xlsx)
2. [Preload dataset](https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/scto/Preloaded%20Data%20Sample.xlsx)
3. [Deployed SurveyCTO form to test and fill](https://boruis.surveycto.com/collect/demo_survey?caseid=)

### Dashboard Template  
1. [HFC Dashboard Template (Viewer-mode)](https://docs.google.com/spreadsheets/d/16S2GlDgdeSuzAJEeML8ieDOjKYK7QzfHlrkJE6AwdC4/edit?usp=sharing)
2. [HFC Dashboard Template (Editor-mode)](https://docs.google.com/spreadsheets/d/1iji2n0nSpS6tE4vOp9EwTb_TdvT-KC2J7wIMqw_q22M/edit?usp=sharing)  
