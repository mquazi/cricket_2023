Individual plots
library(stringr)

rm(list=ls())

setwd("/Users/jcliff/Documents/StatsAnalyses/Cricket_Sim/cricket_2020/individual_plots")

beta<-seq(0.01,5000,0.01)
############# function ###########
f<-function(xave,yhs){
        
        alpha<-xave/(beta)
        gg<-pgamma(yhs, alpha, scale=beta)
        gg<-trunc(gg*10^2)/10^2
        beta<-beta[which(gg==0.95 | gg==0.96 | gg==0.97 | gg==0.98 | gg==0.99)[1]]
        alpha<-xave/beta
        kk<-rgamma(1,alpha,scale=beta)
        list(kk)
}
############# function ###########

inddat<-read.csv("abd.csv",header=T)
head(inddat)
str(inddat)
inddat<-inddat[,1:2]
i1<-inddat[1:8,]
i1
i2<-inddat[9:16,]
i2

NA2mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
i1<-replace(i1, TRUE, lapply(i1, NA2mean))
i2<-replace(i2, TRUE, lapply(i2, NA2mean))

i2
i1

i1<-i1[-7,]
i2<-i2[-7,]
head(i1)
head(i2)

m<-7   #number of teams
n<-1    ##always 1

ie<-rbind(i1[1:m,],i2[1:m,])
ie


g2<-ie
g2<-as.data.frame(t(ie[,-1]))
g2<-ie
g2<-as.data.frame(t(ie[,-1]))
g2



hs<-g2[,1:m]
ave<-g2[,(m+1):(m+m)]
hs
ave
l2<-NULL
for (i in 1:nrow(hs)){
        r1<-hs[i,]
        r2<-ave[i,]
        l1<-ifelse((r1<r2) | (r1==r2), max(r1,r2+15), r1)
        l2[i]<-list(l1)
}
l3<-data.frame(matrix(unlist(l2), nrow=nrow(hs), byrow=T))
l3

l4<-NULL
l5<-NULL
n<-1
autoind<-function(){
        for (j in 1:m){
                
                a<-l3[1,j]
                b<-ave[1,j]
                score<-f(b,a)
                l4[j]<-(score)
        }
        l5<-list(l4)
        
        score<-data.frame(matrix(unlist(l5), nrow=nrow(hs), byrow=T))
        scores<-ceiling(score)
        list(scores=scores)
}

autoind()
indsims<-replicate(10000,autoind())

ia<-data.frame(matrix(unlist(indsims), nrow=length(indsims), byrow=T))
ia
colnames(ia)<-c("v csk","v dc","v kxip",   "v kkr",
                "v mi","v rr",
                "v srh")
head(ia)
write.csv(ia,'villiers.csv')
plot(density(ia[,1]))
max(ia[,])
