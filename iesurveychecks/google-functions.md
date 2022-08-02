# Instructions on Google Sheet functions

The graphs and tables in the HFC template are created mainly using the following functions:  
1. [PivotTable](https://support.google.com/docs/answer/1272900?co=GENIE.Platform%3DDesktop&hl=en): PivotTable functions are used to create aggregate tables.
  * Select the raw SurveyCTO-exported data and in the menu at the top, click Data > Pivot Table.
  * In the side panel, Rows are your level of aggregation (e.g. use enumerator IDs as Rows if it is enumerator-level tracking), and Values are the calculations you want to show in your columns.
  * In our template we create three types of pivot tables
    - Continuous variables: one that shows mean/median/min/max (by enumerator)
    - Continuous variables: one that shows means over time (by enumerator)
    - Categorical variables: one that shows response frequency by category
    - Categorical variables: one that shows response frequency for one answer in the category option set (e.g. don’t know or other) over time.  This can also be used for questions where “yes” triggers a host of additional questions and you want to check the frequency that enumerators select the “yes” option over time.
2. [Reference Data from Other Sheets](https://support.google.com/docs/answer/75943?co=GENIE.Platform%3DDesktop&hl=en): The Tracking tab is created by referencing data from the sheet with the raw exported data. Since the table under this tab is not at an aggregated level, we cannot use PivotTable functions.
  * For every cell, type “= followed by the sheet name, an exclamation point, and the cell being copied”. For example, a cell with argument “=Sheet1!A1” is copying data from the A1 cell in Sheet1.
3. [Conditional Formatting](https://www.benlcollins.com/spreadsheets/conditional-formatting-entire-row/): Under the Tracking tab, we use conditional formatting to highlight incomplete/pending surveys.  
  * In the menu at the top, click Format > Conditional Formatting.
  * In the side panel, under “Apply to range”, select all cells (excluding headers) and under “Format rules” select “Custom formula is" and type “= $G3 = FALSE”. The $ before the G ensures that the format for each column will always look to column G of the current row. This allows you to highlight all cells in the selected range if the corresponding value in the Completion Status column is FALSE.
