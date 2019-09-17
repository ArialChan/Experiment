gen_research_cube <- function(no_of_recs)
{
  year <-dbGetQuery(con, "select year from new_time_table")
  period <- dbGetQuery(con, "select Period from new_time_table")
  era <- dbGetQuery(con, "select Era from new_time_table")
  Rank4 <- dbGetQuery(con, "select Rank4 from new_keyword_table")
  Rank3 <- dbGetQuery(con, "select Rank3 from new_keyword_table")
  Rank2 <- dbGetQuery(con, "select Rank2 from new_keyword_table")
  Rank1 <- dbGetQuery(con, "select Rank1 from new_keyword_table")
  global <- dbGetQuery(con, "select global from new_type_table")
  Type <- dbGetQuery(con,"select Type from new_base_table")

  count <- 1
  
  dims<-data.frame(year=year, period=period, era=era, Rank4=Rank4, Rank3=Rank3,
                   Rank2=Rank2,Rank1=Rank1,global=global, Type=Type, count=count)
 # dims<-dims[order(dims$year),]
  row.names(dims) <- NULL
  
  return(dims)
}

fact_table <- gen_research_cube()

research_cube <- tapply(fact_table$count, 
                        fact_table[,c("year","Period","Era",
                                      "Rank4","Rank3","Rank2","Rank1","global","Type")], 
                        FUN=function(x) {return(sum(x))})
