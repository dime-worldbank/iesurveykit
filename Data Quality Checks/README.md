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

 <img src="https://github.com/worldbank/dime-standards/blob/master/dime-research-standards/pillar-4-data-security/data-security-resources/img/vc_install_1.png" width="50%"><!--- Image is read from master branch or use full URL-->
