# Survey checks

Here we provide detailed instructions for preparing your electronic survey with the aim of adding survey checks and creating a real-time high-frequency check dashboard.

As shown in the flowchart below, there are four main steps for creating a real-time HFC dashboard.

1. First, we need to upload a static preloaded dataset into SurveyCTO as a server dataset.
2. Then, we attach this server dataset to the main survey form so that we can reference preloaded data in our survey form.
3. Next, by using the “Publish” command, we stream data from new submissions back into the server dataset and reuse it for the next submission. This feature allows us to turn a static preloaded dataset into a dynamic one. Therefore, we can track the completion status and survey outcomes from previous submissions. Similarly, data from new submissions can also be exported to an external Google Sheet,
where we can set up the HFC dashboard by leveraging Google Sheet functions to create descriptive statistics tables and graphs. As survey submissions will be automatically published to the Google Sheet, the HFC dashboard is also updated automatically.

The HFC dashboard provides snapshot of a subset of the data including:
1. Enumerator Tracking tab: Completion / Responses
2. Enumerator Productivity tab (time):
3. A few data points (1 per module mapped out - especially focusing on questions that lead the survey to be longer as enumerators may be inclined to answer a certain way to shorten survey)

These outputs can be complemented with some analysis in R to deep dive into the data and provide more insights on the data quality.

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


### Best practices
These surveys e designed to pull modules and survey completion dynamically from a server dataset which updates the number of attempts and completion status with each new survey filled. In the event that the server has not been updated or is unable to pull new data, we see duplicates. The upload and download of forms and datasets do not happen automatically on the SurveyCTO Collect appunless the device is connected to WiFi and surveys need to be sent to the server and datasets refreshed manually. Further, there is a brief delay when publishing new submissions into server dataset/Google Sheets from SurveyCTO. The published data will only update 5-10 minutes after the most recent submission has been received. Thus,
- Wait 5-10 minutes after each submission before starting the next one
- Compare the attempt counter note shown in the survey form with the one listed in the Google Sheet to ensure the preloaded data is up-to-date
- Notes for better data management:
  - When you’re on a mobile network, SurveyCTO doesn’t automatically upload the surveys to the server. It waits until you’re connected to WiFi or requires you to upload the surveys manually. This is why we see lags in survey submission. This can be changed within the application (under General Settings) to allow for automatic upload when any mobile network is available. However, if enumerators are working in areas with little to no internet coverage, this will remain an issue. Ultimate decision - depends on WiFi and/or mobile network availability
- Protocols for updating the server dataset
  - Enumerators should change SurveyCTO settings to auto upload surveys and auto download the new server dataset when connected to a MOBILE network
  - Whenever enumerators are in a network zone (whether mobile or WiFi), they should manually upload and download to ensure they are working with the most updated version. This is of utmost importance between attempts to the same household / respondent.
  - These processes must be followed as frequently as possible. While after each survey is ideal, field coordinators should remind them to do so as frequently as possible. If enumerators devices do not have internet, field managers should have a hotspot device



### Commonly faced issues

1. <b> Duplicates</b>  are created and go unnoticed in 1 of 2 ways
  1. Completed surveys: This occurs when an enumerator does not upload completed surveys to the server. Thus, the server dataset does not mark the survey as completed. The next time an enumerator attempts the same UID/HHID it will not alert you that this has already been filled, and thus leads to it being filled again.
  2. Incomplete surveys: This issue occurs when a surveyor makes an attempt wherein they are unable to start the survey or are only able to complete it partially, and are unable to send these surveys to the server. Thus, even if a second or greater attempt is made without the server dataset being updated, anyone else attempting the same HHID/UID will not see the latest number of attempts made. This also creates an issue in partially completed surveys. If a survey is partially completed till module X without the dataset being updated, the next attempt will start the survey at whichever point it was last updated instead of at module X+1.

2. <b> Imperfect number of attempts </b>: The survey captures the number of attempts incorrectly owing to poor network and bad practices. For example, you make one attempt which is uploaded to the server; and then you make further attempts (which would be attempt 2, 3, 4, 5) but do not upload them to the server immediately, but instead altogether later (i.e. they aren’t sequentially uploaded to the server because of internet connection or bad practices). Then once you do upload all, the tracker doesn’t register this as 4 separate attempts, it registers it as a second attempt only.

However, capturing the number of attempts is desirable. Submitting a survey for each attempt allows the most accurate tracking of both, enumerator effort and reachability of the sample. If in the same sample multiple surveys are being conducted, it is a strong indicator of the number of attempts after which the effort to conduct a round of calls is too high for the conversion of successful attempts.
