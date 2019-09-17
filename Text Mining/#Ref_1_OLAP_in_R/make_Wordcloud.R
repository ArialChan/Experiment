library("DBI", lib.loc="C:/Program Files/R/R-3.1.1/library")
library("RMySQL", lib.loc="C:/Program Files/R/R-3.1.1/library")
library("RColorBrewer")
library("wordcloud")
con <- dbConnect(MySQL(), host="127.0.0.1",port=3306,user="root",password="idb1344",dbname="idb")
dbGetQuery(con, "set names euckr")

windows(4,4)
#Keyword .을 기준으로 파싱
PName1 <- dbGetQuery(con, "select substring_index(Keyword,'.',1) from new_base_table")
PName2 <- dbGetQuery(con, "select substring_index(Keyword,'.',-1) from new_base_table")


#두 테이블 합체
PTable <- unlist(list(PName1, PName2), use.names=FALSE)


#word cloud를 위해 freq추출 
PTable <- table(PTable)

#글자 색 지정
pal <- brewer.pal(12, "Paired")

#Word cloud 만들기
wordcloud(names(PTable), freq=PTable, scale=c(2.5,1), min.freq=0.5, random.order=F, rot.per=0.3, colors=pal)

#word cloud 이미지 추출
savePlot("C:\\Users\\Administrator\\Desktop\\[졸프]연구실 홈페이지\\이미지테스트\\wordcloud", type="png")
