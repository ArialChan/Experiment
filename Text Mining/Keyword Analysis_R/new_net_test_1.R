load("../results/key_1.R")

####################################################################################################################
## for early_keyword...


keyword_1 <- c( 
               "돼지고기", "농업소득", "축산농", "시장", "지역축협", "축산물", "쇠고기", "시장점유율", "농업소득", 
               "피해대책", "예방대책대책","농진청", "농림부", "경찰",  "당부", 
               "차량통제", "살처분", "비상방역체제방역체제", "대처", "대응", "상황실", "방문객",
               "발생지", "확인", "청원", "경상", "파악", "발굽", "관계자", "구청", "확산세", "농장주",  "양성반응", "속수무책", "예천", "강원도", "서울동물원", "안동")

# 1, 9, 8, 5, 16
################# keyword - document matrix ################# 

# Document-Term matrix Copy from preprocessing function
Mat.WordDoc <- matrix(key_1$dtm, nrow=nrow(key_1$dtm), ncol=ncol(key_1$dtm))

# Column names setting for match
colnames(Mat.WordDoc) <- colnames(key_1$dtm)

# keyword vector
Vec.Keyword <- as.vector(keyword_1)



# Match keyword column(Document-Term matrix) with keyword vector
Mat.KeyDoc <- matrix(0, length(Vec.Keyword), length(Vec.Keyword))

Mat.KeyDoc <- Mat.WordDoc[,match(Vec.Keyword, colnames(Mat.WordDoc))+1]

colnames(Mat.KeyDoc)<- c(
                         "돼지고기", "농업소득", "축산농가", "시장", "지역축협", "축산물", "쇠고기", "시장점유율", "농업소득", 
                         "피해대책", "예방대책", "농진청", "농림부", "경찰", "당부", 
                         "차량통제", "살처분", "비상방역체제", "대처", "대응", "상황실","방문객", 
                         "발생지", "확인", "청원", "경상도", "파악", "발굽", "관계자", "구청", "확산세", "농장주",  "양성반응", "속수무책", "예천", "강원도", "서울동물원", "안동")

# 1, 9, 8, 5, 16

color <- c( 
           "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", "brown1", 
           "deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue","deepskyblue",
           "darkorchid1","darkorchid1","darkorchid1","darkorchid1","darkorchid1","darkorchid1","darkorchid1",
           "cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3",
           "cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3","cornsilk3")


Vec.Keyword.Freq <- as.vector(colSums(Mat.KeyDoc))


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
layout <- layout.auto(g)
#layout <- layout_as_tree(g)

# igraph plot parameter setting
V(g)$label <- colnames(Mat.KeyDoc)

# Edge weight refine
weight <- E(g)$weight
weight[is.na(weight)] <- 1

E(g)[head(order(E(g)$weight, decreasing=TRUE), 20)]
co.Key.Freq <- data.frame(Vec.Keyword[25], Vec.Keyword[39], Vec.Keyword[18], Vec.Keyword[5], Vec.Keyword[36], Vec.Keyword[30], Vec.Keyword[4])

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


png(filename="test_net_1.png",  width=8000, height=5000)
plot(g, layout=layout,
     vertex.label = V(g)$label,
     vertex.label.color = "black",
     vertex.label.cex = 8,
     vertex.label.degree = -theta,
     vertex.label.dist = dist,
     vertex.size = size,
     vertex.color = color,
     
     vertex.frame.color = "white",
     edge.width = (weight/10+5),
     edge.color = "gray"
     #mark.groups = list(c(9:12),c(25:29)),
     #mark.col = c("slategray1", "darkolivegreen1")
)
dev.off()




