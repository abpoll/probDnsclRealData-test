
#plot distribution of flood heights for a few wet and dry destination cells

rm(list=ls())

library(terra)

setwd("C:/Users/svr5482")

flood<- c("flood2014","flood2020","floodfuture")

for(f in 1:length(flood)){
  print(flood[f])
  
  pt<-proc.time()
  
  run5m<- rast(paste0("FloodingModelCalibrationProject/04-Spatial_Stats_Samantha/Outputs5m/Norristown/nCh/PostMedCh/",flood[f],"/Extent/Run_1.asc"))
  coords.5m<- xyFromCell(run5m,1:ncell(run5m))
  
  #load cells of interest outside the low res flooded cells
  load(paste0("probDnsclRealData/data/",flood[f],"/destInds10mat5m.RData"))
  coords.5mDest<- coords.5m[destInds10m,]
  
  #get the actual flood height at each destination location
  trueDestFloodHeights<- c(as.matrix(extract(run5m,coords.5mDest)))
  
  #Now bring in the probability of being in the mapped-to distribution
  load(paste0("probDnsclRealData/data/",flood[f],"/modelProbFloodbyElev/predProbFloodatDest_5mElev10mModel.RData"))
  #load("probDnsclRealData/data/modelProbFloodbyCost/predProbFloodatDest_10mCost10mModel.RData")
  predProbFlood5mCost<- c(predProbFlood)
  
  ################################################################################
  #plot distribution of flood heights for a few nonflooded destination cells
  
  ################################################################################
  
  #If using the downscaled WSE shifted by the elevation at the destination
  
  #load the mean from the nearest downscaled flooded cell
  load(paste0("probDnsclRealData/data/",flood[f],"/shiftbyelevdnsclFromSourceToDest10mto5m.RData"))
  
  ################################################################################
  #If using the unshifted downscaled version
  
  #load the estimated mean from the nearest downscaled flooded cell
  #load("probDnsclRealData/data/dnsclFromSourceToDest10m.RData")
  
  ################################################################################
  probleq0GivenNotPtMass<- rep(NA,length(meanFromSourceToDest))
  totProbleq0<- rep(NA,length(meanFromSourceToDest))
  
  #load the estimated variance from comparing the downscaled projs to the HWMs
  load("probDnsclRealData/data/varResHWM10mto5m.RData")
  
  for(i in 1:length(meanFromSourceToDest)){
    probleq0GivenNotPtMass[i]<- pnorm(0, mean = meanFromSourceToDest[i], sd = sqrt(varResHWM10m))
    totProbleq0[i]<- (1-predProbFlood5mCost[i])+predProbFlood5mCost[i]*probleq0GivenNotPtMass[i]
  }
  
  
  #get the CDF function for num >=0
  CDFatDestPt<- function(sigma, i, num){
    probleqNumGivenNotPtMass<- pnorm(num, mean = meanFromSourceToDest[i], sd = sqrt(varResHWM10m))
    totProbleqNum<- (1-predProbFlood5mCost[i])+predProbFlood5mCost[i]*probleqNumGivenNotPtMass
    totProbleqNum
  }
  
  #what's the maximum number that should be plugged into the CDF?
  upper<- max(meanFromSourceToDest)+ 3*sqrt(varResHWM10m)
  
  
  valsToTest<- seq(0,round(upper+.01,2),by=.01)
  
  CDFmat<- matrix(NA, nrow=length(meanFromSourceToDest), ncol= length(valsToTest))
  
  for(j in 1:length(valsToTest)){
    for(i in 1:length(meanFromSourceToDest)){
      CDFmat[i,j]<- CDFatDestPt(sigma=sqrt(varResHWM10m),i=i,num=valsToTest[j])
    }
  }
  
  save(CDFmat,file=paste0("probDnsclRealData/data/",flood[f],"/shiftbyelevdnsclCDFmat_10mto5mElev.RData"))
  
  approxPDFmat<- matrix(NA, nrow=length(meanFromSourceToDest), ncol= length(valsToTest))
  
  for(j in 1:length(valsToTest)){
    for(i in 1:length(meanFromSourceToDest)){
      if(j==1) approxPDFmat[i,j]<-CDFmat[i,j]
      if(j>1) approxPDFmat[i,j]<-CDFmat[i,j]-CDFmat[i,j-1]
    }
  }
  
  
  save(approxPDFmat,file=paste0("probDnsclRealData/data/",flood[f],"/shiftbyelevdnsclApproxPDFmat_10mto5mElev.RData"))
  #pick some locations (rows) of interest to look at based on performance
  load(paste0("probDnsclRealData/data/",flood[f],"/estProbFloodIndsofInterest_10mto5mElev.RData"))
  
  ################################################################################
  #get the expectation for each destination cell
  
  meanAtDests<- c(approxPDFmat%*%valsToTest)
  #EX2<-  c((approxPDFmat^2)%*%valsToTest)
  #varAtDests<- EX2- meanAtDests^2
  
  mean(meanAtDests[indsProbNotFloodgeq.5]) #0.1098103
  mean(meanAtDests[indsProbFloodgeq.5]) #0.6351877
  
  mean(meanAtDests[indsFalseNeg]) #0.1479432
  mean(meanAtDests[indsNotFloodCorrect]) #0.1057225
  
  mean(meanAtDests[indsFloodCorrect]) #0.6351877
  
  mean(meanAtDests[c(indsNotFloodCorrect)]) #0.1057225
  mean(meanAtDests[c(indsFalseNeg,indsFloodCorrect)]) #0.3859434
  #okay so maybe my distribution doesn't have a valid variance
  
  save(meanAtDests,file=paste0("probDnsclRealData/data/",flood[f],"/shiftbyelevdnsclMeanAtDests_10mto5mElev.RData"))
  
  ptFinal<-proc.time()-pt
  time_getCDFandPDFatDests<-ptFinal[3]
  save(time_getCDFandPDFatDests, file=paste0("C:/Users/svr5482/probDnsclRealData/data/",flood[f],"/time_getCDFandPDFatDests_10mto5mElev.RData"))
  
  
}

