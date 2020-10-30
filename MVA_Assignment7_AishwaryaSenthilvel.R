#Multiple Regression
Bank = read.csv("Bank.csv")
view(Bank)
attach(Bank)
# use dummy variables to replace categorical variables and drop intercepts
job<- model.matrix(~job, data = bank)[,-1]
marital = model.matrix(~marital, data = bank)[,-1]
education = model.matrix(~education, data = bank)[,-1]
default = model.matrix(~default, data = bank)[,-1]
housing = model.matrix(~housing, data = bank)[,-1]
loan = model.matrix(~loan, data = bank)[,-1]
contact = model.matrix(~contact, data = bank)[,-1]
month = model.matrix(~month, data = bank)[,-1]
poutcome = model.matrix(~poutcome, data = bank)[,-1]
bank_new = cbind(Bank$age, job,marital,education,default, Bank$balance, housing,loan,contact, Bank$day, month, Bank[,12:15],poutcome)
#Transform y column into 0's & 1's
y = model.matrix(~y, data = Bank)[,-1]
attach(Bank)

Bank_new = cbind(Bank$age, job,marital,education,default, Bank$balance, housing,loan,contact, Bank$day, month, Bank[,12:15],poutcome)
y = model.matrix(~y, data = Bank)[,-1]
bank = cbind (Bank_new, y)

# perform logit regression
fit = glm(y~., data = bank, family = 'binomial')
summary (fit)
# Performing multiple regression on bank dataset
fit2 = lm(y~Bank$age + pdays,data = bank)
fit2

#Summary has three sections. 
#Section1: How well does the model fit the data (before Coefficients).
#Section2: Is the hypothesis supported? (until sifnif codes). 
#Section3: How well does data fit the model (again).
# Useful Helper Functions
coefficients(fit2)
library(GGally)
ggpairs(data=bank, title="Bank Data")
#library(FFally)
?confint
confint(fit2,level=0.95)
# Predicted Values
fitted(fit2)
residuals(fit2)
#Anova Table
anova(fit2)
vcov(fit2)
?vcov
cov2cor(vcov(fit2))
temp <- influence.measures(fit2)
temp
View(temp)
#diagnostic plots
plot(fit2)
library(car)
# Assessing Outliers
outlierTest(fit2)
qqPlot(fit2, main="QQ Plot")
cooks.distance(fit2)
leveragePlots(fit2) # leverage plots
# Influential Observations
# added variable plots
avPlots(fit2)
# Cook's D plot
# identify D values > 4/(n-k-1)
cutoff <- 4/((nrow(bank)-length(fit2$coefficients)-2))
plot(fit2, which=4, cook.levels=cutoff)
cutoff
# Influence Plot
influencePlot(fit2, id.method="identify", main="Influence Plot", sub="Circle size is proportial to Cook's Distance")
# Normality of Residuals
# qq plot for studentized resid
qqPlot(fit2, main="QQ Plot")
# distribution of studentized residuals
library(MASS)
sresid <- studres(fit2)
hist(sresid, freq=FALSE,
     main="Distribution of Studentized Residuals")
xfit<-seq(min(sresid),max(sresid),length=40)
yfit<-dnorm(xfit)
lines(xfit, yfit)
#Non-constant Error Variance
# Evaluate homoscedasticity
# non-constant error variance test
ncvTest(fit2)
# plot studentized residuals vs. fitted values
spreadLevelPlot(fit2)
#Multi-collinearity
# Evaluate Collinearity
vif(fit2) # variance inflation factors
sqrt(vif(fit2)) > 2 # problem?
#Nonlinearity
# component + residual plot
crPlots(fit2)
# Ceres plots
ceresPlots(fit2)
#Non-independence of Errors
# Test for Autocorrelated Errors
durbinWatsonTest(fit2)
#PART 2
library(gvlma)
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
# perform logit regression
fit = glm(y~., data = bank, family = 'binomial')
summary (fit)
# change the dependent and do it again
fit2 = lm(y~.,data = bank)
summary(fit2)
gvmodel <- gvlma(fit2)
summary(gvmodel)
a = anova(fit, fit2) 
summary(a)
step <- step(fit, direction="both") 
step$anova
library(leaps)
leaps<-regsubsets(y~.,data=bank,nbest=10)
summary(leaps)
plot(leaps,scale = "bic")
plot(leaps,scale = "r2")
library(car)
subsets(leaps, statistic="rsq")
coef(leaps,1:10)
library(relaimpo)
fit3 = lm(bank$y~ Bank$age+ Bank$balance+ Bank$day + Bank$campaign+ Bank$pdays + Bank$previous)
summary(fit3)
calc.relimp(fit3,type=c("lmg","last","first","pratt"),rela=TRUE)
boot <- boot.relimp(fit3, b = 1000, type = c("lmg","last", "first", "pratt"), rank = TRUE, diff = TRUE, rela = TRUE)
booteval.relimp(boot)
plot(booteval.relimp(boot,sort=TRUE))
summary(fit3)
k =predict.lm(fit3)
head(k)
