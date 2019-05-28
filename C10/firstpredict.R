predictword <- function(n=NULL)
{
      tk3g <- ReadToken(3)
      head(tk3g)
}

ReadToken <- function(n) {
      if ((!exists("tk1g"))&(n ==1)) {
            temp <- read.csv("/Users/QD/datascience/C10/tk1g.csv")
            tk1g <- as.list(temp[,2])
            names(tk1g) <- temp[,1]
            return(tk1g)
      }
      if ((!exists("tk2g"))&(n ==2)) {
            temp <- read.csv("/Users/QD/datascience/C10/tk2g.csv")
            nn <- t(sapply(temp[,1], function(i) unlist(strsplit(as.character(i),"_"))))
            tk2g <- data.frame(ngram=nn[,2],freg=temp[,2])
            tk2g <- split(tk2g, f = seq(nrow(tk2g)))
            names(tk2g) <- nn[,1]
            return(tk2g)
      }
      if ((!exists("tk3g"))&(n ==3)) {
            temp <- read.csv("/Users/QD/datascience/C10/tk3g.csv")
            ii <- strsplit(as.character(temp[,1]),"_")
            te <- sapply(ii, function(j) length(j) >= 4)
            ii <- ii[-which(te==TRUE)]
            temp <- temp[-which(te==TRUE),]
            nn <- data.frame(matrix(unlist(ii), nrow=length(ii), byrow=T),stringsAsFactors=FALSE)
            tk3g <- data.frame(ngram=nn[,3],freg=temp[,2],stringsAsFactors=FALSE)
            tk3g <- split(tk3g, f = seq(nrow(tk3g)))
            names(tk3g) <- paste(nn[,1],nn[,2], collapse = " ")
            return(tk3g)
      }

}        

lapply(temp)

lapply(ii, function(i) i[3] = 2)
