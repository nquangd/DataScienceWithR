# To create a sample data file
set.seed(1000)
#cntblg <- file("/Users/QD/datascience/C10/final/en_US/en_US.blogs.txt","r")
#blg <- readLines(cntblg)
#close(cntblg)
#cntnew <- file("/Users/QD/datascience/C10/final/en_US/en_US.news.txt","r")
#new <- readLines(cntnew)
#close(cntnew)
cnttwt <- file("/Users/QD/datascience/C10/final/en_US/en_US.twitter.txt","r")
twt <- readLines(cnttwt)
close(cnttwt)
#print(length(twt))
#print(c(max(nchar(blg)),max(nchar(new))))
#new <- NULL
#blg <- NULL
#print(sum(sapply(twt,FUN = function(x) {
#      grepl("love",x, ignore.case = F)
#      }
#      ))/sum(sapply(twt,FUN = function(x) {
#            grepl("hate",x, ignore.case = F)
#      }
#      )))

res <- sapply(twt,FUN = function(x) grepl("biostats",x))
print(res[res == TRUE])

res <- sapply(twt,FUN = function(x) grepl("A computer once beat me at chess, but it was no match for me at kickboxing",x))
print(sum(res))
