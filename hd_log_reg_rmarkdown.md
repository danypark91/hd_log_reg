Heart Disease UCI - Logistic Regression
================
Dany Park
11/02/2021

# Logistic Regression and Prediction of Heart Disease

The project is to apply logistic regression to the heart disease
datatset and apply the fitted model to predict the potential patient.

## 1. Overview of Logistic Regression

Consider a dataset with the response variable(Y) falls into two
categories. Logistic regression is a statistical model that focuses on
the probability of each Y variable’s class given values of the
independent variables(X). Since the model is based on the probability,
at any given X value, the result has to fall between 0 and 1.
Mathematically speaking, 0 ≤ P(X) ≤ 1. The value of P(X) should always
produce the outputs within the range.

![Logistic
Regression](https://www.dotnetlovers.com/Images/LogisticRegressionFormula1020201890212AM.png)

The regression is fitted using the maximum likelihood method because of
its statistical properties. The method estimates the model’s
coefficients such that the predicted probability corresponds as closely
as possible to the individual’s observations. In other words, predicted
β0 and β1 are found such that plugging these estimates into p(X), yields
a number close to one for all individuals who defaulted, and a number
close to zero for all individuals who did not¹.

## 2. The Dataset

The original
[dataset](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) from
UCI contained 76 attributes which represent a patient’s condition. The
dataset for this article is from [Kaggle - Heart Disease
UCI](https://www.kaggle.com/ronitf/heart-disease-uci). The subset of 14
attributes with every incident represents a patient.

| Attribute |                     Description                     |
|:---------:|:---------------------------------------------------:|
|  target   |   Patients with heart disease, Response variable    |
|    age    |                   Age of patients                   |
|    sex    |                 Gender of patients                  |
|    cp     |             chest pain type (4 values)              |
| trestbps  |               resting blood pressure                |
|    sr     |             serum cholestoral in mg/dl              |
|    fbs    |         fasting blood sugar &gt; 120 mg/dl          |
|  restang  | resting electrocardiographic results (values 0,1,2) |
|    hr     |             maximum heart rate achieved             |
|   exang   |               exercise induced angina               |
|  oldpeak  | ST depression induced by exercise relative to rest  |
|   slope   |      the slope of the peak exercise ST segment      |
|    fbs    | number of major vessels (0-3) colored by flourosopy |
|   thal    | 3 = normal; 6 = fixed defect; 7 = reversable defect |

The data is imported from the local device and printed summary of the
dataframe to get the overview.

``` r
#import dataframe: csv
df<-read.csv("heart.csv", header =TRUE)
summary(df)
```

    ##      ï..age           sex               cp           trestbps    
    ##  Min.   :29.00   Min.   :0.0000   Min.   :0.000   Min.   : 94.0  
    ##  1st Qu.:47.50   1st Qu.:0.0000   1st Qu.:0.000   1st Qu.:120.0  
    ##  Median :55.00   Median :1.0000   Median :1.000   Median :130.0  
    ##  Mean   :54.37   Mean   :0.6832   Mean   :0.967   Mean   :131.6  
    ##  3rd Qu.:61.00   3rd Qu.:1.0000   3rd Qu.:2.000   3rd Qu.:140.0  
    ##  Max.   :77.00   Max.   :1.0000   Max.   :3.000   Max.   :200.0  
    ##       chol            fbs            restecg          thalach     
    ##  Min.   :126.0   Min.   :0.0000   Min.   :0.0000   Min.   : 71.0  
    ##  1st Qu.:211.0   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:133.5  
    ##  Median :240.0   Median :0.0000   Median :1.0000   Median :153.0  
    ##  Mean   :246.3   Mean   :0.1485   Mean   :0.5281   Mean   :149.6  
    ##  3rd Qu.:274.5   3rd Qu.:0.0000   3rd Qu.:1.0000   3rd Qu.:166.0  
    ##  Max.   :564.0   Max.   :1.0000   Max.   :2.0000   Max.   :202.0  
    ##      exang           oldpeak         slope             ca        
    ##  Min.   :0.0000   Min.   :0.00   Min.   :0.000   Min.   :0.0000  
    ##  1st Qu.:0.0000   1st Qu.:0.00   1st Qu.:1.000   1st Qu.:0.0000  
    ##  Median :0.0000   Median :0.80   Median :1.000   Median :0.0000  
    ##  Mean   :0.3267   Mean   :1.04   Mean   :1.399   Mean   :0.7294  
    ##  3rd Qu.:1.0000   3rd Qu.:1.60   3rd Qu.:2.000   3rd Qu.:1.0000  
    ##  Max.   :1.0000   Max.   :6.20   Max.   :2.000   Max.   :4.0000  
    ##       thal           target      
    ##  Min.   :0.000   Min.   :0.0000  
    ##  1st Qu.:2.000   1st Qu.:0.0000  
    ##  Median :2.000   Median :1.0000  
    ##  Mean   :2.314   Mean   :0.5446  
    ##  3rd Qu.:3.000   3rd Qu.:1.0000  
    ##  Max.   :3.000   Max.   :1.0000

``` r
head(df,5)
```

    ##   ï..age sex cp trestbps chol fbs restecg thalach exang oldpeak slope ca thal
    ## 1     63   1  3      145  233   1       0     150     0     2.3     0  0    1
    ## 2     37   1  2      130  250   0       1     187     0     3.5     0  0    2
    ## 3     41   0  1      130  204   0       0     172     0     1.4     2  0    2
    ## 4     56   1  1      120  236   0       1     178     0     0.8     2  0    2
    ## 5     57   0  0      120  354   0       1     163     1     0.6     2  0    2
    ##   target
    ## 1      1
    ## 2      1
    ## 3      1
    ## 4      1
    ## 5      1

The dataset has total of 14 attributes and 303 incidences. Of those,
`sex`, `cp`, `fbs`, `restecg`, `exang`, `slope`, `thal` and `target` are
the characterized as categorical variable. The rest, `age`, `trestbps`,
`chol`, `thalach` and `oldpeak`, are the continuous variable. However,
before we proceed, there’s an erronous attribute: `ï..age`. It is
corrected to `age`.

``` r
#change erronous attribute name:  ï..age
colnames(df)[colnames(df)=='ï..age'] <-'age'
head(df,5)
```

    ##   age sex cp trestbps chol fbs restecg thalach exang oldpeak slope ca thal
    ## 1  63   1  3      145  233   1       0     150     0     2.3     0  0    1
    ## 2  37   1  2      130  250   0       1     187     0     3.5     0  0    2
    ## 3  41   0  1      130  204   0       0     172     0     1.4     2  0    2
    ## 4  56   1  1      120  236   0       1     178     0     0.8     2  0    2
    ## 5  57   0  0      120  354   0       1     163     1     0.6     2  0    2
    ##   target
    ## 1      1
    ## 2      1
    ## 3      1
    ## 4      1
    ## 5      1

Most of the time, the categorical variable in the dataframe requires to
be coverted to the factor type in Rstudio. Initially, all the variables
were categorized as integer. Before analyze the data, categorical
variables must be converted from int to factor. The code `as.factor` is
used to successfully convert. As shown below, the result between the
first `str` and the second run are different. In fact, the second `str`
overrided the type accordingly.

``` r
#check the type of each attribute and change to factor or int
str(df)
```

    ## 'data.frame':    303 obs. of  14 variables:
    ##  $ age     : int  63 37 41 56 57 57 56 44 52 57 ...
    ##  $ sex     : int  1 1 0 1 0 1 0 1 1 1 ...
    ##  $ cp      : int  3 2 1 1 0 0 1 1 2 2 ...
    ##  $ trestbps: int  145 130 130 120 120 140 140 120 172 150 ...
    ##  $ chol    : int  233 250 204 236 354 192 294 263 199 168 ...
    ##  $ fbs     : int  1 0 0 0 0 0 0 0 1 0 ...
    ##  $ restecg : int  0 1 0 1 1 1 0 1 1 1 ...
    ##  $ thalach : int  150 187 172 178 163 148 153 173 162 174 ...
    ##  $ exang   : int  0 0 0 0 1 0 0 0 0 0 ...
    ##  $ oldpeak : num  2.3 3.5 1.4 0.8 0.6 0.4 1.3 0 0.5 1.6 ...
    ##  $ slope   : int  0 0 2 2 2 1 1 2 2 2 ...
    ##  $ ca      : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ thal    : int  1 2 2 2 2 1 2 3 3 2 ...
    ##  $ target  : int  1 1 1 1 1 1 1 1 1 1 ...

``` r
df$sex <- as.factor(df$sex)
df$cp <- as.factor(df$cp)
df$fbs <- as.factor(df$fbs)
df$restecg <- as.factor(df$restecg)
df$exang <- as.factor(df$exang)
df$slope <- as.factor(df$slope)
df$thal <- as.factor(df$thal)

str(df) #re-run
```

    ## 'data.frame':    303 obs. of  14 variables:
    ##  $ age     : int  63 37 41 56 57 57 56 44 52 57 ...
    ##  $ sex     : Factor w/ 2 levels "0","1": 2 2 1 2 1 2 1 2 2 2 ...
    ##  $ cp      : Factor w/ 4 levels "0","1","2","3": 4 3 2 2 1 1 2 2 3 3 ...
    ##  $ trestbps: int  145 130 130 120 120 140 140 120 172 150 ...
    ##  $ chol    : int  233 250 204 236 354 192 294 263 199 168 ...
    ##  $ fbs     : Factor w/ 2 levels "0","1": 2 1 1 1 1 1 1 1 2 1 ...
    ##  $ restecg : Factor w/ 3 levels "0","1","2": 1 2 1 2 2 2 1 2 2 2 ...
    ##  $ thalach : int  150 187 172 178 163 148 153 173 162 174 ...
    ##  $ exang   : Factor w/ 2 levels "0","1": 1 1 1 1 2 1 1 1 1 1 ...
    ##  $ oldpeak : num  2.3 3.5 1.4 0.8 0.6 0.4 1.3 0 0.5 1.6 ...
    ##  $ slope   : Factor w/ 3 levels "0","1","2": 1 1 3 3 3 2 2 3 3 3 ...
    ##  $ ca      : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ thal    : Factor w/ 4 levels "0","1","2","3": 2 3 3 3 3 2 3 4 4 3 ...
    ##  $ target  : int  1 1 1 1 1 1 1 1 1 1 ...

One of the most important step in data analysis is dealing with the
missing data. Usually, the complete dataset doesn’t take place in the
industry level. The code `missmap` is the perfect tool to visualize the
missing data in each attribute. Luckily, the graph suggests that there
isn’t any missing data for this dataframe.

``` r
#check for any missing data
library(Amelia)
```

    ## Loading required package: Rcpp

    ## ## 
    ## ## Amelia II: Multiple Imputation
    ## ## (Version 1.7.6, built: 2019-11-24)
    ## ## Copyright (C) 2005-2021 James Honaker, Gary King and Matthew Blackwell
    ## ## Refer to http://gking.harvard.edu/amelia/ for more information
    ## ##

``` r
missmap(df, main = "Missing Data vs Observed")
```

![](hd_log_reg_rmarkdown_files/figure-gfm/Missmap-1.png)<!-- --> The
final step before analyze the data is checking the ratio of the
categories in the response variable. Resampling method can resolve the
high inbalance between the classification. However, below result
provides that the imbalance isn’t significant enough to apply
under/over-sampling algorithm.

``` r
#check the ratio of reponse variable and see if it requires to rebalance
library(plyr)
count(df,vars="target")
```

    ##   target freq
    ## 1      0  138
    ## 2      1  165

## 3. Data Visualization

``` r
#Data Visualization
library(GGally)
```

    ## Loading required package: ggplot2

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

``` r
library(ggsci)
```

``` r
#1. Count of Target variable
ggplot(df, aes(factor(target), fill=factor(target)))+
  geom_bar(stat="count", width=0.5, color="black")+
  ggtitle("Count of Target")+xlab("Target")+ylab("Count")+labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()
```

![](hd_log_reg_rmarkdown_files/figure-gfm/Frequency%20of%20Target-1.png)<!-- -->
