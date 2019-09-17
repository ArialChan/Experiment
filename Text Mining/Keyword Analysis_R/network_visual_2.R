
load("../results/key_2.R")
####################################################################################################################
## for early_keyword...

if(0)
{
  keyword_2 <- c("구제역", 
                 "공급량", "돼지갈비", "돼지고기", "소비량", "시장", "시장점유율", "지역경제",  "축산물", "쇠고기",
                 "관계장관", "구청", "농림부", "대비책",  "예방대책대책", "지원금",
                 "오염도", "지하수", "처리량", "처리시설", "축산폐수", "침출수", "핏물", 
                 "사태수습", "긴급복구", "대처", "매몰", "매몰지", "방문객", "방지", "백신량", "살처분",  "소독기", "현장검증","살포","상황실",
                 "강원도", "경북", "농장주", "서울동물원", "안정", "지역갈등", "확산세", "청원")
}

keyword_2 <- c("구제역", 
               "공급량", "돼지갈비", "돼지고기", "소비량", "시장", "시장점유율", "지역경제", "축산물","쇠고기",
               "관계장관", "구청", "농림부", "대비책",  "예방대책대책", "지원금",
               "오염도", "지하수", "처리량", "처리시설", "축산폐수", "침출수", "핏물", 
               "사태수습", "매몰", "매몰지", "긴급복구", "현장검증", "살처분","백신량",  
               "방문객", "방지", "대처",  "소독기", "살포","상황실")

# 1, 9, 7, 7, 13, 8
################# keyword - document matrix ################# 

# Document-Term matrix Copy from preprocessing function
Mat.WordDoc <- matrix(key_2$dtm, nrow=nrow(key_2$dtm), ncol=ncol(key_2$dtm))

# Column names setting for match
colnames(Mat.WordDoc) <- colnames(key_2$dtm)

# keyword vector
Vec.Keyword <- as.vector(keyword_2)



# Match keyword column(Document-Term matrix) with keyword vector
Mat.KeyDoc <- matrix(0, length(Vec.Keyword), length(Vec.Keyword))

Mat.KeyDoc <- Mat.WordDoc[,match(Vec.Keyword, colnames(Mat.WordDoc))+1]

colnames(Mat.KeyDoc)<- c("구제역", 
                         "공급량", "돼지갈비", "돼지고기", "소비량", "시장", "시장점유율", "지역경제", "축산물", "쇠고기",
                         "관계장관", "구청", "농림부", "대비책",  "예방대책", "지원금",
                         "오염도", "지하수", "처리량", "처리시설", "축산폐수", "침출수", "핏물", 
                         "사태수습", "매몰", "매몰지", "긴급복구", "현장검증", "살처분", "백신량",  
                         "방문객", "방지", "대처",  "소독기", "살포","상황실")
# 1, 9, 7, 7, 13, 8

color <- c("azure4", 
           "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1","brown1",    
           "deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue",
           "chartreuse1","chartreuse1","chartreuse1","chartreuse1","chartreuse1","chartreuse1","chartreuse1",
           "gold","gold","gold","gold","gold","gold", "gold","darkorchid1", "darkorchid1", "darkorchid1","darkorchid1","darkorchid1","darkorchid1")


Vec.Keyword.Freq <- as.vector(colSums(Mat.KeyDoc))
Vec.Keyword.Freq[1] <- 8888

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

center_index <- match("구제역", keyword_1)
layout <- layout.star(g, center=V(g)[center_index])
#layout <- layout_as_tree(g)

# igraph plot parameter setting
#V(g)$label <- colnames(Mat.KeyDoc)

# Edge weight refine
weight <- E(g)$weight
weight[is.na(weight)] <- 1

# Vertex size refine
size <- Vec.Keyword.Freq
size[size<20] <- 3
size[size>6000] <- 18
size[size>3000] <- 15
size[size>2000] <- 14
size[size>1000] <- 12
size[size>500] <- 11
size[size>100] <- 10.5
size[size>50] <- 8
size[size>20] <- 5

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
png(filename="edit_net_2_no.png",  width=8000, height=5000)

plot(g, layout=layout,
     vertex.label = NA,
     #vertex.label.color = "black",
     #vertex.label.cex = 8,
     #vertex.label.degree = -theta,
     #vertex.label.dist = dist,
     vertex.size = size,
     vertex.color = color,
     
     vertex.frame.color = "white",
     edge.width = (weight/13+5),
     edge.color = "gray"
     #mark.groups = list(c(9:12),c(25:29)),
     #mark.col = c("slategray1", "darkolivegreen1")
)
dev.off()


E(g)[head(order(E(g)$weight, decreasing=TRUE), 30)]
E(g)$weight[head(order(E(g)$weight, decreasing=TRUE), 30)]
co.Key.Freq <- data.frame(Vec.Keyword[24], Vec.Keyword[28], Vec.Keyword[25], Vec.Keyword[6], Vec.Keyword[14])

