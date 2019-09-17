library(devtools)
source_url('https://gist.github.com/menugget/7864454/raw/f698da873766347d837865eecfa726cdf52a6c40/plot.stream.4.R')


##################################
data <- read.table("timeline.txt")

x <- seq(nrow(data))
colnames(data) <- seq(5)


COLS <- c("brown1","deepskyblue", "chartreuse1", "gold","darkorchid1")

png("stream.png", unit="px", width=3400, height=1000)
plot.stream(x, data, axes=FALSE, center=FALSE, xlim=c(0, 50), xaxs="i", spar=1.4, frac.rand=1.0, col=COLS, border=3.9, lwd=0.1)
dev.off()

