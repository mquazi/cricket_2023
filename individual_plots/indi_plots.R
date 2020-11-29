#########################
######## Individual plots
#########################

setwd("/Users/quazi/Desktop/cric/simulationfiles/1kruns/individualplayers")
inddat<-read.csv("/Users/quazi/Desktop/cric/simulationfiles/1kruns/individualplayers/maxwell.csv",header=T)
inddat<-read.csv("/Users/quazi/Desktop/cric/simulationfiles/1kruns/individualplayers/kohli.csv",header=T)

############# Run the following for all the players and please make the plots look good ################
head(inddat)
inddat<-inddat[,-1]
dev.off()
dev.new()
par(mfrow=c(4,4))
variable<-c(1:15)
for(i in 1:15){
        plot(density(inddat[,i]),main=
                     (paste("Score distribution against team ", variable[i])))
}


#########################################################################################################
