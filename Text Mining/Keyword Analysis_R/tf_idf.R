tfidf <- function(mat)
{
  tf <- mat
  
  id = function(col){sum(!col==0)}
  
  idf <- log(nrow(mat)/apply(mat, 2, id))
  tfidf <- mat
  
  for(word in names(idf))
  {
    tfidf[,word] <- tf[,word] * idf[word]
  }
  
  return(tfidf)
}