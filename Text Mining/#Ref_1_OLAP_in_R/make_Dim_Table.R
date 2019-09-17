del_key <- "truncate table new_keyword_table"
del_time <- "truncate table new_time_table"
del_type <- "truncate table new_type_table"
dbGetQuery(con,del_key)
dbGetQuery(con,del_time)
dbGetQuery(con,del_type)

#Keyword_table 쿼리 
keyword_insert <- "insert into new_keyword_table 
(select new_code_table.* 
from new_code_table, new_base_table 
where (substring_index(new_base_table.Keyword, '/', 1) 
= (select new_code_table.Rank4)))"
dbGetQuery(con, keyword_insert)

#Time_table 쿼리
year_insert <- "insert into new_time_table (Year) (select substring(Date,1,4) from new_base_table)"
dbGetQuery(con, year_insert)

period_insert <- "update new_time_table set Period='1990년대초' where Year>=1990 and Year<1995"
dbGetQuery(con, period_insert)
period_insert <- "update new_time_table set Period='1990년대후' where Year>=1995 and Year<2000"
dbGetQuery(con, period_insert)
period_insert <- "update new_time_table set Period='2000년대초' where Year>=2000 and Year<2005"
dbGetQuery(con, period_insert)
period_insert <- "update new_time_table set Period='2000년대후' where Year>=2005 and Year<2010"
dbGetQuery(con, period_insert)
period_insert <- "update new_time_table set Period='2010년대초' where Year>=2010 and Year<2015"
dbGetQuery(con, period_insert)
period_insert <- "update new_time_table set Period='2010년대후' where Year>=2015 and Year<2020"
dbGetQuery(con, period_insert)

era_insert <- "update new_time_table set Era='1990년대' where Year>=1990 and Year<2000"
dbGetQuery(con, era_insert)
era_insert <- "update new_time_table set Era='2000년대' where Year>=2000 and Year<2010"
dbGetQuery(con, era_insert)
era_insert <- "update new_time_table set Era='2010년대' where Year>=2010 and Year<2020"
dbGetQuery(con, era_insert)


#Type_table 쿼리
type_insert <- "insert into new_type_table (select substr(Type,1,1),substr(Type,2,1) from new_base_table)"
dbGetQuery(con, type_insert)
