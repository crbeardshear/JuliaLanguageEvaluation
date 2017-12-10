require("ggplot2")
tests <- vector(mode = 'list', length = 100)
system("/bin/bash genData.sh")
average = read.table("output.txt", header=F)
maxV = read.table("output.txt", header=F)
minV = read.table("output.txt", header=F)
for(i in 1:100) {
	tests[[i]] <- read.table("output.txt", header=F)
	average <- (average + tests[[i]])
	for(j in 1:7) {
		maxV[j,3] <- max(maxV[j,3],tests[[i]][j,3])
		maxV[j,2] <- max(maxV[j,2],tests[[i]][j,2])
		minV[j,3] <- min(minV[j,3],tests[[i]][j,3])
		minV[j,2] <- min(minV[j,2],tests[[i]][j,2])
	}
	system("rm output.txt")
	system("/bin/bash genData.sh")
	print(average)
}
average <- average/100
system("rm output.txt")


plot <- ggplot(average, aes(x = average[,1])) +
 geom_line(aes(y = average[,2], colour = 'Average')) +
 geom_line(aes(y = average[,3], colour = 'Average' ), linetype="dotted") +
 geom_line(aes(y = maxV[,2], colour = 'Max')) +
 geom_line(aes(y = maxV[,3], colour = 'Max' ), linetype="dotted") +
 geom_line(aes(y = minV[,2], colour = 'Min')) +
 geom_line(aes(y = minV[,3], colour = 'Min' ), linetype="dotted") + 
 labs(size="Values", x = "N", y = "Seconds", title = "Time tests of Julia vs MPI Code on a local machine") + scale_x_log10()

