


#Loading data file
library(readxl)
bank <- read_xlsx("C:\\Users\\50672\\Desktop\\bank.xlsx")

#Installing packages for plotting
#install.packages("ggplot2")
library(ggplot2)

#Assigning better column names
names(bank)[5]<- "Default_Credit"
#names(bank)[16]<- "Previous_Campaign_Outcome"
names(bank)[17]<- "Subscription_To_Deposit"
bank

#Identifying outliers in number of days passed since customer was contacted from last cmapaign
#ggplot2(bank, aes(x=bank$campaign, y=bank$Previous_Campaign_Outcome))+geom_point() 
ggplot(bank, aes(x=campaign, y=poutcome))+geom_point() 
    
#Identifying null values
summary(bank)
complete.cases(bank)

#Creates subset of bank data where loan column is missing
bank_1 <- subset(bank, is.na(bank$loan)) # this works. But there is no missing value in the column.
 

#Ensuring numerica data has numeric data type
op<-capture.output(str(bank$age))
op<-capture.output(str(bank$day))
op<-capture.output(str(bank$duration))
op<-capture.output(str(bank$campaign))

#Getting Frequency distribution of balance amounts of customer accounts
hist(bank$balance)

#EXPLORATORY DATA ANALYSIS

#stats : For exploration functions
#dplyr : For data manipulation functions
#install.packages("stats")
library(stats)
#install.packages("dplyr")
library(dplyr)

#Data Summarization
summary(bank)

#Calculating Central Tendencies for Number ofcontacts performed 
# before this campaign and for this client
mean(bank$previous)
median(bank$previous)

#Measure of Variance
#Calculating Standard Deviation
sd(bank$previous)

#Generating Barplot on categorical column to analyse outcome of the previous
#marketing campaign
#table(bank)
#barplot(3,bank$poutcome)
ggplot(data = bank, aes(x = poutcome)) + geom_bar(stat = "count")



# Applying tests to a expanded dataset
library(readxl)
bank <- read_excel("C:\\Users\\50672\\Desktop\\hw3\\bank-additional_bank-additional-full.xlsx")

# t -test 
with(data=bank,t.test(age[y=="yes"],age[y=="no"],var.equal=TRUE))

# Hotelling T2 test
library(Hotelling)
t2testsparr <- hotelling.test(duration+ campaign+ pdays+ previous+ emp.var.rate + cons.price.idx+ euribor3m + nr.employed ~ y, data=bank)
cat("T2 statistic =",t2testsparr$stat[[1]],"\n")
print(t2testsparr)
View(t2testsparr)

#F test for variation
with(data=bank,var.test(duration[y=="yes"],duration[y=="no"]))

# Levene's test for means. We need to transfer the dependent variable into a numeric one.
x= cbind(bank[,11:14],bank[16:20])# get all numeric variables from the sheet
y_n = rep(0,nrow(x))
for (i in 1:nrow(x)){
  if (bank[i,21]=="yes") {
    y_n[i] = 1}
  else{
    y_n[i] = 0
  }
} 
x= cbind(x, y_n)
mat = scale(x)
matbuy = x[which(x$y_n== 1), ]
matno = x[which(x$y_n== 0), ]
medbuy = apply(matbuy,2,median)
medno= apply (matno,2,median)
absbuy <- abs(matbuy - matrix(rep(medbuy,nrow(matbuy)),nrow=nrow(matbuy), byrow=TRUE))
absno <- abs(matno - matrix(rep(medno,nrow(matno)),nrow=nrow(matno), byrow=TRUE))
absall <- rbind(absbuy,absno)
absall <- data.frame(y_n, absall)
t.test(absall$campaign[y_n == 1],absall$campaign[y_n == 0], alternative="less",var.equal = TRUE)

# Levene's test for homoskedasticity
library(car)
leveneTest(campaign~ y, data=bank)

# Van Valen's test
d.all <- data.frame(x$y_n,sqrt(rowSums(absall[,2:10]^2)))
d.all
colnames(d.all)[2] <- "dij"
d.all
head(d.all)
with(d.all, t.test(dij[y_n==1], dij[y_n==0],var.equal=TRUE, alternative="less"))
sprintf("d-values for buyers: Mean = %2.3f, Variance = %2.3f",mean(d.all$dij[y_n==1]),var(d.all$dij[y_n==1]))
sprintf("d-values for Non-buyers: Mean = %2.3f, Variance = %2.3f",mean(d.all$dij[y_n==0]),var(d.all$dij[y_n==0]))

# ANOVA test for comparing univariate means
anov_bank <- aov(campaign ~ y, data=bank)
summary (anov_bank)

#MANOVA test fpr comparing multivariate means
manov_bank <- manova(as.matrix(x[,1:9])~ y_n, data=x)
summary (manov_bank)

#BoxM test
skulls = cbind(x$y_n, x[,1:9])
library(biotools)
groups <- skulls[,1] # The grouping variable is located in the 1st column 
vars <- skulls[,-1]  # The y-variables are not located in the 1st column
# Producing the chi-square test of homogeneity of variance-covariance matrices
chitest.boxM <- boxM(vars, groups)





