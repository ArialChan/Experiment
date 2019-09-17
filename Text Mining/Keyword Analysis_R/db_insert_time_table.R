key_time_table_Setting <- function()
{
  del_rep_time_table <-  "truncate table rep_time_table"
  dbGetQuery(con, del_rep_time_table)
  insert_query <- "INSERT INTO rep_time_table (year, month) (SELECT substring(time,1,4), substring(time, 6,8) from new_rep_base_table)"
  dbGetQuery(con, insert_query)
  
  update_query <- "UPDATE rep_time_table SET period='early' WHERE (year='2010') AND (month>=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE rep_time_table SET period='serious' WHERE (year='2011') AND (month <= 3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE rep_time_table SET period='termination' WHERE (year='2011') AND (month>3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE rep_time_table SET month='2010.11' WHERE (year='2010') AND (month=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE rep_time_table SET month='2010.12' WHERE (year='2010') AND (month=12)"
  dbGetQuery(con, update_query)
}

cri_time_table_Setting <- function()
{
  del_crisis_time_table <-  "truncate table crisis_time_table"
  dbGetQuery(con, del_crisis_time_table)
  insert_query <- "INSERT INTO crisis_time_table (year, month) (SELECT substring(time,1,4), substring(time, 6,8) from crisis_bow)"
  dbGetQuery(con, insert_query)
  
  update_query <- "UPDATE crisis_time_table SET period='early' WHERE (year='2010') AND (month>=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE crisis_time_table SET period='serious' WHERE (year='2011') AND (month <= 3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE crisis_time_table SET period='termination' WHERE (year='2011') AND (month>3)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE crisis_time_table SET month='2010.11' WHERE (year='2010') AND (month=11)"
  dbGetQuery(con, update_query)
  
  update_query <- "UPDATE crisis_time_table SET month='2010.12' WHERE (year='2010') AND (month=12)"
  dbGetQuery(con, update_query)
}