##------------------------------------------------------------------------------------##
##                                     FULL CODE                                      ##
##------------------------------------------------------------------------------------##

#import dataframe: csv
df<-read.csv("heart.csv", header =TRUE)
summary(df)
head(df,5)

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

#check for any missing data
library(Amelia)
missmap(df, main = "Missing Data vs Observed")

##----------------------##
##  DATA VISUALIZATION  ##
##----------------------##

#Train,Test Split
library(caTools)
set.seed(1234)
sample <- sample.split(df, SplitRatio = 0.75) #Randomly set identifier
train_df <- subset(df, sample==TRUE) #Train dataset
test_df  <- subset(df, sample==FALSE) #Test dataset

#Logistic Regression: full fitting with train dataset
df_model <- glm(target~., data=train_df, family=binomial(link="logit"))
summary(df_model)

#create a model with the statistically siginifcant variables only
df_model.part <- glm(target~sex+cp+trestbps+thalach+oldpeak+ca, data=train_df, family=binomial(link="logit"))
summary(df_model.part)
print(df_model.part$aic - df_model$aic) #difference of AIC score

#validate that the reduced model is statistically siginifcant over the full model
anova(df_model.part, df_model, test="Chisq")

#ROC and AUC for the partial model
library(pROC)
par(pty="s")
roc(train_df$target, df_model.part$fitted.values, plot=TRUE, legacy.axes=TRUE,
    col="Red", print.auc = TRUE, print.auc.x=0.35,
    xlab="False Positive Rate",
    ylab="True Positive Rate")

#Fiiting the model to test dataset and Confusion Matrix of the fitted model
df_model_fit <- predict(df_model.part, newdata=test_df, type="response")
df_model_confmat <- ifelse(df_model_fit >0.5, 1, 0)

library(caret)
confusionMatrix(factor(df_model_confmat), factor(test_df$target), positive=as.character(1))

#ROC and AUC for the fitted model
library(ROCR)
df_prediction <- prediction(df_model_fit, test_df$target)
df_performance <- performance(df_prediction, measure = "tpr", x.measure="fpr")
plot(df_performance, col = "Red")+
  abline(a=0,b=1, col= "Grey")

df_auc <- performance(df_prediction, measure = "auc")
df_auc <- df_auc@y.values
df_auc