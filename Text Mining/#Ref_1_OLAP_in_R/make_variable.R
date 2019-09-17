#Time-Keyword
ER1 <- apply(research_cube, c("Era","Rank1"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
PR2 <- apply(research_cube, c("Period","Rank2"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
YR3 <- apply(research_cube, c("year","Rank3"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
ER2 <- apply(research_cube, c("Era","Rank2"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
ER3 <- apply(research_cube, c("Era","Rank3"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
PR1 <- apply(research_cube, c("Period","Rank1"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
PR3 <- apply(research_cube, c("Period","Rank3"), FUN=function(x) {return(sum(x, na.rm=TRUE))})

#Time-Keyword Pivoting
R1E <- apply(research_cube, c("Rank1","Era"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R2P <- apply(research_cube, c("Rank2","Period"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R3Y <- apply(research_cube, c("Rank3","year"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R2E <- apply(research_cube, c("Rank2","Era"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R3E <- apply(research_cube, c("Rank3","Era"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R1P <- apply(research_cube, c("Rank1","Period"), FUN=function(x) {return(sum(x, na.rm=TRUE))})
R3P <- apply(research_cube, c("Rank3","Period"), FUN=function(x) {return(sum(x, na.rm=TRUE))})

#Time-Type
EG <-apply(research_cube, c("Era","global"), FUN=function(x) {return (sum(x, na.rm=TRUE))})
PT <-apply(research_cube, c("Period","Type"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
YT <-apply(research_cube, c("year","Type"), FUN=function(x) {return(sum (x, na.rm=TRUE))})

#Time-Type Pivoting
GE <-apply(research_cube, c("global","Era"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
TP <-apply(research_cube, c("Type","Period"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
TY <-apply(research_cube, c("Type","year"), FUN=function(x) {return(sum (x, na.rm=TRUE))})

#Type-key
GR1 <-apply(research_cube, c("global","Rank1"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
TR2 <-apply(research_cube, c("Type","Rank2"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
TR3 <-apply(research_cube, c("Type","Rank3"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
GR2 <-apply(research_cube, c("global","Rank2"), FUN=function(x) {return(sum (x, na.rm=TRUE))})

#Type-key Pivoting
R1G <-apply(research_cube, c("Rank1","global"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
R2T <-apply(research_cube, c("Rank2","Type"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
R3T <-apply(research_cube, c("Rank3","Type"), FUN=function(x) {return(sum (x, na.rm=TRUE))})
R2G <-apply(research_cube, c("Rank2","global"), FUN=function(x) {return(sum (x, na.rm=TRUE))})