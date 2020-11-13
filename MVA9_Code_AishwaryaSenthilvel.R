library(MASS)
attach(Bank)
dim(Bank)
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
#The mean, standard error, and "worst" or largest (mean of the three largest values) of these features were computed for each image, resulting in 30 features. For instance, field 3 is Mean Radius, field 13 is Radius SE, field 23 is Worst Radius.
#we need to convert to matrix to facilitate distance measurement
#we need to convert to matrix to facilitate distance measurement
#What this does is it simply removes ID as a variable and defines our data as a matrix instead of a dataframe while still retaining the ID but in the column-names instead.
# Lets cut the data into two parts
smp_size_raw <- floor(0.75 * nrow(bank))
train_ind_raw <- sample(nrow(bank), size = smp_size_raw)
train_raw.df <- as.data.frame(bank[train_ind_raw, ])
test_raw.df <- as.data.frame(bank[-train_ind_raw, ])
# We now have a training and a test set. Training is 75% and test is 25%
Bank_raw.lda <- lda(formula = train_raw.df$y ~ ., data = train_raw.df)
Bank_raw.lda
summary(Bank_raw.lda)
print(Bank_raw.lda)

##Solving Figure Margins too large error
par("mar")
par(mar=c(1,1,1,1))

plot(Bank_raw.lda)
Bank_raw.lda.predict <- predict(Bank_raw.lda, newdata = test_raw.df)
Bank_raw.lda.predict$class
View(Bank_raw.lda.predict)
Bank_raw.lda.predict$x
Bank_raw.lda.predict <- predict(Bank_raw.lda, newdata = test_raw.df)


# Get the posteriors as a dataframe.
Bank_raw.lda.predict.posteriors <- as.data.frame(Bank_raw.lda.predict$posterior)
Bank_raw.lda.predict.posteriors

#create ROC/AUC curve
library(ROCR)
pred <- prediction(Bank_raw.lda.predict.posteriors[,2], test_raw.df$y)
roc.perf = performance(pred, measure = "tpr", x.measure = "fpr")
auc.train <- performance(pred, measure = "auc")
auc.train <- auc.train@y.values
plot(roc.perf)
abline(a=0, b= 1)
text(x = .25, y = .65 ,paste("AUC = ", round(auc.train[[1]],3), sep = ""))

##PART 2##
# the discriminative analysis
bank_lda = lda(formula = y~., data= bank)
print(bank_lda)
plot(bank_lda)
bank_lda$counts# the number of observartions in each group
bank_lda$means # groups' means
bank_lda$scaling
bank_lda$prior
bank_lda$lev # names of groups
bank_lda$svd # the ratio of between- and within-group standard deviations. 
#(prop = bank_lda$svd^2/sum(bank_lda$svd^2))
bank_lda_2 = lda(formula = y~., data= bank,CV= T)
summary(bank_lda_2$posterior)

# manual cross validation with half of the dataset as the training subset
train = sample (1:nrow(bank),0.5*nrow(bank))
bank_lda_3 = lda(formula = y~., data= bank, prior = c(1,1)/2, subset = train)
plda = predict(object = bank_lda_3, newdata = bank[-train, ])
summary(plda$posterior)

# prior probabilities
bank_lda_4 = lda(formula = y~., data= bank, prior = c(1,1)/2)
#prop.lda = bank_lda_4$svd^2/sum(bank_lda_4$svd^2)
plda_2 <- predict(object = bank_lda_4, newdata = bank)
summary(plda_2$posterior)
dataset = data.frame(y = bank[,"y"],lda = plda_2$x)
# choose three quarters as the training set
library(dplyr)
set.seed(101) 
sample_n(bank,10)
training_sample <- sample(c(TRUE, FALSE), nrow(bank), replace = T, prob = c(0.75,0.25))
train <- bank[training_sample, ]
test <- bank[!training_sample, ]
# the density and histogram plots
lda.bank <- lda(y ~ ., train)
plot(lda.bank, col = as.integer(train$y))
plot(lda.bank, dimen = 1, type = "b")

# partition plots for numeric variables
library(klaR)
partimat(as.factor(y)~ duration + pdays,data=train, method="lda")
# in-sample accuracy
lda.train <- predict(lda.bank)
train$lda <- lda.train$class
table(train$lda,train$y)
# out-of-sample accuracy
lda.test <- predict(lda.bank,test)
test$lda <- lda.test$class
table(test$lda,test$y)
# Wilk's Lambda and F test for each variable
m <- manova(cbind(bank$`Bank$age`,bank$`Bank$balance`,duration,pdays)~y,data=bank)
summary(m,test="Wilks")
summary(m,test="Pillai")
summary.aov(m)
