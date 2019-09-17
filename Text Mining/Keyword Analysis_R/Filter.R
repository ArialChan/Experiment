#Package On
library(RMySQL)
library(igraph)
library(topicmodels)
library(RTextTools)
library(rJava)
library(KoNLP)
library(tm)
library(lda)
library(doParallel)
library(qdap)
library(reshape)
library(googleVis)
library(ggplot2)
library(plyr)
library(dplyr)
library(xlsx)

# Alphabat Filter
AlphaFilter <- function(data)
{
  data <- gsub("[a-z]","", data)
  data <- gsub("[A-Z]","", data)
  return (data)
}

# Stopwords Filter
StopwordFilter <- function(data)
{
  stop_gsub <- readLines("stopwords.txt")
  
  stopFilter = paste(sort(stop_gsub))
  
  cl = makeCluster(3)
  registerDoParallel(cl)
  
  T1 = data[1:(floor(length(data)/3))]
  T2 = data[(floor((length(data)/3))+1):(floor((2*(length(data)/3))))]
  T3 = data[(floor((2*(length(data)/3)))+1):(length(data))]
  
  T_names=c("T1","T2","T3")
  
  system.time({
    T_all = foreach(i=1:3, .export = T_names) %dopar% {
      qdap:::mgsub(stopFilter, replace=" ", get(paste0("T",i)))
    }
  })
  
  T_all = unlist(T_all)
  
  wordList = list()
  for(i in 1:length(T_all))
  {
    temp = unlist(strsplit(T_all[[i]], " "))
    wordList[[i]] = temp[-1]
  }
  
  return(wordList)
}

####################################

MainFilter_1 <- function(wordList)
{
  main_gsub <- readLines("filterwords1.txt")
  
  filterwords = paste(sort(main_gsub))
  
  cl = makeCluster(3)
  registerDoParallel(cl)
  
  T1 = wordList[1:(floor(length(wordList)/3))]
  T2 = wordList[(floor((length(wordList)/3))+1):(floor((2*(length(wordList)/3))))]
  T3 = wordList[(floor((2*(length(wordList)/3)))+1):(length(wordList))]
  
  T_names=c("T1","T2","T3")
  
  system.time({
    T_all = foreach(i=1:3, .export = T_names) %dopar% {
      qdap:::mgsub(filterwords, replace="", get(paste0("T",i)))
    }
  })
  
  T_all = unlist(T_all)
  
  wordList = list()
  for(i in 1:length(T_all))
  {
    temp = unlist(strsplit(T_all[[i]], "[\"]"))
    temp = temp[!match(temp, ", ", nomatch=0)]
    temp = temp[-1]
    wordList[[i]] = temp[-length(temp)]
  }
  
  return(wordList)
}

MainFilter_2 <- function(wordList)
{
  main_gsub <- readLines("filterwords2.txt")
  
  filterwords = paste(sort(main_gsub))
  
  cl = makeCluster(3)
  registerDoParallel(cl)
  
  T1 = wordList[1:(floor(length(wordList)/3))]
  T2 = wordList[(floor((length(wordList)/3))+1):(floor((2*(length(wordList)/3))))]
  T3 = wordList[(floor((2*(length(wordList)/3)))+1):(length(wordList))]
  
  T_names=c("T1","T2","T3")
  
  system.time({
    T_all = foreach(i=1:3, .export = T_names) %dopar% {
      qdap:::mgsub(filterwords, replace="", get(paste0("T",i)))
    }
  })
  
  T_all = unlist(T_all)
  
  wordList = list()
  for(i in 1:length(T_all))
  {
    temp = unlist(strsplit(T_all[[i]], "[\"]"))
    temp = temp[!match(temp, ", ", nomatch=0)]
    temp = temp[-1]
    wordList[[i]] = temp[-length(temp)]
  }
  
  return(wordList)
}

ConvertFilter <- function(wordList)
{
  convert_gsub <- readLines("convertwords.txt")
  
   # convert_gsub의 구분자(1)에 대한 index matrix 생성
  idxMat <- matrix(rep(0, length(convert_gsub)),, 1)
  idxMat[which(convert_gsub=="1")] <- 1
  idxMat[which(convert_gsub=="1")+1] <- 1
  
  # 구분자(1)의 누적을 통해 character 변환
  cum.idxMat <- cumsum(idxMat)
  temp <- as.data.frame(cbind(convert_gsub, cum.idxMat))
  temp <- temp[which(temp$convert_gsub!=1),]
  finalTerm <- temp[!duplicated(temp[,2], fromLast=TRUE),]
  convTable <- merge(temp, finalTerm, by="cum.idxMat", all=T)
  names(convTable) <- c("sign", "origin", "convert")
  
  cl = makeCluster(3)
  registerDoParallel(cl)
  
  T1 = wordList[1:(floor(length(wordList)/3))]
  T2 = wordList[(floor((length(wordList)/3))+1):(floor((2*(length(wordList)/3))))]
  T3 = wordList[(floor((2*(length(wordList)/3)))+1):(length(wordList))]
  
  T_names=c("T1","T2","T3")
  
  system.time({
    T_all = foreach(i=1:3, .export = T_names) %dopar% {
      qdap:::mgsub(as.character(convTable$origin), replace=as.character(convTable$convert), get(paste0("T",i)))
    }
  })
  
  T_all = unlist(T_all)
  
  convWordList = list()
  for(i in 1:length(T_all))
  {
    temp = unlist(strsplit(T_all[[i]], "[\"]"))
    temp = temp[!match(temp, ", ", nomatch=0)]
    temp = temp[-1]
    convWordList[[i]] = temp[-length(temp)]
  }
  
  return (convWordList)
}
