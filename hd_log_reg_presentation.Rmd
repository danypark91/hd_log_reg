---
title: "Heart Disease UCI - Logistic Regression"
author: "Dany Park"
date: "11/02/2021"
output: html_document
---

## 1. Overview of Logistic Regression
Consider a dataset with the response variable(Y) falls into two categories. Logistic regression is a statistical model that focuses on the probability of each Y variable's class given values of the independent variables(X). Since the model is based on the probability, at any given X value, the result has to fall between 0 and 1. Mathematically speaking, 0 ≤ P(X) ≤ 1. The value of P(X) should always produce the outputs within the range. 

![Logistic Regression](https://www.dotnetlovers.com/Images/LogisticRegressionFormula1020201890212AM.png)

The regression is fitted using the maximum likelihood method because of its statistical properties. The method estimates the model's coefficients such that the predicted probability corresponds as closely as possible to the individual's observations. In other words, predicted β0 and β1 are found such that plugging these estimates into p(X), yields a number close to one for all individuals who defaulted, and a number close to zero for all individuals who did not¹.

## 2. The Dataset 
```{r Importation of Data, echo =TRUE}
#import dataframe: csv
df <- read.csv("Heart.csv", header = TRUE)
summary(df)
head(df,5)
```

The original [dataset](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) from UCI contained 76 attributes which represent a patient's condition. The dataset for this article is from [Kaggle - Heart Disease UCI](https://www.kaggle.com/ronitf/heart-disease-uci). The subset of 14 attributes with every incident represents a patient. 

| Attribute | Description |
| :---: | :---: |
| target | Patients with heart disease, Response variable |
| age | Age of patients |
| sex | Gender of patients |
| cp | chest pain type (4 values) |
| trestbps | resting blood pressure |
| sr | serum cholestoral in mg/dl |
| fbs | fasting blood sugar > 120 mg/dl |
| restang | resting electrocardiographic results (values 0,1,2) |
| hr | maximum heart rate achieved |
| exang | exercise induced angina |
| oldpeak | ST depression induced by exercise relative to rest |
| slope | the slope of the peak exercise ST segment |
| fbs | number of major vessels (0-3) colored by flourosopy |
| thal | 3 = normal; 6 = fixed defect; 7 = reversable defect |

```{r Dataset cleansing, echo=TRUE}
#change erronous attribute name:  ï..age
colnames(df)[colnames(df)=='ï..age'] <-'age'
head(df,5)

#check the type of each attribute and change to factor or int
str(df)

df$sex <- as.factor(df$sex)
df$cp <- as.factor(df$cp)
df$fbs <- as.factor(df$fbs)
df$restecg <- as.factor(df$restecg)
df$exang <- as.factor(df$exang)
df$slope <- as.factor(df$slope)
df$thal <- as.factor(df$thal)
```

