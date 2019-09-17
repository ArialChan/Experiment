### 1. Keyword-word를 하나의 벡터로
### 2. document 사이에서 해당 키워드들의 빈도수 찾기
### (매달 찾아야하나?)
### 3. Adj matrix 만들기
### 4. 잘라내기

integral_word_Setting <- function()
{
  wordCount_Rfile <- c("../results/2010_11_wordCount.R", "../results/2010_12_wordCount.R", "../results/2011_1_wordCount.R",
                          "../results/2011_2_wordCount.R", "../results/2011_3_wordCount.R", "../results/2011_4_wordCount.R", 
                          "../results/2011_5_wordCount.R", "../results/2011_6_wordCount.R", "../results/2011_7_wordCount.R",
                          "../results/2011_8_wordCount.R", "../results/2011_9_wordCount.R", "../results/2011_10_wordCount.R", 
                          "../results/2011_11_wordCount.R", "../results/2011_12_wordCount.R")

  
  KeywordList_txt <- c("rep_keyword/2010_11_keyword.txt", "rep_keyword/2010_12_keyword.txt", "rep_keyword/2011_01_keyword.txt", 
                       "rep_keyword/2011_02_keyword.txt", "rep_keyword/2011_03_keyword.txt", "rep_keyword/2011_04_keyword.txt", 
                       "rep_keyword/2011_05_keyword.txt", "rep_keyword/2011_06_keyword.txt", "rep_keyword/2011_07_keyword.txt", 
                       "rep_keyword/2011_08_keyword.txt", "rep_keyword/2011_09_keyword.txt", "rep_keyword/2011_10_keyword.txt",
                       "rep_keyword/2011_11_keyword.txt", "rep_keyword/2011_12_keyword.txt")
  
  
  for(i in 1:length(wordCount_Rfile))
  {
    time <- i
    print("time setting complete")
    
    load(wordCount_Rfile[i])
    print("R file load complete")

    keyword_result <- readLines(KeywordList_txt[i])
    print("keyword text file reading... complete")

    query_action <- paste0("SELECT rank4, time FROM rep_base_table WHERE rank1 like '%대응%' AND (time like '",   substring(KeywordList_txt[i], 13, 19), "')")
    action_word_result <- dbGetQuery(con, query_action)
    query_rep <- paste0("SELECT rank4, time FROM rep_base_table WHERE ((rank1 like '%경제%') OR (rank1 like '%정책%') OR (rank1 like '%환경%')) AND (time like '",   substring(KeywordList_txt[i], 13, 19), "')")
    rep_word_result <- dbGetQuery(con, query_rep)
    print("getting data for query... complete")
        
    flag_1 <- length(action_word_result$rank4)
    flag_2 <- length(rep_word_result$rank4)
    print("flag setting..")

   
    wordList <- c(action_word_result$rank4, rep_word_result$rank4)
    print("test1")
    dtm <- ldaformat2dtm(pre$document, pre$vocab, omit_empty=TRUE)
    print("test2")
    Mat.dtm <- matrix(dtm, nrow=nrow(dtm), ncol=ncol(dtm))
    print("test3")

    
    colnames(Mat.dtm) <- colnames(dtm)
    print("test4")

    # Match keyword column(Document-Term matrix) with keyword vector
    Mat.KeyDoc <- matrix(0, length(wordList), length(wordList))
    print("test5")

    Mat.KeyDoc <- Mat.dtm[,match(wordList, colnames(Mat.dtm))]
    print("test6")
    
    Mat.KeyDoc[is.na(Mat.KeyDoc)] <- 0
    
    adj <- matrix(0, ncol(Mat.KeyDoc), ncol(Mat.KeyDoc))
    
    #Mat.KeyDoc[Mat.KeyDoc>1] <- 1
    for( i in 1:(nrow(adj)-1) )
    {
      for( j in i:(ncol(adj)-1) )
      {
        adj[i, j+1] <- sum( (Mat.KeyDoc[,i]!=0) & (Mat.KeyDoc[,j+1]!=0) )
      }
    }
    
    write.table(adj, "test.txt")
    
    adj <- adj[1:flag_1, (flag_1+1):(flag_1+flag_2)]
    
    colnames(adj) <- rep_word_result$rank4
    rownames(adj) <- action_word_result$rank4
    
    #############################################################

    if(time < 3)
    {
      integral_words_txt <- paste0("../results/2010_1", time, "_integral_words.txt")
      integral_words_R <- paste0("../results/2010_1", time, "_integral_words.R")
    }
    else #time >= 3
    {
      integral_words_txt <- paste0("../results/2011_", (time-2), "_integral_words.txt")
      integral_words_R <- paste0("../results/2011_", (time-2), "_integral_words.R")
    }

    write.table(adj, integral_words_txt)
    message <- paste0("Write ", integral_words_txt, " Success!!")
    print(message)
    
    save(adj, file=integral_words_R) # included dtm matrix
    message <- paste0("Save ", integral_words_R, " Success!!")
    print(message)
    ###################################################################
    
    pre <- NULL
    
  }
}