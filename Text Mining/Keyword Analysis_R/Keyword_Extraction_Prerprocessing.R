GetData <- function(cat, period)
{
  #Connect DB
  con = dbConnect(MySQL(), user="root", password="qudwns1004", dbname="news", host="localhost")
  dbGetQuery(con, "SET NAMES euckr")
  
  if( cat==0 )
  {
    if(period == 1) # 10.11 ~ 10.12
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2010_fmd WHERE ((Time like '%2010-11%') OR (Time like '%2010-12%'))")
    }
    
    else if(period == 2) # 11.01 ~ 11.03
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE ((Time like '%2011-01%') OR (Time like '%2011-02%') OR (Time like '%2011-03%'))")
    }
    
    else if( period == 3 ) # 11.04 ~ 11.12
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE ((Time like '%2011-04%') OR (Time like '%2011-05%') OR (Time like '%2011-06%')
                      OR (Time like '%2011-07%') OR (Time like '%2011-08%') OR (Time like '%2011-09%') OR (Time like '%2011-10%') 
                      OR (Time like '%2011-11%') OR (Time like '%2011-12%'))")
    }
    }
  
  if( cat==1 )
  {
    if(period == 1) # 10.11
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2010_fmd WHERE (Time like '%2010-11%')")
    }
    
    else if(period == 2) # 10.12
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2010_fmd WHERE (Time like '%2010-12%')")
    }
    
    else if( period == 3 ) # 11.01
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-01%')")
    }
    else if( period == 4 ) # 11.02
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-02%')")
    }
    else if( period == 5 ) # 11.03
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-03%')")
    }
    else if( period == 6 ) # 11.04
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-04%')")
    }
    else if( period == 7 ) # 11.05
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-05%')")
    }
    else if( period == 8 ) # 11.06
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-06%')")
    }
    else if( period == 9 ) # 11.07
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-07%')")
    }
    else if( period == 10 ) # 11.08
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-08%')")
    }
    else if( period == 11 ) # 11.09
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-09%')")
    }
    else if( period == 12 ) # 11.10
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-10%')")
    }
    else if( period == 13 ) # 11.11
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-11%')")
    }
    else if( period == 14 ) # 11.12
    {
      rs = dbGetQuery(con ,"SELECT * FROM 2011_fmd WHERE (Time like '%2011-12%')")
    }
  }
  
  
  #rs = rbind(rs_2010, rs_2011)
  
  #time <- substr(rs$Time, 1, 7)
  #time <- data.frame(table(time))
  #cumtime <- cumsum(time[,2])
  #cumtime <- cbind(time, cumtime)
  
  return (rs$Contents)
  
}

Preprocessing <- function(newsList)
{
  #data = newsList
  
  # 명사 추출
  data = sapply(newsList, extractNoun)
  
  # 길이 1 이하, 7이상 단어 삭제  
  for(i in 1:length(data))
  {
    data[[i]] = data[[i]][nchar(data[[i]])>=2 & nchar(data[[i]])<7]
  }
  
  # 알파벳 필터
  system.time({
    wordList = AlphaFilter(data)
  })
  
  # 특수문자 필터
  system.time({
    wordList = StopwordFilter(wordList)
  })
    
  # 노이즈 문자 필터
  system.time({
    wordList = MainFilter_1(wordList)
  })
  
  # 노이즈 문자 필터
  system.time({
    wordList = MainFilter_2(wordList)
  })
  
  # 변환 후 길이 1 이하, 7이상 단어 삭제  
  for(i in 1:length(data))
  {
    wordList[[i]] = wordList[[i]][nchar(wordList[[i]])>=2 & nchar(wordList[[i]])<7]
  }
  
  # 명사 변환 
  system.time({
    wordList = ConvertFilter(wordList)
  })
  
  
  # list 해제 전 wordList 생성
  #wordList = data
  word = unlist(wordList)
  wordCount = data.frame(table(word))
  wordCount = wordCount[wordCount$Freq > 3,]
  
  #write.table(wordCount$word, "word.txt")
  temp = wordCount$word[order(wordCount$word, decreasing=TRUE)]
  write.table(temp, "word.txt", row.names=F, col.names=F, sep="\t", quote=F)
  
  wordCount = cbind(num=1:nrow(wordCount), wordCount)
  
  vocab = as.vector(wordCount$word)
  vocab[length(vocab)+1] <- "cc"
  
  document = list()
  for(i in 1:length(wordList))
  {
    docuTemp = data.frame(table(wordList[[i]]))
    
    wordCode = match(docuTemp$Var1, wordCount$word, nomatch=0)
    temp = cbind(wordCode, docuTemp$Freq)
    colnames(temp) = NULL
    document[[i]] = t(temp)
    
    document[[i]] = document[[i]][, document[[i]][1,]>0]
  }
  
  for (i in 1:length(document))
  {
    mode(document[[i]]) <- "integer"
  }
  
  return (list(vocab=vocab, document=document, wordCount=wordCount, wordList=wordList))
}

TopicExtraction <- function(document, vocab)
{
  dtm <- ldaformat2dtm(document, vocab, omit_empty=TRUE)
  ldaformat <- dtm2ldaformat(dtm, omit_empty=TRUE)
  
  result <- lda.collapsed.gibbs.sampler(ldaformat$document, 1, ldaformat$vocab, 
                                        num.iterations=2000, alpha=0.03, eta=0.1)
  keyword <- top.topic.words(result$topics, 100)
  
  
  return (list(dtm=dtm, ldaformat=ldaformat, keyword=keyword, result=result))
}

KeywordFreq <- function(wordCount, keyword)
{
  keyFreq <- wordCount[match(keyword, wordCount[,2], nomatch=0),]
  
  return (keyFreq)
}


