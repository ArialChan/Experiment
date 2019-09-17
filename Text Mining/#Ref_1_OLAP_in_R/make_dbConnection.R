library("DBI", lib.loc="C:/Program Files/R/R-3.1.1/library")
library("RMySQL", lib.loc="C:/Program Files/R/R-3.1.1/library")
library("RColorBrewer", lib.loc="~/R/win-library/3.1")
con <- dbConnect(MySQL(), host="127.0.0.1",port=3306,user="root",password="idb1344",dbname="idb")
dbGetQuery(con, "set names euckr")


