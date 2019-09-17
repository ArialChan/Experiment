library(RMySQL)

del_crisis_bow <- "truncate table crisis_bow"
dbGetQuery(con, del_crisis_bow)


cri_rank_attach <- function(filename)
{
  word_vector <- readLines(filename)
  idxMat <- matrix(rep(0, length(word_vector)),, 1)
  idxMat[which(word_vector=="1")] <- 1
  idxMat[which(word_vector=="1")+1] <- 1
  
  # 구분자(1)의 누적을 통해 character 변환
  cum.idxMat <- cumsum(idxMat)
  temp <- as.data.frame(cbind(word_vector, cum.idxMat))
  temp <- temp[which(temp$word_vector!=1),]
  names(temp) <- c("rank3", "rank2")
  
  return (temp)
}

# time / rank 1,2,3 / freq 들어가야함 rank4가 가장 하위 레벨 (키워드)
cri_BOW_setting_DB_Insert <- function(filename, Rfile)
{
  if(filename == "crisis_word/early.txt")
  {
    print("file name selection 1")
    print(filename)
    RfileIdx <- c(1, 2)
  }
  else if(filename == "crisis_word/serious.txt")
  {
    print("file name selection 2")
    print(filename)
    RfileIdx <- c(3, 4, 5)
  }
  else
  {
    print("file name selection 3")
    print(filename)
    RfileIdx <- c(6, 7, 8, 9, 10, 11, 12, 13, 14)
  }
 
  for(i in 1:length(RfileIdx))
  {
    #print("%d Rfile :", i)
    print(Rfile[RfileIdx[i]])
    word_vector <- cri_rank_attach(filename)
    freq_vector <- rep(0, nrow(word_vector))

    if(length(RfileIdx) == 2)
    {
      time_info <- substring(Rfile[RfileIdx[i]], 12, 18)
      print ("time_info 1st if condition")
      print (time_info)
    }
    else if(length(RfileIdx) == 3)
    {
      time_temp <- substring(Rfile[RfileIdx[i]], 12, 17)
      time_info <- paste0(substring(time_temp, 1,4), "_0", substring(time_temp, 6,7))
      print ("time_info 2nd else if condition")
      print (time_info)
    }
    else
    {
      if(i>=7)
      {
        time_info <- substring(Rfile[RfileIdx[i]], 12, 18)
        print ("time_info else - 1st if condition")
        print (time_info)
      }
      else
      {
        time_temp <- substring(Rfile[RfileIdx[i]], 12, 17)
        time_info <- paste0(substring(time_temp, 1,4), "_0", substring(time_temp, 6,7))
        print ("time_info else - 2nd else condition")
        print (time_info)
      }
    }

    word_vector <- cbind(word_vector, freq_vector, time_info)

    load(Rfile[i])
    wordCount <- pre$wordCount
    
    crisis_word_count <- KeywordFreq(wordCount, word_vector[,1])
    word_vector[match(crisis_word_count$word, word_vector$rank3),]$freq_vector <- crisis_word_count$Freq
    crisis_word_count <- NULL
    crisis_word_count <- word_vector
    
    print(RfileIdx[i])
    if(RfileIdx[i] < 3)
    {
      crisis_word_count_txt <- paste0("../results/2010_1", RfileIdx[i], "_crisis_word_Count.txt")
      crisis_word_count_R <- paste0("../results/2010_1", RfileIdx[i], "_crisis_word_Count.R")
     
    }
    else #time >= 3
    {
      crisis_word_count_txt <- paste0("../results/2011_", (RfileIdx[i]-2), "_crisis_word_Count.txt")
      crisis_word_count_R <- paste0("../results/2011_", (RfileIdx[i]-2), "_crisis_word_Count.R")
    }
    write.table(crisis_word_count, crisis_word_count_txt)
    message <- paste0("Write ", crisis_word_count_txt, " Success!!")
    print(message)
 
    #WordCount 형태가 아니라 pre 전체 저장!
    save(crisis_word_count, file=crisis_word_count_R)
    message <- paste0("Save ", crisis_word_count_R, " Success!!")
    print(message)
  

    for(j in 1:nrow(word_vector))
    {
      insert_query <- paste0("INSERT INTO crisis_bow (c_rank3, c_rank2, freq, time) VALUES (", 
                             "\"", word_vector[j,]$rank3, "\"", ",", 
                             "\"", word_vector[j,]$rank2, "\"", ",", 
                             word_vector[j,]$freq_vector, ",", 
                             "\"", word_vector[j,]$time_info, "\"", ")")
      #print(insert_query)
      rs = dbGetQuery(con, insert_query)
      if(j==nrow(word_vector))
      {
        print("Success for crisis_bow table insertion!")
      }
    }
    
    #return (word_vector)
  }
  #period_insert <- "update new_time_table set Period='1990년대초' where Year>=1990 and Year<1995"
  #"insert into new_time_table (Year) (select substring(Date,1,4) from new_base_table)"
  
  update_query <- ("UPDATE crisis_bow SET c_rank2='조치사항' WHERE c_rank2='2'")
  #print(update_query)
  rs = dbGetQuery(con, update_query)
  
  update_query <- ("UPDATE crisis_bow SET c_rank2='관계기관' WHERE c_rank2='0'")
  #print(update_query)
  rs = dbGetQuery(con, update_query)
  
  update_query <- ("UPDATE crisis_bow SET c_rank1='발생초기' WHERE (substring(time, 1, 4)=2010)") 
  #print(update_query)
  rs = dbGetQuery(con, update_query)
  
  update_query <- ("UPDATE crisis_bow SET c_rank1='심각기' WHERE (substring(time, 1, 4)=2011) AND (substring(time, 6,8)<=3)") 
  #print(update_query)
  rs = dbGetQuery(con, update_query)
  
  update_query <- ("UPDATE crisis_bow SET c_rank1='종식이후' WHERE (substring(time, 1, 4)=2011) AND (substring(time, 6, 8)>=4)") 
  #print(update_query)
  rs = dbGetQuery(con, update_query)
}