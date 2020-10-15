library(readxl)
library(cluster)
bank = read_excel("C:\\Academics\\Fall 2020 courses\\multivariate analysis\\homework\\hw5\\bank.xlsx", col_names = TRUE)
attach(bank)

#install.packages("cluster", lib="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")
#library(cluster)

# Calculating Euclidean distance matrix for bank data
distance_matrix_bank<-dist(bank[1:30,],method="euclidean")

#Reading distance matrix file
#dist.bank<-read.csv("C/Users/50672/Desktop/dist.csv",row.names=1)
#dist.bank<-read.csv("C:\\Users\\50672\\Desktop\\dist.csv",row.names=1,fill = TRUE, header = TRUE)
#view(dist.bank)

#Transforming Distance values into a matrix
library(reshape2)
df <- melt(as.matrix(distance_matrix_bank), varnames = c("row", "col"))
#write.csv(df, "C:\\Users\\50672\\Desktop\\1.csv")
#colnames(dist.bank) <- rownames(dist.bank)
dist.bank = distance_matrix_bank
#dist.bank <- as.dist(dist.bank)
#dist.bank

#Single
bank.nearest_neighbor <- hclust(dist.bank, method = "single")
#?plot
plot(bank.nearest_neighbor, hang=-1,xlab="Object",ylab="Distance",
     main="Dendrogram. Nearest neighbor linkage")
#?plot

#Default - Complete
bank.farthest_neighbor <- hclust(dist.bank)
plot(bank.farthest_neighbor,hang=-1,xlab="Object",ylab="Distance",
     main="Dendrogram. Farthest neighbor linkage")

#Group Average Linkage
bank.average_linkage <- hclust(dist.bank,method="average")
plot(bank.average_linkage,hang=-1,xlab="Object",ylab="Distance",
     main="Dendrogram. Group average linkage")

#Hierarchical clustering
bank_hc <- hclust(distance_matrix_bank, method = "ward.D2")
plot(bank_hc,hang = -1, xlab="Object",ylab="Distance",
     main="Dendrogram. Ward D2 linkage")

#Vertical Dendrogram
plot(as.dendrogram(bank.nearest_neighbor), labels = NULL, hang = 0.1, main = "Vertical dendrogram", sub = NULL,xlab = NULL, ylab = "Distance between term deposit values",)

#Plotting hclust
#plot(bank_hc)

#Horizontal Dendrogram
plot(as.dendrogram(bank.nearest_neighbor), labels = NULL, hang = 0.1, 
      sub = NULL,
     xlab = "Distance between term deposit values", ylab = NULL,horiz = TRUE,
     main="Horizontal Dendrogram")

#Triangle Plot
plot(as.dendrogram(bank.nearest_neighbor), type = "triangle", ylab = "Height")

#library(readxl)
#library(cluster)
#bank = read_excel("C:\\Academics\\Fall 2020 courses\\multivariate analysis\\homework\\hw5\\bank.xlsx", col_names = TRUE)
#attach(bank)
#bank_new = cbind(age, balance, day, duration, campaign, pdays, previous)
(agn.bank = agnes(bank, metric="euclidean", stand=TRUE, method = "complete")) #Each row is a client. This classifed these clients.
plot(agn.bank, ask = TRUE)
plot(as.dendrogram(agn.bank),horiz= TRUE)

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
bank_new = cbind(bank$age, job,marital,education,default, bank$balance, housing,loan,contact, bank$day, month, bank[,12:15],poutcome)
#scaling the new dataset
matstd.bank <- scale(bank_new)
# k-means clustering, exploring the threshold of the proportion
store = rep(0,99)
for (i in 2:101){
   (kmeans2.bank <- kmeans(matstd.bank,i,iter.max = 100, nstart = 100))
   perc.var <- round(100*(1 - kmeans2.bank$betweenss/kmeans2.bank$totss),1) #this measures the proportion of within variation for the total variation.
   #names(perc.var) <- "Perc clus"
   store[i-1]=perc.var
}
plot(store,type='l')
# I use the case of three clusters as an example.
(kmeans3.bank <- kmeans(matstd.bank,3,iter.max = 100, nstart = 100))
perc.var <- round(100*(1 - kmeans3.bank$betweenss/kmeans3.bank$totss),1) #this measures the proportion of within variation for the total variation.
clus1 <- matrix(names(kmeans3.bank$cluster[kmeans3.bank$cluster == 1]), 
                ncol=1, nrow=length(kmeans3.bank$cluster[kmeans3.bank$cluster == 1]))
colnames(clus1) <- "Cluster 1"
clus2 <- matrix(names(kmeans3.bank$cluster[kmeans3.bank$cluster == 2]), 
                ncol=1, nrow=length(kmeans3.bank$cluster[kmeans3.bank$cluster == 2]))
colnames(clus1) <- "Cluster 2"
clus3 <- matrix(names(kmeans3.bank$cluster[kmeans3.bank$cluster == 3]), 
                ncol=1, nrow=length(kmeans3.bank$cluster[kmeans3.bank$cluster == 3]))
colnames(clus1) <- "Cluster 3"
row = rep(0,3)
row[1] = nrow(clus1)
row[2] = nrow(clus2)
row[3] = nrow(clus3)
detach(bank)

#m<-matrix(round(runif(36,min=0,max=100)),nrow=6,ncol=6)
#m[!lower.tri(m)]<-0
