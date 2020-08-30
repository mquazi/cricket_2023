
#install.packages("tictoc")
library(tictoc)
#install.packages("stringr")
library(stringr)
#install.packages("sampling")
library(sampling)


############# function ###########
f<-function(xave,yhs){
        beta<-seq(0.01,5000,0.01)
        alpha<-xave/(beta)
        #gg<-qgamma(0.95, alpha, beta )
        #gg
        #alpha<-35/0.93
        #alpha
        gg<-pgamma(yhs, alpha, scale=beta)
        
        
        #str(mm)
        #which(mm[,2]==95)
        gg<-trunc(gg*10^2)/10^2
        #which(gg==0.95)[1]
        #max(gg)
        #gg[226:260]
        beta<-beta[which(gg==0.95 | gg==0.96 | gg==0.97 | gg==0.98 | gg==0.99)[1]]
        alpha<-xave/beta
        kk<-rgamma(1,alpha,scale=beta)
        list(kk)
}
############# function ###########




inddat<-read.csv("/users/dattap/cricket_2020/india/india.csv",header=T)
head(inddat)
str(inddat)
i1<-inddat[1:16,]
i1
i2<-inddat[17:32,]
i2

NA2mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
i1<-replace(i1[,3:ncol(i1)], TRUE, lapply(i1[,3:ncol(i1)], NA2mean))
i2<-replace(i2[,3:ncol(i2)], TRUE, lapply(i2[,3:ncol(i2)], NA2mean))
i2
i1

i1<-cbind(inddat[1:16,2],i1)
i2<-cbind(inddat[1:16,2],i2)
i1
i1<-i1[-6,]
i2<-i2[-6,]
head(i1)
head(i2)
m<-15   #number of teams
n<-11    ##always 11

ie<-rbind(i1[1:m,],i2[1:m,])
ie

g<-as.data.frame(t(ie[,-1]))
g$myfactor <- factor(row.names(g))

g$myfactor<-str_remove_all(g$myfactor, "[V0123456789]")
k<-as.numeric(factor(g$myfactor))
g<-cbind(g,k)
g$myfactor <- factor(g$myfactor)


g2<-g[order(g$myfactor),]
g2[g2 == 0] <- 1
g2


autoind<-function(){
select<-strata(g2,stratanames=c("myfactor"),size=c(1,1,4,2,1,2),method = "srswor")
#table(select$myfactor)
hs<-getdata(g2,select)[,1:m]
ave<-getdata(g2,select)[,(m+1):(m+m)]
#hs
#ave



l2<-NULL
for (i in 1:nrow(hs)){
        r1<-hs[i,]
        r2<-ave[i,]
        l1<-ifelse((r1<r2) | (r1==r2), max(r1,r2+15), r1)
        l2[i]<-list(l1)
}
#l2
l3<-data.frame(matrix(unlist(l2), nrow=nrow(hs), byrow=T))
#l3

l4<-NULL
l5<-NULL
for(i in 1:n){
        for (j in 1:m){
                        
                                a<-l3[i,j]
                                b<-ave[i,j]
                                score<-f(b,a)
                                l4[j]<-(score)
        }
        l5[i]<-list(l4)
}

score<-data.frame(matrix(unlist(l5), nrow=nrow(hs), byrow=T))
#score
#ave
#l6<-ifelse(is.na(score), ave, r1)
#is.na(score)
score<-ceiling(score)
scores<-colSums(score)
#scores
list(scores=scores)
}

autoind()
tic()
indsims<-replicate(5,autoind())
toc()
indsims[[1]][5]
ia<-data.frame(matrix(unlist(indsims), nrow=length(indsims), byrow=T))
ia
colnames(ia)<-c("v Afghanistan","v Australia","v Bangladesh",   "v England",
                "v Hong Kong","v Ireland","v Kenya","v Netherlands", "v New Zealand" ,
                "v Pakistan", "v South Africa", "v Sri Lanka", "v U.A.E.", 
                "v West Indies", "v Zimbabwe")
setwd("/users/dattap/cricket_2020/india/")
write.csv(ia,'ia.csv')

ia$`v England`
ia[,4]
ed[,7]
ia[,4]<ed[,7]


################################checking ################################

is(vv[,1]=cc[,1])
vv==cc
vv<cc
vv
vv
cc

max(hs[,1])

beta<-seq(0.01,5000,0.01)
alpha<-19/(beta)
alpha
gg<-pgamma(209, alpha, scale=beta)
gg
gg<-trunc(gg*10^2)/10^2
max(gg)
min(gg)
beta<-beta[which(gg==0.95 | gg==0.96 | gg==0.97 | gg==0.98 | gg==0.99)][[1]]
alpha<-19/beta
beta
alpha
kk<-rgamma(1000,alpha,scale=beta)
kk

class(as.vector(hs[,1]))

hs
ave
beta<-beta[which(gg==0.95)[1]]

hist(kk)
mean(kk)
min(kk)
max(kk)

x<-N(35,17)
gg[93]
beta[93]
#### You do not need this part ###########



