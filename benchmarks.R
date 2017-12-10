require("ggplot2")
tests <- vector(mode = 'list', length = 100)
system("/bin/bash genData.sh")
average = read.table("output.txt", header=F)
maxV = read.table("output.txt", header=F)
minV = read.table("output.txt", header=F)
for(i in 1:100) {
	tests[[i]] <- read.table("output.txt", header=F)
	average <- (average + tests[[i]])/2
	for(j in 1:7) {
		maxV[j,2] <- max(maxV[j,2],tests[[i]][j,2])
		maxV[j,1] <- max(maxV[j,1],tests[[i]][j,1])
		minV[j,2] <- min(minV[j,2],tests[[i]][j,2])
		minV[j,1] <- min(minV[j,1],tests[[i]][j,1])
	}	
	system("rm output.txt")
	system("/bin/bash genData.sh")
	print(average)
}
system("rm output.txt")

#datam <- read.table("mpioutput.txt".header=F)
plot <- ggplot(average, aes(x = average[,1])) 
+ geom_point(tests[[]][]) 
+ geom_line(aes(y = average[,2], color = 'red')) 
+ geom_line(aes(y = average[,3], color = 'blue' )) 
+ geom_line(aes(y = maxV[,2], color = 'green')) 
+ geom_line(aes(y = maxV[,3], color = 'turqoise' )) 
+ geom_line(aes(y = minV[,2], color = 'violet')) + 
+ geom_line(aes(y = minV[,3], color = 'maroon' )) + scale_x_log10()

for(i in 1:100) {
	geom_point(data = tests[[i]], aes(y = tests[[i]][,2],color = 'lavendar'))
	geom_point(data = tests[[i]], aes(y = tests[[i]][,3],color = 'lemon'))
}
