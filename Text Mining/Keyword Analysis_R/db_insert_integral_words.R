library(RMySQL)

del_integral <- "truncate table integral_words_table"
dbGetQuery(con, del_integral)



## 통합 동시출현 키워드 인접행렬 생성 호출 (월별)
integral_word_Setting()

## DB에 넣기..
# 1. 한줄씩 co-freq 찾기
# 2. 넣기
# 3. 나머지 cell 채우기

integral_word_DB_insert <- function()
{
  integral_words_txt <- c("../results/2010_11_integral_words.txt", "../results/2010_12_integral_words.txt", "../results/2011_1_integral_words.txt",
                          "../results/2011_2_integral_words.txt", "../results/2011_3_integral_words.txt", "../results/2011_4_integral_words.txt", 
                          "../results/2011_5_integral_words.txt", "../results/2011_6_integral_words.txt", "../results/2011_7_integral_words.txt", 
                          "../results/2011_8_integral_words.txt", "../results/2011_9_integral_words.txt", "../results/2011_10_integral_words.txt",
                          "../results/2011_11_integral_words.txt", "../results/2011_12_integral_words.txt")
  
  for(i in 1:length(integral_words_txt))
  {
    table <- read.table(integral_words_txt[i])
    row_label <- rownames(table)
    
    if(i<3 | i>11)
    {
      time_info <- substring(integral_words_txt[i], 12, 18)
    }
    else
    {
      time_info <- paste0(substring(integral_words_txt[i], 12, 15), "_0", substring(integral_words_txt[i], 17, 17))
    }
    
    for(j in 1:nrow(table))
    {
      col_label <- colnames(table[j,])
     
      for(k in 1:length(col_label))
      {
        rep_rank4 <- row_label[j]
        cri_rank3 <- col_label[k]
        co_freq <- table[j,k]
        
        insert_query <- paste0("INSERT INTO integral_words_table (rep_rank4, action_rank2, time, co_freq) VALUES (", 
                               "\"", cri_rank3, "\"", ",", 
                               "\"", rep_rank4, "\"", ",", 
                               "\"", time_info, "\"", ",",
                               co_freq, ")")
        #print(insert_query)
        dbGetQuery(con, insert_query)
      }
      
    
    #table <- NULL
    }
    print(" Insertion Complete Successfully ! ")
  }
  
  update_query <- "UPDATE integral_words_table SET year=substring(time, 1, 4)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET month=substring(time, 6, 7)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET period='early' WHERE (year='2010') AND (month>=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET period='serious' WHERE (year='2011') AND (month <= 3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET period='termination' WHERE (year='2011') AND (month>3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET month='2010.11' WHERE (year='2010') AND (month=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE integral_words_table SET month='2010.12' WHERE (year='2010') AND (month=12)"
  dbGetQuery(con, update_query)
}

new_integral_words_table <- function()
{
  select_query <- "SELECT * FROM rep_base_table"
  rep_key_base_table = dbGetQuery(con, select_query)
  rep_key_base_table[is.na(rep_key_base_table)] <- "미분류"
  
  del_new_rep_base_table <- "truncate table new_rep_base_table"
  dbGetQuery(con, del_new_rep_base_table)
  
  for(i in 1:nrow(rep_key_base_table))
  {
    insert_query <- paste0("INSERT INTO new_rep_base_table (rank4, rank3, rank2, rank1, time, freq) VALUES (", 
                           "\"", rep_key_base_table[i,]$rank4, "\"", ",", 
                           "\"", rep_key_base_table[i,]$rank3, "\"", ",",
                           "\"", rep_key_base_table[i,]$rank2, "\"", ",",
                           "\"", rep_key_base_table[i,]$rank1, "\"", ",",
                           "\"", rep_key_base_table[i,]$time, "\"", ",",
                           rep_key_base_table[j,]$freq, ")")
    #print(insert_query)
    dbGetQuery(con, insert_query)
  }
  
  select_query <- "SELECT * FROM integral_words_table"
  integral_words_table = dbGetQuery(con, select_query)
  
  select_query <- "SELECT new_rep_base_table.rank3 FROM new_rep_base_table, integral_words_table WHERE (integral_words_table.time=new_rep_base_table.time) AND (new_rep_base_table.rank4 = integral_words_table.rep_rank4)"
  rs_rep_rank3 = dbGetQuery(con, select_query)
  select_query <- "SELECT new_rep_base_table.rank2 FROM new_rep_base_table, integral_words_table WHERE (integral_words_table.time=new_rep_base_table.time) AND (new_rep_base_table.rank4 = integral_words_table.rep_rank4)"
  rs_rep_rank2 = dbGetQuery(con, select_query)
  select_query <- "SELECT new_rep_base_table.rank1 FROM new_rep_base_table, integral_words_table WHERE (integral_words_table.time=new_rep_base_table.time) AND (new_rep_base_table.rank4 = integral_words_table.rep_rank4)"
  rs_rep_rank1 = dbGetQuery(con, select_query)
  

  
  integral_words_table$rep_rank3 <- rs_rep_rank3
  integral_words_table$rep_rank2 <- rs_rep_rank2
  integral_words_table$rep_rank1 <- rs_rep_rank1
  
  select_query <- "SELECT crisis_bow.c_rank2 FROM crisis_bow, integral_words_table WHERE (integral_words_table.time=crisis_bow.time) AND (crisis_bow.c_rank3 = integral_words_table.cri_rank3)"
  rs_cri_rank2 = dbGetQuery(con, select_query)
  
  select_query <- "SELECT crisis_bow.c_rank1 FROM crisis_bow, integral_words_table WHERE (integral_words_table.time=crisis_bow.time) AND (crisis_bow.c_rank3 = integral_words_table.cri_rank3)"
  rs_cri_rank1 = dbGetQuery(con, select_query)
  
  integral_words_table$cri_rank2 <- rs_cri_rank2
  integral_words_table$cri_rank1 <- rs_cri_rank1
  
  del_new_integral_word_table <- "truncate table new_integral_words_table"
  dbGetQuery(con, del_new_integral_word_table)
  
  integral_words_table[is.na(integral_words_table)]<- "미분류"
  
  for(i in 1:nrow(integral_words_table))
  {
    insert_query <- paste0("INSERT INTO new_integral_words_table (rep_rank4, rep_rank3, rep_rank2, rep_rank1, cri_rank3, cri_rank2, cri_rank1, time, co_freq) VALUES (", 
                           "\"", integral_words_table[i,]$rep_rank4, "\"", ",",
                           "\"", integral_words_table[i,]$rep_rank3, "\"", ",", 
                           "\"", integral_words_table[i,]$rep_rank2, "\"", ",", 
                           "\"", integral_words_table[i,]$rep_rank1, "\"", ",", 
                           "\"", integral_words_table[i,]$cri_rank3, "\"", ",", 
                           "\"", integral_words_table[i,]$cri_rank2, "\"", ",", 
                           "\"", integral_words_table[i,]$cri_rank1, "\"", ",", 
                           "\"", integral_words_table[i,]$time, "\"", ",", 
                           integral_words_table[i,]$co_freq, ")")
    print(insert_query)
    dbGetQuery(con, insert_query)
  }
  
  ######################################################
  update_query <- "UPDATE new_integral_words_table SET year=substring(time,1,4)"
  dbGetQuery(con, update_query)

  update_query <- "UPDATE new_integral_words_table SET month=substring(time, 6,8)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE new_integral_words_table SET period='early' WHERE (year='2010') AND (month>=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE new_integral_words_table SET period='serious' WHERE (year='2011') AND (month <= 3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE new_integral_words_table SET period='termination' WHERE (year='2011') AND (month>3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE new_integral_words_table SET month='2010.11' WHERE (year='2010') AND (month=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE new_integral_words_table SET month='2010.12' WHERE (year='2010') AND (month=12)"
  dbGetQuery(con, update_query)
  ######################################################
}

  