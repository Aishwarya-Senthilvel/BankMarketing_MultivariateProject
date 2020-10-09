library(readxl)
#bank<-read_xlsx("C:\\Users\\19739\\Desktop\\2nd SEM FALL 2020\\MVA\\Bank Marketing Project.xlsx")
bank<-read_xlsx('C:\\Users\\50672\\Desktop\\hw4\\bank.xlsx')
bank_2<-read_xlsx('C:\\Users\\50672\\Desktop\\hw4\\bank.xlsx')
dim(bank)
attach(bank)
head(bank)
#Get the Correlations between the measurements
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
# construct the new dataset with dummy variables
bank_new = cbind(bank$age, job,marital,education,default, bank$balance, housing,loan,contact, bank$day, month, bank[,12:15],poutcome)
bank = bank_new
h = cor(bank)
# Using prcomp to compute the principal components (eigenvalues and eigenvectors). With scale=TRUE, variable means are set to zero, and variances set to one
bank_pca <- prcomp(bank,scale=TRUE)
bank_pca
summary(bank_pca)
# sample scores stored in bank_pca$x
# singular values (square roots of eigenvalues) stored in bank_pca$sdev
# loadings (eigenvectors) are stored in bank_pca$rotation
# variable means stored in bank_pca$center
# variable standard deviations stored in bank_pca$scale
# A table containing eigenvalues and %'s accounted, follows
# Eigenvalues are sdev^2
(eigen_bank <- bank_pca$sdev^2)
names(eigen_bank) <- paste("PC",1:42,sep="")
eigen_bank
sumlambdas <- sum(eigen_bank)
sumlambdas
propvar <- eigen_bank/sumlambdas
propvar
cumvar_bank <- cumsum(propvar)
cumvar_bank
matlambdas <- rbind(eigen_bank,propvar,cumvar_bank)
rownames(matlambdas) <- c("Eigenvalues","Prop. variance","Cum. prop. variance")
round(matlambdas,4)
summary(bank_pca)
del = bank_pca$rotation
print(bank_pca)
# Sample scores stored in bank_pca$x
score = bank_pca$x
# Identifying the scores by their term deposit subscription
bank_pca <- cbind(data.frame(bank_2$y),bank_pca$x)
bank_pca
# Means of scores for all the PC's classified by term deposit status
tabmeansPC <- aggregate(bank_pca[,2:43],by=list(y=bank_2$y),mean)
tabmeansPC
tabmeansPC <- tabmeansPC[rev(order(tabmeansPC$y)),]
tabmeansPC
tabfmeans <- t(tabmeansPC[,-1])
tabfmeans
colnames(tabfmeans) <- t(as.vector(tabmeansPC[1]))
tabfmeans
# Standard deviations of scores for all the PC's classified by buying status
tabsdsPC <- aggregate(bank_pca[,2:43],by=list(y=bank_2$y),sd)
tabfsds <- t(tabsdsPC[,-1])
colnames(tabfsds) <- t(as.vector(tabsdsPC[1]))
tabfsds
t.test(PC1~bank_2$y,data=bank_pca)
t.test(PC2~bank_2$y,data=bank_pca)
t.test(PC3~bank_2$y,data=bank_pca)

#Ftests
job<- model.matrix(~job, data = bank)[,-1]
marital = model.matrix(~marital, data = bank)[,-1]
education = model.matrix(~education, data = bank)[,-1]
default = model.matrix(~default, data = bank)[,-1]
housing = model.matrix(~housing, data = bank)[,-1]
loan = model.matrix(~loan, data = bank)[,-1]
contact = model.matrix(~contact, data = bank)[,-1]
month = model.matrix(~month, data = bank)[,-1]
poutcome = model.matrix(~poutcome, data = bank)[,-1]
# construct the new dataset with dummy variables
bank_new = cbind(bank$age, job,marital,education,default, bank$balance, housing,loan,contact, bank$day, month, bank[,12:15],poutcome)
bank_pca = prcomp(bank_new,scale=TRUE) # apply the PCA 
summary(bank_pca)
bank_2 <- cbind(data.frame(bank$y),bank_pca$x)# add up the dependent to scores

# F test. For simplicity, we only include the first three PCs with largest variances
var.test(PC1~bank$y,data=bank_2)
var.test(PC2~bank$y,data=bank_2)
var.test(PC3~bank$y,data=bank_2)

#Levene's test (one-sided)
library(car)
(LTPC1 <- leveneTest(PC1~bank$y,data=bank_2))
(p_PC1_1sided <- LTPC1[[3]][1]/2)
(LTPC1 <- leveneTest(PC2~bank$y,data=bank_2))
(p_PC1_1sided <- LTPC1[[3]][1]/2)
(LTPC1 <- leveneTest(PC3~bank$y,data=bank_2))
(p_PC1_1sided <- LTPC1[[3]][1]/2)

# get the original values from PCA
center <- bank_pca$center
scale <- bank_pca$scale
d1= data.frame(drop(scale(bank_new,center=center, scale=scale)%*%bank_pca$rotation[,1]))#this replicates the PC1
d2= data.frame(drop(scale(bank_new,center=center, scale=scale)%*%bank_pca$rotation[,2]))
d3= data.frame(drop(scale(bank_new,center=center, scale=scale)%*%bank_pca$rotation[,3]))
c= predict(bank_pca)[,1]
summary (c)
c= predict(bank_pca)[,2]
summary (c)
c= predict(bank_pca)[,3]
summary (c)

