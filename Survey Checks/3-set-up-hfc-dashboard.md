
# Setting up a Real-time data quality checks dashboard

There are four main steps for creating a real-time HFC dashboard.

  1. First, we need to upload a static preloaded dataset into SurveyCTO as a server dataset.
  2. Then, we attach this server dataset to the main survey form so that we can reference preloaded data in our survey form.
  3.  Next, by using the “Publish” command, we stream data from new submissions back into the server dataset and reuse it for the next submission. This feature allows us to turn a static preloaded dataset into a dynamic one. Therefore, we can track the completion status and survey outcomes from previous submissions.
  4. Similarly, data from new submissions can also be exported to an external Google Sheet, where we can set up the HFC dashboard by leveraging Google Sheet functions to create descriptive statistics tables and graphs. As survey submissions will be automatically published to the Google Sheet, the HFC dashboard is also updated automatically.

The HFC dashboard provides snapshot of a subset of the data including:

1. Enumerator Tracking tab: Completion / Responses
2. Enumerator Productivity tab (time):
3. A few data points (1 per module mapped out - especially focusing on questions that lead the survey to be longer as enumerators may be inclined to answer a certain way to shorten survey)

These outputs can be complemented with some analysis in R to deep dive into the data and provide more insights on the data quality

### How to create the dashboard
1. Export form submissions to a Google Sheet to create a real-time HFC dashboard.
  1. Readying the Google Sheet: Create a Google Sheet that is the exact same as the preloaded data but without any identifiable information.
  2. Publishing form submissions to the Google Sheet:  
    - Under the SurveyCTO console’s Export tab, under “Advanced” settings, click the “Configure” icon on the selected survey form
    - Click on “Add connection” and select the Google Sheet created above
    - Under “Field Mapping”,
      - Repeat steps in section II-C-iii-c
      - Add any additional variables you need for the HFC dashboard, including but not limited to survey duration for evaluating enumerator performance, outcome variables for outlier checks, etc...
2. Create HFC tabs

Leveraging functions in Google Sheet to create HFC dashboard: After setting up the Google Sheet connection in SurveyCTO, your data will be automatically streamed into the connected Google Sheet after every submission. The final step is to build up the HFC dashboard inside the Google Sheet by using Pivot Tables and other functions. The shared template includes the following elements:

REMEMBER - Convert all columns in google sheet into text format before exporting any data.

  1. <b>Tracking Sheet</b>: This sheet is designed for FCs and enumerators to track the progress of each survey. It is created by first referencing relevant information from the exported sheet and then using conditional formatting to highlight “incomplete” surveys (definitions of “complete” vs “incomplete” surveys are detailed in section I-A). This sheet should be similar to the raw, exported data but with finer formatting.

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

  5. <b>Data Quality (by Enumerator, recent data only)<b>:  Considering that during later stages of data collection, recent trends might be neglected and unnoticeable due to the large volume of existing data, therefore, it is important to create a separate data quality sheet just for data submitted over the past 7 days. This also allows us to capture if enumerators have rectified any early mistakes that we catch. The most easiest way to do this is
    - Duplicate the Data Quality Full Data sheet
    - Add a filter argument to each PivotTable you’ve created and under “filter by condition”, select “Date is within past week”
      - Note: you need to first export the “SubmissionDate” variable to your Google Sheet dashboard and then convert it to datetime format

  6. <b>Data Quality (by Enumerator or by a particular date)</b>:  For the same reasons as mentioned above, it is necessary to have the option to filter for specific enumerators or specific dates. The easiest way to do this is
      - Duplicate the Data Quality Full Data sheet twice (one for filtering for enumerator, one for date). Remove any tables which are not relevant for these tabs like those tabulating responses by date and by enumerator in a single table.
      - Go to “Data” in the Google Sheets Toolbar and select “Add a slicer”.
      - Then select the sheet that your pivot tables are pulling data from (in our sample dashboard, this is the “trackdata” sheet) and select the entire dataset.  
      - Select the variable you want to filter by. In our sample dashboard, we use enumerator name to filter under (Enum_Wise) and date in (Date_Wise). Ensure that the box is checked to apply this slicer to all pivot tables on that sheet.
      - Enum_Wise demonstrates how to view performance of one or more enumerators over time. Similarly, Date_Wise allows us to view performance on a particular day or selected dates by all enumerators. This is relevant if there are some dates which are crucial to monitor, or if a single or group of enumerators’ performance needs to be observed. The filters can be updated even without access to edit the dashboard.

Details on how to use the Google sheets functions used in the real time HFC dashboard can be found [here]().
