
ReadToken <- function(n) {
      if ((!exists("tk1g"))&(n ==1)) {
            tk1g <- read.csv("/Users/QD/datascience/C10/tk1g.csv")
            
            names(tk1g) <- c("n","freq")
            write.csv(tk1g,"unigram.csv")
            #return(tk1g)
      }
      if ((!exists("tk2g"))&(n ==2)) {
            temp <- read.csv("/Users/QD/datascience/C10/tk2g.csv")
            ii <- strsplit(as.character(temp[,1]),"_")
            te <- sapply(ii, function(j) length(j) >= 3)
            ii <- ii[-which(te==TRUE)]
            temp <- temp[-which(te==TRUE),]
            nn <- data.table(matrix(unlist(ii), nrow=length(ii), byrow=T),stringsAsFactors=FALSE)
            #c1 <- apply(nn[,1:2],1,function(i) paste(i[1],i[2],collapse = " "))
            tk2g <- data.table(nn,freg=temp[,2],stringsAsFactors=FALSE)
            names(tk2g) <- c("n1","n","freq")
            write.csv(tk2g,"bigram.csv")
            #return(tk2g)
      }
      if ((!exists("tk3g"))&(n ==3)) {
            temp <- read.csv("/Users/QD/datascience/C10/tk3g.csv")
            ii <- strsplit(as.character(temp[,1]),"_")
            te <- sapply(ii, function(j) length(j) >= 4)
            ii <- ii[-which(te==TRUE)]
            temp <- temp[-which(te==TRUE),]
            nn <- data.table(matrix(unlist(ii), nrow=length(ii), byrow=T),stringsAsFactors=FALSE)
            c1 <- apply(nn[,1:2],1,function(i) paste(i[1],i[2],collapse = " "))
            tk3g <- data.table(nminus1=c1,n = nn[,3],freg=temp[,2],stringsAsFactors=FALSE)
            names(tk3g) <- c("n1","n","freq")
            write.csv(tk3g,"trigram.csv")
            #return(tk3g)
      }

}        
