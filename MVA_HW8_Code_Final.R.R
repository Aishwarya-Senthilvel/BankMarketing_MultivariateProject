library(ggplot2)
library(cowplot)
library(readxl)
Bank = read_xlsx('C:\\Academics\\Fall 2020 courses\\multivariate analysis\\homework\\hw5\\bank.xlsx',col_names = TRUE)
# replace categorical variables by dummies.
job<- model.matrix(~job, data = Bank)[,-1]
marital = model.matrix(~marital, data = Bank)[,-1]
education = model.matrix(~education, data = Bank)[,-1]
default = model.matrix(~default, data = Bank)[,-1]
housing = model.matrix(~housing, data = Bank)[,-1]
loan = model.matrix(~loan, data = Bank)[,-1]
contact = model.matrix(~contact, data = Bank)[,-1]
month = model.matrix(~month, data = Bank)[,-1]
poutcome = model.matrix(~poutcome, data = Bank)[,-1]
Bank_new = cbind(Bank$age, job,marital,education,default, Bank$balance, housing,loan,contact, Bank$day, month, Bank[,12:15],poutcome)
y = model.matrix(~y, data = Bank)[,-1]
bank = cbind (Bank_new, y)

##Checkng for missing values in significant columns##
nrow(Bank[is.na(Bank$poutcome) | is.na(Bank$y),])
nrow(Bank)
##There are no missing values in the significant columns##

#first, run the logistic regression
 fit1= glm (y~., data = bank, family = 'binomial')
 summary (fit1)
 #step-wise selection
 a = step (fit1, direction = "both" , k = log(nrow(bank)))
 # check for separation
 xtabs(~y+monthjan,data=bank)
 xtabs(~y+contactunknown,data=bank)
 xtabs(~y+monthjul,data=bank)
 xtabs(~y+monthmar,data=bank)
 xtabs(~y+monthmay,data=bank)
 xtabs(~y+monthoct,data=bank)
 xtabs(~y+monthnov,data=bank)
 xtabs(~y+maritalmarried,data=bank)
 xtabs(~y+jobretired,data=bank)
 xtabs(~y+loan,data=bank)
 xtabs(~y+poutcomesuccess,data=bank)
 # compute the pseudo r-square
 ll.null= a$null.deviance/-2
 ll.proposed = a$deviance/-2
 (pseudor2 = (ll.null - ll.proposed) / ll.null)
 # p values of overall fitting tests
 1 - pchisq(2*(ll.proposed - ll.null), df=(length(a$coefficients)-1)) 
 1 - pchisq((a$null.deviance - a$deviance), df=(length(a$coefficients)-1))
 #prediction of probabilities
 predicted.data <- data.frame(probability.of.y=a$fitted.values,y=bank$y)
 predicted.data <- predicted.data[order(predicted.data$probability.of.y, decreasing=FALSE),]
 predicted.data$rank <- 1:nrow(predicted.data)
 # get the confusion matrix
 library (regclass)
 confusion_matrix(a)
 # making plots
 ggplot(data=predicted.data, aes(x=rank, y=probability.of.y)) +
   geom_point(aes(color=y), alpha=1, shape=4, stroke=2) +
   xlab("Index") +
   ylab("Predicted probability of buying term deposits")
# making Precision Recall curves
 library (pROC)
  roc(bank$y,a$fitted.values,plot=TRUE, print.auc = TRUE,percent = TRUE)
  # add another curve on the existing plot
  plot.roc(bank$y,fit1$fitted.values, print.auc = TRUE,percent = TRUE, add= TRUE,print.auc.y= 40)
 # another way to get the confusion matrix
  library(caret)
  pdata <- predict(a,newdata=bank,type="response" )
  library(e1071)
  pdataF <- as.factor(ifelse(test=as.numeric(pdata>0.5) == 0, yes="not bought", no="bought"))
  y = as.factor(ifelse(bank$y==0,yes = "not bought" , no = "bought"))
  confusionMatrix(pdataF, y)
 
 