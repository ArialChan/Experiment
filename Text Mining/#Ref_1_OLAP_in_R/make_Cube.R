fact_table <- gen_research_cube()

research_cube <- tapply(fact_table$count, 
                        fact_table[,c("year","Period","Era",
                                      "Rank4","Rank3","Rank2","Rank1","global","Type")], 
                        FUN=function(x) {return(sum(x))})