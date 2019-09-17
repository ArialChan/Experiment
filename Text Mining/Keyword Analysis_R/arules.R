library(arules)

data <- read.transactions("keyword_tid.txt", format=c("basket"), sep=",")
rules <- apriori(data, parameter = list(minlen=1, maxlen=4, supp=0.06, conf=1, target="rules"))

rules.sorted <- sort(rules, by="lift")
#inspect(rules_1.sorted)

# find redundant rules
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)

# remove redundant rules
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)

write(rules, file="all_rules", sep=",")


############## 1 ###############
data_1 <- read.transactions("keyword_tid_1.txt", format=c("basket"), sep=",")
rules_1 <- apriori(data_1, parameter = list(minlen=1, maxlen=4, supp=0.5, conf=1, target="rules"))

rules_1.sorted <- sort(rules_1, by="lift")
#inspect(rules_1.sorted)

# find redundant rules
subset.matrix <- is.subset(rules_1.sorted, rules_1.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant_1 <- colSums(subset.matrix, na.rm=T) >= 1
#which(redundant_1)

# remove redundant rules
rules.pruned <- rules_1.sorted[!redundant_1]
#inspect(rules.pruned)

# write into .csv file
write(rules.pruned, file="rule_1.csv", sep=",")

############## 2 ###############
data_2 <- read.transactions("keyword_tid_2.txt", format=c("basket"), sep=",")
rules_2 <- apriori(data_2, parameter = list(minlen=1, maxlen=4, supp=0.05, conf=1, target="rules"))

rules_2.sorted <- sort(rules_2, by="lift")
#inspect(rules_2.sorted)

# find redundant rules
subset.matrix <- is.subset(rules_2.sorted, rules_2.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant_2 <- colSums(subset.matrix, na.rm=T) >= 1
#which(redundant_2)

# remove redundant rules
rules.pruned <- rules_2.sorted[!redundant_2]
#inspect(rules.pruned)

# write into .csv file
write(rules.pruned, file="rule_2.csv", sep=",")


############## 3 ###############
data_3 <- read.transactions("keyword_tid_3.txt", format=c("basket"), sep=",")
rules_3 <- apriori(data_3, parameter = list(minlen=1, maxlen=4, supp=0.06, conf=1, target="rules"))

rules_3.sorted <- sort(rules_3, by="lift")
#inspect(rules_3.sorted)

# find redundant rules
subset.matrix <- is.subset(rules_3.sorted, rules_3.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant_3 <- colSums(subset.matrix, na.rm=T) >= 1
#which(redundant_3)

# remove redundant rules
rules.pruned <- rules_3.sorted[!redundant_3]
#inspect(rules.pruned)

# write into .csv file
write(rules.pruned, file="rule_3.csv", sep=",")