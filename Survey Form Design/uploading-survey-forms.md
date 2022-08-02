# Uploading Survey Forms and Preloads on SurveyCTO

Detailed below are instructions to upload an XLSForm and preload dataset to SurveyCTO and how to utilize the publishing features.
1.  Upload main form into SurveyCTO using [these instructions](https://support.surveycto.com/hc/en-us/articles/360050736773-Deploying-form-definitions-and-server-datasets)
2.  Upload preloaded data into SurveyCTO as a server dataset and attach it to the survey form:
    * Under the SurveyCTO console’s Design tab, click “Add server dataset” -> “New dataset for data”.
    * Select the preloaded data from your computer or Google Drive depending on the file location.
    * More information can be found [here](https://support.surveycto.com/hc/en-us/articles/360050736773-Deploying-form-definitions-and-server-datasets).

  <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image5.png"><!--- Image is read from master branch or use full URL-->

3. Attaching the server dataset to survey form:
    * Under the SurveyCTO console’s Design tab, click the “Attach” icon on the selected server dataset and then check the survey form you want to attach
    *  This step allows users to reference variables in the preloaded dataset.      

     <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image1.png" ><!--- Image is read from master branch or use full URL-->

4. Publishing form submissions back to the server dataset:     
    *  Under the SurveyCTO console’s Design tab, click the “Publish into” icon on the selected server dataset
    *  Click “Add a form” and then select the survey form that the preloaded data is attached to
    *  Under “Field Mapping”, the following fields should be added.
        1. A variable/field that identifies the unique records. In the example below, “hhid” is the unique id in both the preloaded dataset and survey form.
        2. Any dynamic variables created in form design. In the case below, these are attempt counter, completion status and survey outcome. As these variables are updated after every submission, they are published back to replace the original variables in the preloaded dataset.
    *  Under “Form field to identify unique records (optional)”, select the same variable in step two-02-d-i
    *  More information can be found [here](https://docs.surveycto.com/05-exporting-and-publishing-data/04-advanced-publishing-with-datasets/02.forms-to-datasets.html)
      <img src="https://github.com/dime-worldbank/iesurveykit/blob/main/iesurveychecks/img/image9.png" ><!--- Image is read from master branch or use full URL-->


### Data Security and Encryption
Almost all the data we collect include information that can be used to identify who the respondent is.
To protect respondents’ privacy and data security, the instructions below must be followed carefully.
Eventually we will de-identify the data so it can be shared freely among the research team; before that,
all data should be encrypted during each step of the survey collection process.

<b> Encrypting form data on SurveyCTO </b> - When programming questionnaires in SurveyCTO, you need to create a public-private key pair for your survey and use the provided public key to encrypt your survey form. . Step by step process described in the [SurveyCTO encryption guidelines](https://github.com/worldbank/dime-standards/blob/master/dime-research-standards/pillar-4-data-security/data-security-resources/surveycto-encryption-guidelines.md).
