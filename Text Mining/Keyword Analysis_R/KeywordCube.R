##############################################################################################

### Rep Keyword Count
rep_base_table_Setting()

########## In MySQL.... query... ###########

rep_key_base_table[is.na(rep_key_base_table)] <- "미분류"



key_time_table_Setting()

##############################################################################################

gen_time_keyword_cube <- function()
{
  select_query <- "SELECT * FROM rep_base_table"
  rep_key_base_table = dbGetQuery(con, select_query)
  
  year <- rep_key_base_table$year
  quarter <- rep_key_base_table$quarter
  month <-rep_key_base_table$month
  
  keyword <- rep_key_base_table$rank4
  rank3 <- rep_key_base_table$rank3
  rank2 <- rep_key_base_table$rank2
  rank1 <- rep_key_base_table$rank1
  rank0 <- rep_key_base_table$rank0
  
  freq <- rep_key_base_table$freq
  
  #count <- 1
  
  dims<-data.frame(year=year, quarter=quarter, month=month, keyword=keyword, rank3=rank3,
                   rank2=rank2,rank1=rank1, rank0=rank0, freq=freq)
  # dims<-dims[order(dims$year),
  row.names(dims) <- NULL
  
  return(dims)
}


keyword_fact_table <- gen_time_keyword_cube()

time_keyword_cube <- tapply(keyword_fact_table$freq, 
                            keyword_fact_table[,c("year","quarter","month",
                                      "keyword","rank3","rank2","rank1", "rank0")], 
                        FUN=function(x) {return(sum(x))})

YR0 <- apply(time_keyword_cube, c("year","rank0"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
QR1 <- apply(time_keyword_cube, c("quarter","rank1"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
QR2 <- apply(time_keyword_cube, c("quarter","rank2"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
QR3 <- apply(time_keyword_cube, c("quarter", "rank3"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
MR4 <- apply(time_keyword_cube, c("month", "keyword"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
