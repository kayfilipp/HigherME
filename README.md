# HigherME
A repository for the University of San Diego's HigherME Capstone project. This project seeks to provide insight on the mismatch between the supply and demand of nontraditional STEM hires and how companies can be better equipped to identify diverse talent that traditional recruiting cycles tend to overlook.

## Timeline and Separation of Tasks
![image](https://user-images.githubusercontent.com/36943200/180358017-0204958f-052b-4af7-9738-b608d04ef7b1.png)


## Table of Contents 
1. [Business Understanding and Definitions](#definitions-and-business-understanding) 
2. [Census Data Analysis](#census-data-analysis)
3. [Streamlit Deployment](#streamlit-deployment)

### Definitions and Business Understanding
<ol>
  <li><b>Under-represented talent:</b> from a racial lens, this study examines individuals who are both non-white and non-asian such as Latino and Black applicants.</li>
  <li><b>Nontraditional Career Path:</b> a nontraditional career path in STEM involves engagement with one of the following criteria:
    <ul>
      <li>Certificate Programs</li>
      <li>Coding Bootcamps</li>
      <li>Coding Schools</li>
      <li>No College Experience</li>
      <li>Previous College/Professional Experience in a non-relevant field (ie English literature, Sociology)</li>
    </ul>
  </li>
  <li><b>Traditional Career Path:</b> A graduate of an accredited college with a STEM degree that found job placement in 1-2 years from graduation.</li>
</ol>

### Census Data Analysis

#### <b>Purpose:</b> Gain a better understanding of how memmbership in under-represented racial groups drives employment chances in STEM.
#### Assets: This portion of the capstone project utilizes the **census_data** directory only.

Pipeline Diagram:
![census_pipeline](https://user-images.githubusercontent.com/36943200/184600275-f25ebb0b-b561-4a8b-a204-7940058bbdad.jpg)

Explanation:
1. Census data is read into the census_eda.ipynb notebook. In this document, business logic is applied to identify which fields and occupations are considered STEM based on subject matter expertise from HigherME as well as ONet occupation data. The **stemType** target variable and the **under_represented** feature is created, which identifies if someone belongs to an under-represented racial group. Other features, such as an individual's specific STME Degree area, are added as well. The transformed data is written to the **main_df.csv** file.

2. The Modeling.ipynb notebook iterates over, and tunes, four models - naive bayes, logReg, RF, and NN. Parameter tuning focuses on improving roc-auc in particular. Of these models, the best one (Random Forest) is selected and exported to a pickl. A copy of the data is also moved to a streamlit folder that will be accessed by the web app during runtime. This only happens when streamlit does not have a local copy of the data.

**Model Performance and Findings:**
Overall, we observe that an optimized Random Forest model with an roc-auc of 91% is the best candidate for deployment to streamlit.<br><br>

![image](https://user-images.githubusercontent.com/36943200/184602328-fcf845cb-98af-42b4-95c0-39f915da3a29.png)


### Streamlit Deployment
To see the repo for our streamLit data, click <a href="https://github.com/kayfilipp/HigherMeStreamlitDemo">here</a>.
To see the demo itself, click <a href="https://kayfilipp-highermestreamlitdemo-main-ji7d4t.streamlitapp.com/">here</a>.
<br><br>
Our streamlit demo provides an MVP Which enables an end user to test our our Random Forest model by providing hypothetical demographic information about an individual to find out what their probability of working in a STEM field is. We currently consider age, sex, birthplace, racial status, highest educational attainment, and STEM Degree concentration (when relevant). The UX has been streamlined so that the end user needs to only fill out the questions being asked and hit "Make Prediction" to get insight on the likelihood of the submitted demographic finding employment in STEM.

![image](https://user-images.githubusercontent.com/36943200/184604695-271027d9-4ee9-4bba-8f8b-21f4f8a72e9d.png)



