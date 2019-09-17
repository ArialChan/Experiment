library(RMySQL)

del_rep_base <- "truncate table rep_base_table"
dbGetQuery(con, del_rep_base)


rep_base_table_Setting <- function()
{
  KeywordCount_Rfile <- c("../results/2010_11_keyword_Count.R", "../results/2010_12_keyword_Count.R", "../results/2011_1_keyword_Count.R",
                          "../results/2011_2_keyword_Count.R", "../results/2011_3_keyword_Count.R", "../results/2011_4_keyword_Count.R", 
                          "../results/2011_5_keyword_Count.R", "../results/2011_6_keyword_Count.R", "../results/2011_7_keyword_Count.R",
                          "../results/2011_8_keyword_Count.R", "../results/2011_9_keyword_Count.R", "../results/2011_10_keyword_Count.R", 
                          "../results/2011_11_keyword_Count.R", "../results/2011_12_keyword_Count.R")
  
  KeywordList_txt <- c("rep_keyword/2010_11_keyword.txt", "rep_keyword/2010_12_keyword.txt", "rep_keyword/2011_01_keyword.txt", 
                       "rep_keyword/2011_02_keyword.txt", "rep_keyword/2011_03_keyword.txt", "rep_keyword/2011_04_keyword.txt", 
                       "rep_keyword/2011_05_keyword.txt", "rep_keyword/2011_06_keyword.txt", "rep_keyword/2011_07_keyword.txt", 
                       "rep_keyword/2011_08_keyword.txt", "rep_keyword/2011_09_keyword.txt", "rep_keyword/2011_10_keyword.txt",
                       "rep_keyword/2011_11_keyword.txt", "rep_keyword/2011_12_keyword.txt")

  for(i in 1:length(KeywordCount_Rfile))
  {
    load(KeywordCount_Rfile[i])
    
    #wordCount <- keyword_count
    word_vector <- readLines(KeywordList_txt[i])
    #freq_vector <- rep(0, length(word_vector))
    #word_vector <- cbind(word_vector, freq_vector)
    
    rep_keyword_count <- KeywordFreq(keyword_count, word_vector)

    #word_vector <- data.frame(word_vector)
    #word_vector[match(rep_keyword_count$word, word_vector$word),]$freq_vector <- rep_keyword_count$Freq
 
    #rep_keyword_count <- NULL
    
    rep_keyword_count <- data.frame(rep_keyword_count[,2:3])
    write.table(rep_keyword_count, "tt.txt", row.names=FALSE, col.names=FALSE)
    rep_keyword_count <- read.table("tt.txt")
    
    names(rep_keyword_count) <- c("rank4", "freq")
    
    time_info <- substring(KeywordList_txt[i], 13, 19)
    
    rep_keyword_count<- cbind(rep_keyword_count, time_info)

    for(j in 1:nrow(rep_keyword_count))
    {
      print(j)
      insert_query <- paste0("INSERT INTO rep_base_table (rank4, freq, time) VALUES (", 
                             "\"", rep_keyword_count[j,]$rank4, "\"", ",", 
                             rep_keyword_count[j,]$freq, ",", 
                             "\"", rep_keyword_count[j,]$time_info, "\"", ")")
      print(insert_query)
      rs = dbGetQuery(con, insert_query)
      
      if(j==nrow(rep_keyword_count))
      {
        print("Success for rep_base_table insertion!")
      }
    }
    
    keyword_count <- NULL
    word_vector <- NULL
    
  }
 
  # Can't do automatic updates... Please work in MySQl Workbench...
  #query1 <- "SET SQL_SAFE_UPDATES=0; "
  #rs = dbGetQuery(con, query)
  
  #update_query_1 <- "UPDATE rep_base_table SET rep_base_table.rank3 = (SELECT rep_bow.r_rank3 FROM rep_bow WHERE rep_bow.r_rank4 = rep_base_table.rank4); " 
  #print(update_query_1)
  #rs = dbGetQuery(con, update_query_1)
  
  #update_query_2 <- "UPDATE rep_base_table SET rep_base_table.rank2 = (SELECT rep_bow.r_rank2 FROM rep_bow WHERE rep_bow.r_rank4 = rep_base_table.rank4); " 
  #print(update_query_2)
  #rs = dbGetQuery(con, update_query_2)
  
  #update_query_3 <- "UPDATE rep_base_table SET rep_base_table.rank1 = (SELECT rep_bow.r_rank1 FROM rep_bow WHERE rep_bow.r_rank4 = rep_base_table.rank4)" 
  #print(update_query_3)
  #rs = dbGetQuery(con, update_query_3)
  
  #query <- paste0(query1, update_query_1, update_query_2, update_query_3)
  #rs = dbGetQuery(con, query)
  
  #select_query <- "SELECT * FROM rep_base_table"
  #rs = dbGetQuery(con, select_query)
  #rs[is.na[rs]] <- "미분류"
  
  #return (rs)
}