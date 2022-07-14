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
* A. Step One: Upload your main form into SurveyCTO
* B. Step Two: Upload preloaded data into SurveyCTO as a server dataset and attaching to the survey form:
	i. Uploading preloaded data into SurveyCTO as a server dataset: 
		a. Under the SurveyCTO console’s Design tab, click “Add server dataset” -> “New dataset for data”. 
		b. Select the preloaded data from your computer or Google Drive depending on the file location.
		* More information can be found here.


