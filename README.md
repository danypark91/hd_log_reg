# Logistic Regression using Heart Disease Dataset
This project is to apply logistic regression to the dataset of heart disease patients and create the regression model to predict the potential patients using Rstudio.

## Tech/framework used
- RStudio
- Rmarkdown
- Excel

### RStudio Library Used
- library(MASS)
- library(caret)
- library(Amelia)
- library(caTools)
- library(pROC)
- library(ROCR)
- library(plyr)
- library(GGally)
- library(ggsci)

### Installation of R packages
`rpack <- c("MASS", "caret", "Amelia", "caTools", "pROC", "ROCR", "plyr", "GGally", "ggsci")`

`install.packages(rpack)`

## Dataset
The original [dataset](https://archive.ics.uci.edu/ml/datasets/Heart+Disease) from UCI contained 76 attributes which represent a patient's condition. The dataset for this article is from [Kaggle - Heart Disease UCI](https://www.kaggle.com/ronitf/heart-disease-uci). The subset of 14 attributes with every incident represents a patient. 

## Project Description
This project is to apply logistic regression to the dataset. It begins with the importation of the dataset from the local device and checks if it requires data cleansing. The cleansed data divides into train and test sets with a ratio of 3 to 1. The best-fit logistic regression model gets derived by using `train_df`. The model undergoes statistical tests to determine scientific accuracy. Finally, the model is applied to the `test_df` to check the predictability of the logistic model. 

## Reference
- [Advanced Statistical Analysis & Design II](https://pages.mtu.edu/~shanem/psy5220/daily/Day9/Logistic_Regression.html) 
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2017). An introduction to statistical learning with applications in R. New York, N.Y: Springer.
