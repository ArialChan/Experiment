test_function <- function()
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
    
    rep_keyword_count <- KeywordFreq(keyword_count, word_vector)
    freq_vector <- rep(0, length(word_vector))
    word_vector <- cbind(word_vector, freq_vector)
    word_vector <- data.frame(word_vector)
    
    word_vector[match(rep_keyword_count$word, word_vector$word),]$freq_vector <- rep_keyword_count$Freq
    
   
    rep_keyword_count <- NULL
    rep_keyword_count <- word_vector
    
    names(rep_keyword_count) <- c("rank4", "freq")
    
    time_info <- substring(KeywordList_txt[i], 13, 19)
    
    rep_keyword_count<- cbind(rep_keyword_count, time_info)
  }
}