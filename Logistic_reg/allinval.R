
setwd("/Users/quazi/Desktop/cric/simulationfiles")
an<-read.csv("anval.csv",header=T)[,-1]
aa<-read.csv("aaval.csv",header=T)[,-1]
bh<-read.csv("bhval.csv",header=T)[,-1]
ed<-read.csv("edval.csv",header=T)[,-1]
ia<-read.csv("iaval.csv",header=T)[,-1]
id<-read.csv("idval.csv",header=T)[,-1]
nd<-read.csv("ndval.csv",header=T)[,-1]
pn<-read.csv("pnval.csv",header=T)[,-1]
sa<-read.csv("saval.csv",header=T)[,-1]
ska<-read.csv("skaval.csv",header=T)[,-1]
ws<-read.csv("wsval.csv",header=T)[,-1]
ze<-read.csv("zeval.csv",header=T)[,-1]
head(an[,])

        all<-list(an,aa,bh,ed,ia,id,nd,pn,sa,ska,ws,ze)

        
        head(all[[5]])

        jj<-NULL
        kk<-NULL
for (i in 1:5){
        g2<-all[[i]]
        for (j in 1:11){
  
        fit1<-glm(g2[,j+22]~g2[,j]+g2[,j+11],family="gaussian")
        hh<-as.data.frame(coef(fit1))
        hh
        jj[j]<-list(hh)
        }
        
        kk[i]<-list(jj)
        }
kk[[5]][[4]]
c<-(kk[[5]][[4]])

engmean<-mean(all[[4]][,4])
indmean<-mean(all[[4]][,15])
meanengvind<-mean(all[[4]][,26])
meanindveng

dd<-c[1,1]+c[2,1]*engmean+c[3,1]*indmean        
exp(dd)/(1+exp(dd))    


## We need to input the average predicted score and get predicted winning probability and then 
## compare it with all-time win/loss probability... 

##Everything after this is irrelevant........................




        g2<-all[[1]]
head(g2)
ncol(g2)
head(g2[,24])
i<-2
fit1<-glm(g2[,i+22]~g2[,i]+g2[,i+11],data=data,family="binomial")
fit1
hh<-as.data.frame(coef(fit1))
jj[i]<-list(hh)
hh[1,1]
c<-hh[1,1]+hh[2,1]*269+hh[3,1]*281
exp(c)/(1+exp(c))


probfits<-fit1$fitted.values
sum(probfits)
fitted<-predict(fit1)
sum(fitted)
plot(g2[,i+11],probfits,main="Fitted model on probability scale")
plot(g2[,i],fitted,main="Fitted model on log odds scale")


mean(g2[,i])
mean(g2[,i+11])

sum(g2[,i+22])
rm(list=(ls()))
