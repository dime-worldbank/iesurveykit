# Uploading Survey Forms and Preloads on surveycto

Detailed below are instructions to upload an XLSForm and preload dataset to SurveyCTO and how to utlize the publishing features.
1.  Upload main form into SurveyCTO using [these instructions](https://support.surveycto.com/hc/en-us/articles/360050736773-Deploying-form-definitions-and-server-datasets)
2.  Upload preloaded data into SurveyCTO as a server dataset and attaching to the survey form:
  -   Uploading preloaded data into SurveyCTO as a server dataset:
    -   Under the SurveyCTO console’s Design tab, click “Add server dataset” -> “New dataset for data”.
      -   Select the preloaded data from your computer or Google Drive depending on the file location.
      -   More information can be found [here](https://support.surveycto.com/hc/en-us/articles/360050736773-Deploying-form-definitions-and-server-datasets).
    - Attaching the server dataset to survey form:
      - Under the SurveyCTO console’s Design tab, click the “Attach” icon on the selected server dataset and then check the survey form you want to attach
      - This step allows users to reference variables in the preloaded dataset.      
3. Publishing form submissions back to the server dataset:     
    1. Under the SurveyCTO console’s Design tab, click the “Publish into” icon on the selected server dataset
    2. Click “Add a form” and then select the survey form that the preloaded data is attached to
    3. Under “Field Mapping”, the following fields should be added
      - A variable/field that identifies the unique records. In the example below, “hhid” is the unique id in both the preloaded dataset and survey form.
      - Any dynamic variables created in form design. In the case below, these are attempt counter, completion status and survey outcome. As these variables are updated after every submission, they are published back to replace the original variables in the preloaded dataset.
    4. Under “Form field to identify unique records (optional)”, select the same variable in step two-02-d-i
    5. More information can be found [here](https://docs.surveycto.com/05-exporting-and-publishing-data/04-advanced-publishing-with-datasets/02.forms-to-datasets.html)
