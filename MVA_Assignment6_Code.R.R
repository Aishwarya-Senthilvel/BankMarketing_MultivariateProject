# Factor Analysis
bank = read.csv("Bank.csv")

View(Bank)
attach(Bank)
Bank[1]
# Using dummy variables to replace categorical variables and drop intercepts
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

# Computing Correlation Matrix
corrm.bank <- cor(Bank_new)
corrm.bank
plot(corrm.bank)
Bank_pca <- prcomp(Bank_new[-1], scale=TRUE)
summary(Bank_pca)
plot(euroemp_pca)
# A table containing eigenvalues and %'s accounted, follows. Eigenvalues are the sdev^2
(eigen_bank <- round(Bank_pca$sdev^2,2))
names(eigen_bank) <- paste("PC",1:9,sep="")
eigen_bank
sumlambdas <- sum(eigen_bank)
sumlambdas
propvar <- round(eigen_bank/sumlambdas,2)
propvar
cumvar_bank <- cumsum(propvar)
cumvar_bank
matlambdas <- rbind(eigen_bank,propvar,cumvar_bank)
matlambdas
rownames(matlambdas) <- c("Eigenvalues","Prop. variance","Cum. prop. variance")
rownames(matlambdas)
eigvec.bank <- Bank_pca$rotation
print(Bank_pca)
# Taking the first four PCs to generate linear combinations for all the variables with four factors
pcafactors.bank <- eigvec.bank[,1:4]
pcafactors.bank
# Multiplying each column of the eigenvector's matrix by the square-root of the corresponding eigenvalue in order to get the factor loadings
unrot.fact.bank <- sweep(pcafactors.bank,MARGIN=2,Bank_pca$sdev[1:4],`*`)
unrot.fact.bank


library(readxl)
bank = read_excel("C:\\Academics\\Fall 2020 courses\\multivariate analysis\\homework\\hw5\\bank.xlsx", col_names = TRUE)
attach(bank)
# transform all categorical variables to dummy variables
job<- model.matrix(~job, data = bank)[,-1]
marital = model.matrix(~marital, data = bank)[,-1]
education = model.matrix(~education, data = bank)[,-1]
default = model.matrix(~default, data = bank)[,-1]
housing = model.matrix(~housing, data = bank)[,-1]
loan = model.matrix(~loan, data = bank)[,-1]
contact = model.matrix(~contact, data = bank)[,-1]
month = model.matrix(~month, data = bank)[,-1]
poutcome = model.matrix(~poutcome, data = bank)[,-1]
bank_new = cbind(bank$age, job,marital,education,default, bank$balance, housing,loan,contact, bank$day, month, bank[,12:15],poutcome)
# PCA outcome
bank_pca <- prcomp(bank_new, scale=TRUE)
eigen.bank = bank_pca$rotation # the contribution matrix
unrot.fact.bank <- sweep(eigen.bank[,1:4],MARGIN=2,bank_pca$sdev[1:4],`*`)# Multiplying each column of the eigenvector's matrix by the square-root of the corresponding eigenvalue in order to get the factor loadings
# Computing communalities
communalities.bank <- data.frame(rowSums(unrot.fact.bank^2))
#Performing the varimax rotation to get loadings, an alternative approach
rot.fact.bank <- varimax(unrot.fact.bank)
fact.load.bank <- rot.fact.bank$loadings[1:42,1:4]
# Computing the rotated factor scores
scale.bank <- scale(bank_new)
score = as.matrix(scale.bank)%*%fact.load.bank%*%solve(t(fact.load.bank)%*%fact.load.bank)

library(psych)
fit.pc <- principal(bank_new, nfactors=4, rotate="varimax") # this function gives the matrix of detecting cross loadings.
eigen_fit = round(fit.pc$values, 3) # eigenvalues of the PCA above with 3 digits
loading_fit = fit.pc$loadings #standard loading matrix

for (i in 1:4) { print(fit.pc$loadings[[1,i]])} # this gives you loadings with more digits.
common = fit.pc$communality
score_fit = fit.pc$scores
# Play with FA utilities
fa.parallel(bank_new) # See factor recommendation
fa.plot(fit.pc) # See Correlations within Factors
fa.diagram(fit.pc) # Visualize the relationship
vss(bank_new) # See Factor recommendations for a simple structure

detach(bank)
result = cbind (unrot.fact.bank, communalities.bank, fact.load.bank)
score_tab = cbind(score, score_fit)

