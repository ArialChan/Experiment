

del_rep_base <- "truncate table rep_base_table"
dbGetQuery(con, del_rep_base)

### Rep Keyword Count
rep_base_table_Setting()

########## In MySQL.... query... ###########

select_query <- "SELECT * FROM rep_base_table"
rep_key_base_table = dbGetQuery(con, select_query)
rep_key_base_table[is.na(rep_key_base_table)] <- "미분류"

key_time_table_Setting()

########################################################

keyword_fact_table <- gen_time_keyword_cube()

time_keyword_cube <- tapply(keyword_fact_table$freq, 
                            keyword_fact_table[,c("year","period","month",
                                                  "keyword","r_rank3","r_rank2","r_rank1")], 
                            FUN=function(x) {return(sum(x))})


########################################################

del_crisis_bow <- "truncate table crisis_bow"
dbGetQuery(con, del_crisis_bow)

### Crisis Bag-of-words DB INSERTION ###
wordCount_Rfile <- c("../results/2010_11_wordCount.R", "../results/2010_12_wordCount.R", "../results/2011_1_wordCount.R", "../results/2011_2_wordCount.R",
                     "../results/2011_3_wordCount.R", "../results/2011_4_wordCount.R", "../results/2011_5_wordCount.R", "../results/2011_6_wordCount.R", 
                     "../results/2011_7_wordCount.R", "../results/2011_8_wordCount.R", "../results/2011_9_wordCount.R", "../results/2011_10_wordCount.R",
                     "../results/2011_11_wordCount.R", "../results/2011_12_wordCount.R")

filename <- c("crisis_word/early.txt", "crisis_word/serious.txt", "crisis_word/termination.txt")

cri_BOW_setting_DB_Insert(filename[1], wordCount_Rfile)
cri_BOW_setting_DB_Insert(filename[2], wordCount_Rfile)
cri_BOW_setting_DB_Insert(filename[3], wordCount_Rfile)

cri_time_table_Setting()
cri_word_fact_table <- gen_time_cri_word_cube()

time_cri_word_cube <- tapply(cri_word_fact_table$freq, 
                             cri_word_fact_table[,c("year","period","month", "c_rank3","c_rank2","c_rank1")], 
                             FUN=function(x) {return(sum(x))})

########################################################

del_integral <- "truncate table integral_words_table"
dbGetQuery(con, del_integral)

integral_word_Setting()
integral_word_DB_insert()


########## In MySQL.... query... ###########

new_integral_table_Setting()

#######################################################

#######################################################

