# To create a sample data file
set.seed(1000)
cnt <- file("/Users/QD/datascience/C10/final/en_US/en_US.blogs.txt","r")
idx <- rbinom(1000,1,p=0.5)
#open(cnt)
sf <- NULL
rf <- NULL
for (i in 1:length(idx)) {
      if (idx[i] == 1) sf <- c(sf,readLines(cnt,2))
      else rf <- readLines(cnt,2)
}
test <<-sf
close(cnt)