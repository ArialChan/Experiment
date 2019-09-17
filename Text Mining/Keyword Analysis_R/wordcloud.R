eco <- read.table("wordcloud_env.txt")
eco <- table(eco)
palete <- "black"
wordcloud(names(eco), freq=eco, scale=c(6,1), rot.per=0, min.freq=1, random.order=F, colors=palete)