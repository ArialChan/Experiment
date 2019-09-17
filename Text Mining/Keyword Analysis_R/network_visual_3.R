
load("../results/key_3.R")
####################################################################################################################
## for early_keyword...

if(0)
{
  keyword_3 <- c("구제역", 
                 "공급량", "공급부족", "관광산업", "관광산업소비량", "기준격", "돼지갈비", "돼지고기", "생산감소",
                 "미국", "삼겹살", "서비스업", "소비량", "물안정","유통", "시장", "시장점유율", "식품산업",
                 "수입가격규모",   "우유값", "수입가격가격",   "지역경제", "축산물", "축산업", "판매량", "한우고기",
                 "보상금", "관리본부", "예방대책","국무회의","지원대책",  "구청",  "지원금", "농림부","피해대책",
                 "오염", "수질오염", "처리시설",
                 "접종", "대비태세", "대응", "상황실", 
                 "경기도", "경남", "경북")
}

keyword_3 <- c("구제역", 
               "돼지고기", "공급량", "공급부족", "관광산업", "관광산업소비량", "기준격",  "삼겹살", "돼지갈비", "생산감소",
               "미국", "서비스업", "우유값",  "물안정","유통",  "시장점유율", "식품산업",
               "수입가격규모", "소비량", "수입가격가격",   "지역경제", "축산물", "축산업", "판매량", "한우고기","시장",
               "보상금", "관리본부", "예방대책","국무회의","지원대책",  "구청",  "지원금", "농림부","피해대책",
               "오염", "수질오염", "처리시설",
               "접종", "대비태세", "대응", "상황실")


# 1, 30, 14, 3, 4, 8
################# keyword - document matrix ################# 

# Document-Term matrix Copy from preprocessing function
Mat.WordDoc <- matrix(key_3$dtm, nrow=nrow(key_3$dtm), ncol=ncol(key_3$dtm))

# Column names setting for match
colnames(Mat.WordDoc) <- colnames(key_3$dtm)

# keyword vector
Vec.Keyword <- as.vector(keyword_3)



# Match keyword column(Document-Term matrix) with keyword vector
Mat.KeyDoc <- matrix(0, length(Vec.Keyword), length(Vec.Keyword))

Mat.KeyDoc <- Mat.WordDoc[,match(Vec.Keyword, colnames(Mat.WordDoc))+1]

colnames(Mat.KeyDoc)<- c("구제역", 
                         "공급량", "공급부족", "관광산업", "관광산업소비량", "기준가격", "돼지갈비", "돼지고기", "생산감소",  
                         "미국", "삼겹살", "서비스업", "소비량", "물가안정", "유통", "시장", "시장점유율", "식품산업",
                         "수입가격규모", "우유값", "수입가격", "지역경제", "축산물", "축산업", "판매량", "한우고기",
                         "보상금", "관리본부", "예방대책","국무회의","지원대책",  "구청",  "지원금", "농림부","피해대책",
                         "오염", "수질오염", "처리시설",
                         "접종", "대비태세", "대응", "상황실")

# 1, 30, 14, 3, 4, 8

color <- c("azure4", 
           "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1",
           "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1",
           "brown1", "brown1", "brown1", "brown1", "brown1", 
           "deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue",
           "deepskyblue","deepskyblue",
           "chartreuse1","chartreuse1","chartreuse1",
           "gold","darkorchid1","darkorchid1","darkorchid1")



Vec.Keyword.Freq <- as.vector(colSums(Mat.KeyDoc))

Vec.Keyword.Freq[1] <- 8888
Vec.Keyword.Freq[30] <- 325
################# Co-Keyword Adjacency Matrix #################
adj <- matrix(0, ncol(Mat.KeyDoc), ncol(Mat.KeyDoc))

#Mat.KeyDoc[Mat.KeyDoc>1] <- 1
for( i in 1:(nrow(adj)-1) )
{
  for( j in i:(nrow(adj)-1) )
  {
    adj[i, j+1] <- sum( (Mat.KeyDoc[,i]!=0) & (Mat.KeyDoc[,j+1]!=0) )
  }
}
#colnames(adj) <- colnames(Vec.Keyword)
#rownames(adj) <- colnames(Vec.Keyword)

# build a graph from the Co-keyword Adjacency matrix
g <- graph.adjacency(adj, mode="undirected", weighted=T)

# remove loops
g <- simplify(g)

layout <- layout.star(g)
#layout <- layout_as_tree(g)

# igraph plot parameter setting
V(g)$label <- colnames(Mat.KeyDoc)

# Edge weight refine
weight <- E(g)$weight
weight[is.na(weight)] <- 1

# Vertex size refine
size <- Vec.Keyword.Freq
size[size<20] <- 3
size[size>6000] <- 18
size[size>3000] <- 15
size[size>2000] <- 13
size[size>1000] <- 11
size[size>500] <- 10
size[size>100] <- 8
size[size>50] <- 5
size[size>20] <- 3

# Vertex label dist refine
dist <- size
dist[dist>=12] <- 0
dist[dist==11] <- 0.8
dist[dist==10.5] <- 0.8
dist[dist==8] <- 0.7
dist[dist==5] <- 0.7
dist[dist==3] <- 0.7

# Offset labels a bit: nodes printed from +x-axis counter-clockwise
ord <- V(g)                                               # node order
theta <- seq(0, 2*pi-2*pi/(length(ord)-1), 2*pi/(length(ord)-1))  # angle
theta[theta>pi] <- -(2*pi - theta[theta>pi])              # convert to [0, pi]

#dist <- rep(c(0.4,0.4), length.out = 31)
#dist[1] <- 0
# Network visualization
png(filename="edit_net_3_no.png",  width=10000, height=7000)

plot(g, layout=layout,
     vertex.label = NA,
     #vertex.label.color = "black",
     #vertex.label.cex = 13.5,
     #vertex.label.degree = -theta,
     #vertex.label.dist = dist,
     vertex.size = size,
     vertex.color = color,
     
     vertex.frame.color = "white",
     edge.width = (weight/10+5),
     edge.color = "gray",
     #mark.groups = list(c(9:12),c(25:29)),
     #mark.col = c("slategray1", "darkolivegreen1")
)
dev.off()

E(g)[head(order(E(g)$weight, decreasing=TRUE), 30)]
E(g)$weight[head(order(E(g)$weight, decreasing=TRUE), 30)]
co.Key.Freq <- data.frame(Vec.Keyword[8], Vec.Keyword[11], Vec.Keyword[13], Vec.Keyword[29], Vec.Keyword[39], Vec.Keyword[9], Vec.Keyword[16])


