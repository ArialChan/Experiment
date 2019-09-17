library(RColorBrewer)
library(ggplot2)
library(data.table)  # faster fread() and better weekdays()
library(dplyr)       # consistent data.frame operations
library(purrr)       # consistent & safe list/vector munging
library(tidyr)       # consistent data.frame cleaning
library(lubridate)   # date manipulation
library(countrycode) # turn country codes into pretty names
library(ggplot2)     # base plots are for Coursera professors
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(knitr)       # kable : prettier data.frame output

make_heatmap_form <- function(level, filename=0)
{
  if(level==1)
  {
    final_data_frame <- read.table(filename)
    return (final_data_frame)
  }
  
  else if(level==2)
  {
    test1 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_1.txt")
    test1_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_1_label.txt")
    test2 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_2.txt")
    test2_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_2_label.txt")
    test3 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_3.txt")
    test3_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level2_3_label.txt")
  }
  
  else if(level==3)
  {
    test1 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_1.txt")
    test1_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_1_label.txt")
    test2 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_2.txt")
    test2_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_2_label.txt")
    test3 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_3.txt")
    test3_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level3_3_label.txt")
  }
  
  else if(level==4)
  {
    test1 <- read.table(filename)
    test1_label <- read.table(paste0(substring(filename, 1, nchar(filename)-4), "_label.txt"))
    
    if(substring(filename, nchar(filename)-4, nchar(filename)-4) == "1")
    {
      test1[2:ncol(test1)] <- test1[2:ncol(test1)]/7980
    }
    else if (substring(filename, nchar(filename)-4, nchar(filename)-4) == "2")
    {
      test1[2:ncol(test1)] <- test1[2:ncol(test1)]/23522
    }
    else if (substring(filename, nchar(filename)-4, nchar(filename)-4) == "3")
    {
      test1[2:ncol(test1)] <- test1[2:ncol(test1)]/17428
    }
    
    temp_list_1 <- list()
    for(i in 1:(ncol(test1)-1))
    {
      temp_list_1[[i]] <- data.frame(test1[,1], test1_label[,i], test1[,i+1])
    }
    
    final_data_frame_1 <- data.frame()
    for(i in 1:length(temp_list_1))
    {
      final_data_frame_1 <- rbind(final_data_frame_1, temp_list_1[[i]])
    }
    
 
    
    colnames(final_data_frame_1) <- c("1", "2","3")
    return (final_data_frame_1)
  }
 
  #7980   #23522    #17428
  if(level==2 | level==3)
  {
    test1[2:ncol(test1)] <- test1[2:ncol(test1)]/7980
    test2[2:ncol(test2)] <- test2[2:ncol(test2)]/23522
    test3[2:ncol(test3)] <- test3[2:ncol(test3)]/17428
    
    temp_list_1 <- list()
    for(i in 1:(ncol(test1)-1))
    {
      temp_list_1[[i]] <- data.frame(test1[,1], test1_label[,i], test1[,i+1])
    }
    
    final_data_frame_1 <- data.frame()
    for(i in 1:length(temp_list_1))
    {
      final_data_frame_1 <- rbind(final_data_frame_1, temp_list_1[[i]])
    }
    
    temp_list_2 <- list()
    for(i in 1:(ncol(test2)-1))
    {
      temp_list_2[[i]] <- data.frame(test2[,1], test2_label[,i], test2[,i+1])
    }
    
    final_data_frame_2 <- data.frame()
    for(i in 1:length(temp_list_2))
    {
      final_data_frame_2 <- rbind(final_data_frame_2, temp_list_2[[i]])
    }
    
    temp_list_3 <- list()
    for(i in 1:(ncol(test3)-1))
    {
      temp_list_3[[i]] <- data.frame(test3[,1], test3_label[,i], test3[,i+1])
    }
    
    final_data_frame_3 <- data.frame()
    for(i in 1:length(temp_list_3))
    {
      final_data_frame_3 <- rbind(final_data_frame_3, temp_list_3[[i]])
    }
    colnames(final_data_frame_1) <- c("1", "2","3")
    colnames(final_data_frame_2) <- c("1", "2","3")
    colnames(final_data_frame_3) <- c("1", "2","3")
    final_data_frame <- rbind(final_data_frame_1, final_data_frame_2, final_data_frame_3)
    
    return(final_data_frame)
    
  }
}



###################

heatmap_jpg <- function(level, filename=0)
{
  data <- make_heatmap_form(level, filename)
  print("test")
  colnames(data) <- c("Rep", "Period", "Co_frequency_ratio")
  
  gg <- ggplot(data, aes(x=Period, y=Rep, fill=Co_frequency_ratio))
  
  gg <- gg + geom_tile(color="white", size=0.1)
  
  gg <- gg + scale_fill_gradientn(colours=brewer.pal(9, "Reds"), guide="colorbar")
  
  gg <- gg + labs(x=NULL, y=NULL, title="Heatmap for Crisis Period - Repercussions")
  
  gg <- gg + theme(plot.title=element_text(hjust=0))
  
  gg <- gg + theme(axis.ticks=element_blank())
  gg <- gg + theme(axis.text=element_text(size=10))
  gg <- gg + theme(legend.title=element_text(size=8))
  gg <- gg + theme(legend.text=element_text(size=10))
  
  
  filename <- paste0("heatmap_", level, "_", substring(filename, nchar(filename)-4, nchar(filename)-4),".jpg")
  ggsave(filename)
  
  return (gg)


}


filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_1.txt"
heatmap_jpg(1, filename)

filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_2.txt"
heatmap_jpg(1, filename)

filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_3_1.txt"
heatmap_jpg(1, filename)

filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_3_2.txt"
heatmap_jpg(1, filename)

filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_4_1.txt"
heatmap_jpg(1, filename)

filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_4_2.txt"
heatmap_jpg(1, filename)


filename <- "C:/Users/Administrator/Desktop/석사학위논문/실험결과/level_4_3.txt"
heatmap_jpg(1, filename)


heatmap_jpg(2)
heatmap_jpg(3)

filename <- c("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level4_1.txt")
heatmap_jpg(4, filename)



filename <- c("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level4_2.txt")
heatmap_jpg(4, filename)



filename <- c("C:/Users/Administrator/Desktop/석사학위논문/실험결과/level4_3.txt")
heatmap_jpg(4, filename)



#############################

filename <- c("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case_1.txt")
final_data_frame <- make_heatmap_form(4, filename)
colnames(final_data_frame) <- c("Rep", "Period", "Co_frequency_ratio")

gg <- ggplot(final_data_frame, aes(x=Rep, y=Period, fill=Co_frequency_ratio))

gg <- gg + geom_tile(color="white", size=0.1)

gg <- gg + scale_fill_gradientn(colours=brewer.pal(9, "Reds"), guide="colorbar")

gg <- gg + labs(x=NULL, y=NULL, title="Heatmap for Crisis Period - Repercussions")

gg <- gg + theme(plot.title=element_text(hjust=0))

gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text=element_text(size=10))
gg <- gg + theme(legend.title=element_text(size=8))
gg <- gg + theme(legend.text=element_text(size=10))


########################

test1 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_1.txt")
test1_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_1_label.txt")
test2 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_2.txt")
test2_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_2_label.txt")
test3 <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_3.txt")
test3_label <- read.table("C:/Users/Administrator/Desktop/석사학위논문/실험결과/case3_3_label.txt")

test1[2:ncol(test1)] <- test1[2:ncol(test1)]/7980
test2[2:ncol(test2)] <- test2[2:ncol(test2)]/23522
test3[2:ncol(test3)] <- test3[2:ncol(test3)]/17428

temp_list_1 <- list()
for(i in 1:(ncol(test1)-1))
{
  temp_list_1[[i]] <- data.frame(test1[,1], test1_label[,i], test1[,i+1])
}

final_data_frame_1 <- data.frame()
for(i in 1:length(temp_list_1))
{
  final_data_frame_1 <- rbind(final_data_frame_1, temp_list_1[[i]])
}

temp_list_2 <- list()
for(i in 1:(ncol(test2)-1))
{
  temp_list_2[[i]] <- data.frame(test2[,1], test2_label[,i], test2[,i+1])
}

final_data_frame_2 <- data.frame()
for(i in 1:length(temp_list_2))
{
  final_data_frame_2 <- rbind(final_data_frame_2, temp_list_2[[i]])
}

temp_list_3 <- list()
for(i in 1:(ncol(test3)-1))
{
  temp_list_3[[i]] <- data.frame(test3[,1], test3_label[,i], test3[,i+1])
}

final_data_frame_3 <- data.frame()
for(i in 1:length(temp_list_3))
{
  final_data_frame_3 <- rbind(final_data_frame_3, temp_list_3[[i]])
}
colnames(final_data_frame_1) <- c("1", "2","3")
colnames(final_data_frame_2) <- c("1", "2","3")
colnames(final_data_frame_3) <- c("1", "2","3")
final_data_frame <- rbind(final_data_frame_1, final_data_frame_2, final_data_frame_3)

