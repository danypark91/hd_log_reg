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

#check the ratio of reponse variable and see if it requires to rebalance
library(plyr)
count(df,vars="target")

#Data Visualization
library(GGally)
library(ggsci)

#1. Count of Target variable
ggplot(df, aes(factor(target), fill=factor(target)))+
  geom_bar(stat="count", width=0.5, color="black")+
  ggtitle("Count of Target")+xlab("Target")+ylab("Count")+labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()

#2. Barplot of Gender broken down by Target
ggplot(df, aes(sex, fill=factor(target)))+
  geom_bar(stat="count", width=0.5, color="black", position=position_dodge())+
  ggtitle("Gender of Patient, Broken by Target")+xlab("Gender")+ylab("Count")+labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()

#3. Barplot for categorical variables broken down by Target
cat_var <- c("sex", "cp", "fbs", "restecg", "exang", "slope", "thal", "target")
cat_df <- df[cat_var]

for(i in 1:7){
  print(ggplot(cat_df, aes(x=cat_df[,i], fill=factor(target)))+
    geom_bar(stat="count", width=0.5, color="black", position=position_dodge())+
    ggtitle(paste(colnames(cat_df)[i], ": Broken by Target"))+
    xlab(colnames(cat_df)[i])+ylab("Count")+labs(fill="Target")+
    theme_bw()+
    scale_fill_npg())
}

#4. Age distribution by Target
mp <- ggplot(df, aes(sex, age, fill=factor(target)))+
  geom_boxplot(width=0.5)+
  ggtitle("Distribution of Age, by Gender", subtitle="")+xlab("Gender")+ylab("Age")+labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()
#4-1. subplots
xplot <- ggplot(df, aes(sex, fill=factor(target)))+
  geom_bar(stat="count", width=0.5, alpha=0.4,color="black", position=position_dodge())+
  labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()
yplot <- ggplot(df, aes(age, fill=factor(target)))+
  geom_density(alpha=0.4)+
  labs(fill="Target")+
  theme_bw()+
  scale_fill_npg()+
  rotate()
#4-2. combination
library(ggpubr)
ggarrange(xplot, NULL, mp, yplot,
          ncol =2, nrow=2, align = "hv",
          widths= c(3,1), heights = c(1,2),
          common.legend= TRUE)

#5. Boxplot for continuous variables broken down by Target
cont_var <- c("age", "trestbps", "chol", "thalach", "oldpeak", "target")
cont_df <- df[cont_var]

for(i in 1:5){
  print(ggplot(cont_df, aes(x=cont_df[,i], y=factor(target), fill=factor(target)))+
          geom_boxplot(width=0.5)+
          geom_point(position=position_dodge(width=0.5), alpha=0.2)+
          ggtitle(paste(colnames(cont_df)[i], ": Broken by Target"))+
          xlab(colnames(cont_df)[i])+ylab("Target")+labs(fill="Target")+
          theme_minimal()+
          scale_fill_npg())
}

#Train,Test Split
library(caTools)
set.seed(123)
sample <- sample.split(df, SplitRatio = 0.75) #Randomly set identifier
train_df <- subset(df, sample==TRUE) #Train dataset
test_df  <- subset(df, sample==FALSE) #Test dataset

#Logistic Regression: full fitting with train dataset
df_model <- glm(target~., data=train_df, family=binomial(link="logit"))
df_mdoel$coefficients
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
plot(df_performance, col = "Red", 
     main = "ROC Curve",
     xlab="False Postiive Rate", ylab="True Positive Rate")+
  abline(a=0,b=1, col= "Grey")

df_auc <- performance(df_prediction, measure = "auc")
df_auc <- df_auc@y.values
print(paste("AUC Score: ", lapply(df_auc,round,3)))