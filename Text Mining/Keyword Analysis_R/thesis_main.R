mainFunction <- function(type, time)
{
  #Get News
  news <- GetData(type, time)
  
  #Preprocessing (wordCount)
  pre <- Preprocessing(news)
  if(type == 1)
  {
    if(time < 3)
    {
      wordCount_txt <- paste0("../results/2010_1", time, "_wordCount.txt")
      wordCount_R <- paste0("../results/2010_1", time, "_wordCount.R")
    }
    else #time >= 3
    {
      wordCount_txt <- paste0("../results/2011_", (time-2), "_wordCount.txt")
      wordCount_R <- paste0("../results/2011_", (time-2), "_wordCount.R")
    }
  }
  
  else
  {
    wordCount_txt <- paste0("../results/wordCount_", time, ".txt")
    wordCount_R <- paste0("../results/wordCount_", time, ".R")
  }
  
  write.table(pre$wordCount, wordCount_txt)
  message <- paste0("Write ", wordCount_txt, " Success!!")
  print(message)
  
  #WordCount 형태가 아니라 pre 전체 저장!
  save(pre, file=wordCount_R)
  message <- paste0("Save ", wordCount_R, " Success!!")
  print(message)
  
  
  # keyword Set
  keyword_vector <- TopicExtraction(pre$document, pre$vocab)
  if(type == 1)
  {
    if(time < 3)
    {
      keyword_txt <- paste0("../results/2010_1", time, "_keywords.txt")
      keyword_R <- paste0("../results/2010_1", time, "_keywords.R")
    }
    else #time >= 3
    {
      keyword_txt <- paste0("../results/2011_", (time-2), "_keywords.txt")
      keyword_R <- paste0("../results/2011_", (time-2), "_keywords.R")
    }
  }
  else
  {
    keyword_txt <- paste0("../results/keywords_", time, ".txt")
    keyword_R <- paste0("../results/keywords_", time, ".R")
  }
 
  write.table(keyword_vector$keyword, keyword_txt)
  message <- paste0("Write ", keyword_txt, " Success!!")
  print(message)
  
  save(keyword_vector, file=keyword_R) # included dtm matrix
  message <- paste0("Save ", keyword_R, " Success!!")
  print(message)
  
  
  # keyword Count
  keyword_count <- KeywordFreq(pre$wordCount, keyword_vector$keyword)
  if(type == 1)
  { 
    if(time < 3)
    {
      keycount_txt <- paste0("../results/2010_1", time, "_keyword_Count.txt")
      keycount_R <- paste0("../results/2010_1", time, "_keyword_Count.R")
    }
    else #time >= 3
    {
      keycount_txt <- paste0("../results/2011_", (time-2), "_keyword_Count.txt")
      keycount_R <- paste0("../results/2011_", (time-2), "_keyword_Count.R")
    }
  }
  else
  {
    keycount_txt <- paste0("../results/keyword_Count_", time, ".txt")
    keycount_R <- paste0("../results/keyword_Count_", time, ".R")
  }
 
  write.table(keyword_count, keycount_txt)
  message <- paste0("Write ", keycount_txt, " Success!!")
  print(message)
  
  save(keyword_count, file=keycount_R)
  message <- paste0("Save ", keycount_R, " Success!!")
  print(message)
}


### Keyword Extraciont for Main ###
##### Extraction & Rfile load #####

mainFunction(1, 1)
mainFunction(1, 2)
mainFunction(1, 3)
mainFunction(1, 4)
mainFunction(1, 5)
mainFunction(1, 6)
mainFunction(1, 7)
mainFunction(1, 8)
mainFunction(1, 9)
mainFunction(1, 10)
mainFunction(1, 11)
mainFunction(1, 12)
mainFunction(1, 13)
mainFunction(1, 14)



### Bag-of-words 적용 ###
#Connect DB
con = dbConnect(MySQL(), user="root", password="qudwns1004", dbname="news", host="localhost")
dbGetQuery(con, "SET NAMES euckr")





