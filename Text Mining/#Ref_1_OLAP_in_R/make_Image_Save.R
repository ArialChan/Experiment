pal <- brewer.pal(10, "Paired")
############################ Time - Keyword ############################
#Era - Rank1
windows(36,25)
barplot(ER1, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = c("Dark Turquoise", "Goldenrod","Brown"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(ER1))+10), cex.names=0.7,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\ER1",type="png")

#Period - Rank2
windows(36,25)
x<-barplot(PR2, main = "Time - Keyword Analysis", ylab="count",
           col = c("Dark Turquoise", "Goldenrod","Brown","Violet","Royal blue","Yellow"), 
           beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(PR2))+10), cex.names=0.6,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\PR2",type="png")

#Year - Rank3
windows(36,25)
barplot(YR3, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(YR3))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\YR3",type="png")


#Era - Rank2
windows(16,9)
barplot(ER2, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = c("Dark Turquoise", "Goldenrod","Brown"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(ER2))+10), cex.names=0.6,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\ER2",type="png")

#Era - Rank3
windows(16,9)
barplot(ER3, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = c("Dark Turquoise", "Goldenrod","Brown"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(ER3))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\ER3",type="png")

#Period - Rank1
windows(16,9)
barplot(PR1, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(PR1))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\PR1",type="png")

#Period - Rank3
windows(16,9)
barplot(PR3, main = "Time - Keyword Analysis", xlab="Topic", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(PR3))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\PR3",type="png")

pal <- brewer.pal(10, "Paired")
############################ Time - Keyword Pivoting ############################
#Rank1 - Era
windows(16,9)
barplot(R1E, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R1E))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R1E",type="png")

#Rank2 - Period
windows(16,9)
barplot(R2P, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R2P))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R2P",type="png")

#Rank3 - Year
windows(16,9)
barplot(R3Y, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R3Y))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R3Y",type="png")

#Rank2 - Era
windows(16,9)
barplot(R2E, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R2E))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R2E",type="png")

#Rank3 - Era
windows(16,9)
barplot(R3E, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R3E))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R3E",type="png")


#Rank1 - Period
windows(16,9)
barplot(R1P, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R1P))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R1P",type="png")

#Rank3 - Period
windows(16,9)
barplot(R3P, main = "Time - Keyword Analysis", xlab="Time", ylab="count",
        col = pal, 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R3P))+10), cex.names=0.7,angle=0,xaxs="i",yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R3P",type="png")

############################ Time - Type ############################
#Era - Global
windows(16,9)
barplot(EG, main="Time - Type Analysis", xlab="Type", ylab="count",
        col = c("Brown","Violet","Royal blue"),
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(EG))+10), cex.names=0.9,
        names.arg=c("국내", "국제"), 
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\EG",type="png")
#Period - Type
windows(16,9)
barplot(PT, main="Time - Type Analysis", xlab="Type", ylab="count",
        col = c("Dark Turquoise", "Goldenrod","Brown","Violet","Royal blue"),
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(PT))+10), cex.names=0.9,
        names.arg=c("국내학술대회","국내논문지", "국제학술대회","국제논문지"), 
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\PT",type="png")

#Year - Type
windows(16,9)
barplot(YT, main="Time - Type Analysis", xlab="Type", ylab="count",
        col = pal,
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(YT))+10), cex.names=0.9,
        names.arg=c("국내학회","국내저널", "국제학회","국제저널"), 
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\YT",type="png")

############################ Time - Type Pivoting ############################
#Global - Era
windows(16,9)
barplot(GE, main="Time - Type Analysis", xlab="Time", ylab="count",
        col = c("Brown","Violet"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(GE))+10), cex.names=0.9,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내", "국제"), fill = c("Brown","Violet"))
savePlot("C:\\APM_Setup\\htdocs\\GE",type="png")

#Type - Period
windows(16,9)
barplot(TP, main="Time - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet", "Goldenrod", "Royal blue"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(TP))+10), cex.names=0.9,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내학회","국내저널", "국제학회","국제저널"), fill = c("Brown","Violet", "Goldenrod", "Royal blue"))
savePlot("C:\\APM_Setup\\htdocs\\TP",type="png")

#Type - Year
windows(16,9)
barplot(TY, main="Time - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet", "Goldenrod", "Royal blue"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(TY))+10), cex.names=0.9,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내학회","국내저널", "국제학회","국제저널"), fill = c("Brown","Violet", "Goldenrod", "Royal blue"))
savePlot("C:\\APM_Setup\\htdocs\\TY",type="png")


############################ Keyword - Type ############################
#Global - Rank1
windows(16,9)
barplot(GR1, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(GR1))+10), cex.names=0.9,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내", "국제"), fill = c("Brown","Violet"))
savePlot("C:\\APM_Setup\\htdocs\\GR1",type="png")


#Type - Rank2
windows(16,9)
barplot(TR2, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet", "Goldenrod", "Royal blue"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(TR2))+10), cex.names=0.6,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내학회","국내저널", "국제학회","국제저널"), fill = c("Brown","Violet", "Goldenrod", "Royal blue"))
savePlot("C:\\APM_Setup\\htdocs\\TR2",type="png")

#Type - Rank3
windows(16,9)
barplot(TR3, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet", "Goldenrod", "Royal blue"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(TR3))+10), cex.names=0.7,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내학회","국내저널", "국제학회","국제저널"), fill = c("Brown","Violet", "Goldenrod", "Royal blue"))
savePlot("C:\\APM_Setup\\htdocs\\TR3",type="png")

windows(16,9)
barplot(GR2, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col =  c("Brown","Violet"),
        beside=TRUE, xpd=TRUE, legend=FALSE, ylim = c(0, max(na.omit(GR2))+10), cex.names=0.6,
        xaxs="i", yaxs="r")
legend("topright",legend=c("국내", "국제"), fill = c("Brown","Violet"))
savePlot("C:\\APM_Setup\\htdocs\\GR2",type="png")

############################ Keyword - Type Pivoting############################

#Rank1 - Global
pal <- brewer.pal(7, "Paired")
windows(16,9)
barplot(R1G, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col = pal,names.arg=c("국내","국제"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R1G))+10), cex.names=0.8,
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R1G",type="png")

#Rank2 - Type
pal <- brewer.pal(22, "Set1")
windows(16,9)
barplot(R2T, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col = pal,names.arg=c("국내학회","국내저널","국제학회","국제저널"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R2T))+10), cex.names=0.8,
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R2T",type="png")

#Rank3 - Type
pal <- brewer.pal(22, "Dark1")
windows(16,9)
barplot(R3T, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col = pal,names.arg=c("국내학회","국내저널","국제학회","국제저널"), 
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R3T))+10), cex.names=0.8,
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R3T",type="png")

#Rank2 - Global
pal <- brewer.pal(22, "Dark1")
windows(16,9)
barplot(R2G, main="Topic - Type Analysis", xlab="Time", ylab="count",
        col = pal,names.arg=c("국내","국제"),
        beside=TRUE, xpd=TRUE, legend=TRUE, ylim = c(0, max(na.omit(R2G))+10), cex.names=0.8,
        xaxs="i", yaxs="r")
savePlot("C:\\APM_Setup\\htdocs\\R2G",type="png")
