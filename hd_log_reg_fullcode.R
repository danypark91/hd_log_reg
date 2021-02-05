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

#

