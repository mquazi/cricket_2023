
#### You do not need this part ###########
beta<-seq(0.01,30,0.01)
alpha<-35/(beta)
gg<-qgamma(0.95, alpha, beta )
alpha<-35/0.93
alpha
gg<-pgamma(52, alpha, beta )
beta[51]
kk<-rgamma(1000,37.63,0.93)
hist(kk)
mean(kk)
min(kk)
max(kk)
x<-N(35,17)
gg[93]
beta[93]
#### You do not need this part ###########



install.packages("rvest")
install.packages("dplyr")
install.packages("XML")
library(rvest)
library(dplyr)
library(XML)

# Install only the rvest package

#teams<-append(teams, "v Kenya", after=7)
teams ## all possible teams
t<-as.data.frame(teams)
t
rownames(t)<-t[,1]
cc<-list()
dd<-list()
hs<-list()
ave<-list()
for (i in 1:16){
url<-c("https://stats.espncricinfo.com/ci/engine/player/253802.html?class=2;template=results;type=batting",
       "https://stats.espncricinfo.com/ci/engine/player/34102.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/28235.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/422108.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/477021.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/290716.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/30045.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/430246.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/559235.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/326016.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/625383.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/625371.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/234675.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/481896.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/931581.html?class=2;template=results;type=batting",
"https://stats.espncricinfo.com/ci/engine/player/642519.html?class=2;template=results;type=batting")
my_html<-read_html(url[i])

#pant and shankar
#url<-"https://stats.espncricinfo.com/ci/engine/player/477021.html?class=2;template=results;type=batting"
#url<-"https://stats.espncricinfo.com/ci/engine/player/931581.html?class=2;template=results;type=batting"
#my_html<-read_html(url)
# We'll access the fourth table from the web page. On pages with many tables this will
# be a trial and error process

my_tables<-html_nodes(my_html,"table")[[4]]

populous_table<-html_table(my_tables)
#str(populous_table)
#head(populous_table)
#populous_table[1:15,1]
#populous_table[[1]]

ll<-subset(populous_table, grepl("^v ", populous_table[[1]]), drop = TRUE)
#ll
realtable<-ll[1:nrow(ll),c("Grouping","HS","Ave")]
#realtable
#str(realtable)

realtable$HS<-as.numeric(gsub("\\*","",realtable$HS))
realtable$Ave<-as.numeric(gsub("-","NaN",realtable$Ave))
#realtable
n<-nrow(realtable)
#which(realtable$Ave=="NaN")
for (j in 1:n){
        if (realtable$Ave[j]=="NaN") 
                realtable$Ave[j]=realtable$HS[j]
}
#realtable

hs[[i]]<-realtable[,1:2]
ave[[i]]<-realtable[,c(1,3)]
#hs[[1]]
#hs1
#ave1<-realtable[,c(1,3)]
#ave1
#hs2
#ave2<-realtable[,c(1,3)]
#ave2

#t<-as.data.frame(teams)
#t
#str(realtable)
#str(t)

#(hs[2][,1])
gg<-hs[[i]]
rownames(gg)<-gg[,1]
hh<-ave[[i]]
rownames(hh)<-hh[,1]


#nrow(t)
#t
#hs2
#rownames(t)
cc[[i]]<-merge(t,gg["HS"],by="row.names",all.x=TRUE)
cc[[i]]<-cc[[i]][,3]
dd[[i]]<-merge(t,hh["Ave"],by="row.names",all.x=TRUE)
dd[[i]]<-dd[[i]][,3]
}

hh
dd
cc

allhs<-do.call(cbind,cc)
allave<-do.call(cbind,dd)
india1<-cbind(t,as.data.frame(allhs))
india2<-cbind(t,as.data.frame(allave))
india<-rbind(india1,india2)
india1
india2
str(india)
india


#rownames(hs2)<-hs2[,1]
#cc<-merge(t,hs2["HS"],by="row.names",all.x=TRUE)
#cc[,3]
#rownames(cc)<-cc[,1]
#rownames(hs3)<-hs3[,1]
#dd<-merge(cc,hs3["HS"],by="row.names",all.x=TRUE)
#dd
#rownames(dd)<-dd[,1]




##I will change the url for next player and all his info should append to the existing players'



setwd("/Users/quazi/Desktop/cric")
write.csv(india,'india.csv') #####Final output has to be a file with all highest and average scores
str(india)
dat<-read.csv("/Users/quazi/Desktop/cric/india.csv",header=T)
head(dat)

