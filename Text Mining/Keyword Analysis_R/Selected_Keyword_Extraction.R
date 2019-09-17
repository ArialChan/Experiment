# pre 파일 받아야함(wordCount)
Selected_Keyword_Freq_Extractor <- function(Rfile, type, option, keyword_vector)
{
  load(Rfile)
  wordCount <- pre$wordCount
  
  if(option==1)
  {
    if(type == 1)
    {
      if(time < 3)
      {
        selcted_wordCount_txt <- paste0("../results/2010_1", time, "_selected_Keyword_Count.txt")
        selected_wordCount_R <- paste0("../results/2010_1", time, "_selected_Keyword_Count.R")
      }
      else #time >= 3
      {
        selcted_wordCount_txt <- paste0("../results/2011_", (time-2), "_selected_Keyword_Count.txt")
        selected_wordCount_R <- paste0("../results/2011_", (time-2), "_selected_Keyword_Count.R")
      }
      
    }
    else
    {
      selcted_wordCount_txt <- paste0("../results/selected_Keyword_Count_", time, ".txt")
      selected_wordCount_R <- paste0("../results/selected_Keyword_Count_", time, ".R")
    }
  }
  
  else
  {
    if(type == 1)
    {
      if(time < 3)
      {
        selcted_wordCount_txt <- paste0("../results/2010_1", time, "_crisis_word_Count.txt")
        selected_wordCount_R <- paste0("../results/2010_1", time, "_crisis_word_Count.R")
      }
      else #time >= 3
      {
        selcted_wordCount_txt <- paste0("../results/2011_", (time-2), "_crisis_word_Count.txt")
        selected_wordCount_R <- paste0("../results/2011_", (time-2), "_crisis_word_Count.R")
      }
      
    }
    else
    {
      selcted_wordCount_txt <- paste0("../results/crisis_word_Count_", time, ".txt")
      selected_wordCount_R <- paste0("../results/crisis_word_Count_", time, ".R")
    }
  }
 
  
  write.table(selected_keyword_count, selcted_wordCount_txt)
  message <- paste0("Write ", selcted_wordCount_txt, " Success!!")
  print(message)
  
  #WordCount 형태가 아니라 pre 전체 저장!
  save(selected_keyword_count, file=selected_wordCount_R)
  message <- paste0("Save ", selected_wordCount_R, " Success!!")
  print(message)
}

