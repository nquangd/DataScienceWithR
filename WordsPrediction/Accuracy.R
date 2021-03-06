require(data.table)
require(quanteda)
load("/Users/QD/datascience/C10/1stcleantk/cleantk1g.RData")
load("/Users/QD/datascience/C10/1stcleantk/cleantk2g.RData")
load("/Users/QD/datascience/C10/1stcleantk/cleantk3g.RData")
load("/Users/QD/datascience/C10/1stcleantk/cleantk4g.RData")
load("/Users/QD/datascience/C10/1stcleantk/cleantk5g.RData")
setkey(traintk1g,n)
setkey(traintk2g,n1)
setkey(traintk3g,n1)
setkey(traintk4g,n1)
setkey(traintk5g,n1)
# Load the tokenised crossvalidation data
#Tokenise
load("/Users/QD/datascience/C10/crosstokens.RData")
set.seed(1000)
trainsize <- 0.01   # Do not crosstrain on the whole cross validation
smp_size <- floor(trainsize * length(tkcdata))
train_ind <- sample(seq_len(length(tkcdata)), size = smp_size)
crosstraindata <- tkcdata[train_ind]
#seq_len(length(traindata))
# Remove short sentence (<3))

crosstraindata <- sapply(crosstraindata, function(i) {if (length(i)>=3) {return(i)} else {return(NULL)}})
short <- sapply(crosstraindata, function(i) {is.null(i)})
crosstraindata <- crosstraindata[!short]

disc <- seq(0.5,2,by =0.5)
crossvalidationacc <- function(numtime) {

                  #numtime <- floor(length(crosstraindata)*fraction)
                  pp5 <- val5(numtime, 0.5, 0.5, 0.5,target = 5)
                  pp4 <- val4(numtime, 0.5, 0.5, 0.5,target = 5)
                  pp3 <- val3(numtime, 0.5, 0.5, 0.5,target = 5)
                  sens <- c(numtime, numtime, numtime)
                  res <- data.frame(sentence = sens, fivegram = pp5,fourgram = pp4,trigram = pp3)
                  rownames(res) <- c("one","three","five")
                  
                  
                  save(res,file = "./accuracy345gramsLESSDATA.RData")
                  return(res)
}

val5 <- function(numtime,fourdisc =0 ,tridisc = 0 , bidisc = 0, target) {
      accu <- matrix(nrow = 3, ncol = numtime)
for (i in 1:numtime) {
      
      sentence <- crosstraindata[[i]]
      pbl <- matrix(nrow = 3, ncol = (length(sentence)-1))
      for (j in 1:(length(sentence)-1)){
            nextword <- sentence[j+1]
            print(nextword)
            if (j == 1) {
                  input <- sentence[j]
                  pre <- predictword5(input,fourdisc ,tridisc , bidisc)
                  #print(pre[1:5,])
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                        pbl[1,j] <- TRUE
                  }
                  else pbl[1,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                        pbl[2,j] <- TRUE
                  }
                  else pbl[2,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                        pbl[3,j] <- TRUE
                  }
                  else pbl[3,j] <- FALSE
            }
            else if (j == 2) {
                  input <- paste(sentence[j-1],sentence[j],sep =" ")
                  pre <- predictword5(input,fourdisc ,tridisc , bidisc)
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                        pbl[1,j] <- TRUE
                  }
                  else pbl[1,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                        pbl[2,j] <- TRUE
                  }
                  else pbl[2,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                        pbl[3,j] <- TRUE
                  }
                  else pbl[3,j] <- FALSE
            }
            
            else if (j ==3) {
                  input <- paste(sentence[j-2],sentence[j-1],sentence[j],sep =" ")
                  pre <- predictword5(input,fourdisc ,tridisc , bidisc)
                  #print(pre[1:5,])
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                        pbl[1,j] <- TRUE
                  }
                  else pbl[1,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                        pbl[2,j] <- TRUE
                  }
                  else pbl[2,j] <- FALSE
                  
                  if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                        pbl[3,j] <- TRUE
                  }
                  else pbl[3,j] <- FALSE
            }
            
            
            else {
            input <- paste(sentence[j-3],sentence[j-2],sentence[j-1],sentence[j],sep =" ")
            pre <- predictword5(input,fourdisc ,tridisc , bidisc)
            #print(pre[1:5,])
            if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                  pbl[1,j] <- TRUE
            }
            else pbl[1,j] <- FALSE
            
            if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                  pbl[2,j] <- TRUE
            }
            else pbl[2,j] <- FALSE
            
            if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                  pbl[3,j] <- TRUE
            }
            else pbl[3,j] <- FALSE
            }
      #print(pbl[j])      
      }
      
      accu[1,i] <- sum(pbl[1,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
      accu[2,i] <- sum(pbl[2,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
      accu[3,i] <- sum(pbl[3,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
      
}
      meanacc <- apply(accu,1,mean)
      return(meanacc)
}

val4 <- function(numtime,fourdisc =0 ,tridisc = 0 , bidisc = 0, target) {
      accu <- matrix(nrow = 3, ncol = numtime)
      for (i in 1:numtime) {
            
            sentence <- crosstraindata[[i]]
            pbl <- matrix(nrow = 3, ncol = (length(sentence)-1))
            for (j in 1:(length(sentence)-1)){
                  nextword <- sentence[j+1]
                  print(nextword)
                  if (j == 1) {
                        input <- sentence[j]
                        pre <- predictword4(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  else if (j == 2) {
                        input <- paste(sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword4(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  
                  else if (j ==3) {
                        input <- paste(sentence[j-2],sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword4(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  
                  
                  else {
                        input <- paste(sentence[j-3],sentence[j-2],sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword4(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  #print(pbl[j])      
            }
            
            accu[1,i] <- sum(pbl[1,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            accu[2,i] <- sum(pbl[2,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            accu[3,i] <- sum(pbl[3,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            
      }
      meanacc <- apply(accu,1,mean)
      return(meanacc)
}

val3 <- function(numtime,fourdisc =0 ,tridisc = 0 , bidisc = 0, target) {
      accu <- matrix(nrow = 3, ncol = numtime)
      for (i in 1:numtime) {
            sentence <- crosstraindata[[i]]
            pbl <- matrix(nrow = 3, ncol = (length(sentence)-1))
            
            for (j in 1:(length(sentence)-1)){
                  nextword <- sentence[j+1]
                  print(nextword)
                  if (j == 1) {
                        input <- sentence[j]
                        pre <- predictword3(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  else if (j == 2) {
                        input <- paste(sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword3(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  
                  else if (j ==3) {
                        input <- paste(sentence[j-2],sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword3(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  
                  
                  else {
                        input <- paste(sentence[j-3],sentence[j-2],sentence[j-1],sentence[j],sep =" ")
                        pre <- predictword3(input,fourdisc ,tridisc , bidisc)
                        #print(pre[1:5,])
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-4)])) {
                              pbl[1,j] <- TRUE
                        }
                        else pbl[1,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:(target-2)])) {
                              pbl[2,j] <- TRUE
                        }
                        else pbl[2,j] <- FALSE
                        
                        if ((nextword %in% pre[order(-prob)]$n[1:target])) {
                              pbl[3,j] <- TRUE
                        }
                        else pbl[3,j] <- FALSE
                  }
                  #print(pbl[j])      
            }
            
            accu[1,i] <- sum(pbl[1,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            accu[2,i] <- sum(pbl[2,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            accu[3,i] <- sum(pbl[3,2:dim(pbl)[2]])/(dim(pbl)[2]-1)*100
            
      }
      meanacc <- apply(accu,1,mean)
      return(meanacc)
}

predictword5 <- function(input,fourdisc =0,tridisc = 0, bidisc = 0) {
      
      input <- tolower(input)
      intext <- strsplit(input, split = " ")
      tl <- length(intext[[1]])
      
      search5grams <- c(1)
      search4grams <- c(1)
      search3grams <- c(1)
      
      if (tl>3) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_3 <- as.character(intext[[1]][tl-2])
            w_4 <- as.character(intext[[1]][tl-3])
            w_1w_2w_3w_4 <- paste(w_4,w_3,w_2,w_1,sep = " ")
            seen5gr <- seen5grams(w_1w_2w_3w_4, traintk5g,traintk4g)
            
            if (!is.na(seen5gr$n[1])){
                return(seen5gr)  
            }
            else search5grams <- NULL
            
      }
      
      
      if ((tl == 3)|(is.null(search5grams))) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_3 <- as.character(intext[[1]][tl-2])
            w_1w_2w_3 <- paste(w_3,w_2,w_1,sep = " ")
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            
            seen4gr <- seen4grams(w_1w_2w_3, traintk4g,traintk3g, fourdisc, tridisc)
            if (!is.na(seen4gr$n[1])){
            
            bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
            trigr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
            unseen4gr <- unseen4grams(w_1w_2w_3, traintk4g,traintk3g, traintk2g, traintk1g, fourdisc, tridisc, bidisc, seen4gr, trigr, bigr)
            total4gr <- rbind(seen4gr,unseen4gr)
            return(total4gr)
             # Print for the prediction the first 3 words
            #print(as.character(total4gr$n[1:3]))
            
            #Calculate the perplexity
            
            
            }
            else search4grams <- NULL
      }
      
      if ((tl ==2)|(is.null(search4grams))) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            
            seen3gr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
            if (!is.na(seen3gr$n[1])) {
            bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
            unseen3gr <- unseen3grams(w_1w_2, traintk3g, traintk2g, tridisc, traintk1g, seen3gr,bigr,bidisc)
            
            total3gr <- rbind(seen3gr,unseen3gr)
            #print(as.character(total3gr$n[1:3]))
            return(total3gr)
            }
            else search3grams <- NULL
      }
      # If 1 word 
      if (( tl < 2)|(is.null(search3grams))) {
            w_1 <- as.character(intext[[1]][tl])
            bigr <- seen2grams(w_1, traintk2g, traintk1g, bidisc)
            
            unseen2gr <- unseen2grams(w_1, traintk2g, traintk1g, bigr, bidisc)
            bigr <- rbind(bigr,unseen2gr)
            if (!is.na(bigr$n[1])) {
            return(bigr)
            }
            else {
                  nogram <- traintk1g
                  nogram <- nogram[,prob:=nogram$freq/sum(nogram$freq)]
                  return(nogram)
                  
            }
                        
      }
      
}

predictword4 <- function(input,fourdisc =0,tridisc = 0, bidisc = 0) {
      
      input <- tolower(input)
      intext <- strsplit(input, split = " ")
      tl <- length(intext[[1]])
      
      search4grams <- c(1)
      search3grams <- c(1)
      
      if (tl > 2) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_3 <- as.character(intext[[1]][tl-2])
            w_1w_2w_3 <- paste(w_3,w_2,w_1,sep = " ")
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            
            seen4gr <- seen4grams(w_1w_2w_3, traintk4g,traintk3g, fourdisc, tridisc)
            if (!is.na(seen4gr$n[1])){
                  
                  bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
                  trigr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
                  unseen4gr <- unseen4grams(w_1w_2w_3, traintk4g,traintk3g, traintk2g, traintk1g, fourdisc, tridisc, bidisc, seen4gr, trigr, bigr)
                  total4gr <- rbind(seen4gr,unseen4gr)
                  return(total4gr)
                  # Print for the prediction the first 3 words
                  #print(as.character(total4gr$n[1:3]))
                  
                  #Calculate the perplexity
                  
                  
            }
            else search4grams <- NULL
      }
      
      if ((tl ==2)|(is.null(search4grams))) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            
            seen3gr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
            if (!is.na(seen3gr$n[1])) {
                  bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
                  unseen3gr <- unseen3grams(w_1w_2, traintk3g, traintk2g, tridisc, traintk1g, seen3gr,bigr,bidisc)
                  
                  total3gr <- rbind(seen3gr,unseen3gr)
                  #print(as.character(total3gr$n[1:3]))
                  return(total3gr)
            }
            else search3grams <- NULL
      }
      # If 1 word 
      if (( tl < 2)|(is.null(search3grams))) {
            w_1 <- as.character(intext[[1]][tl])
            bigr <- seen2grams(w_1, traintk2g, traintk1g, bidisc)
            
            unseen2gr <- unseen2grams(w_1, traintk2g, traintk1g, bigr, bidisc)
            bigr <- rbind(bigr,unseen2gr)
            if (!is.na(bigr$n[1])) {
                  return(bigr)
            }
            else {
                  nogram <- traintk1g
                  nogram <- nogram[,prob:=nogram$freq/sum(nogram$freq)]
                  return(nogram)
                  
            }
            
      }
      
}

predictword3 <- function(input,fourdisc =0,tridisc = 0, bidisc = 0) {
      
      input <- tolower(input)
      intext <- strsplit(input, split = " ")
      tl <- length(intext[[1]])
      
      
      search3grams <- c(1)
      
      
      if (tl > 1) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            
            seen3gr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
            if (!is.na(seen3gr$n[1])) {
                  bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
                  unseen3gr <- unseen3grams(w_1w_2, traintk3g, traintk2g, tridisc, traintk1g, seen3gr,bigr,bidisc)
                  
                  total3gr <- rbind(seen3gr,unseen3gr)
                  #print(as.character(total3gr$n[1:3]))
                  return(total3gr)
            }
            else search3grams <- NULL
      }
      # If 1 word 
      if (( tl < 2)|(is.null(search3grams))) {
            w_1 <- as.character(intext[[1]][tl])
            bigr <- seen2grams(w_1, traintk2g, traintk1g, bidisc)
            
            unseen2gr <- unseen2grams(w_1, traintk2g, traintk1g, bigr, bidisc)
            bigr <- rbind(bigr,unseen2gr)
            if (!is.na(bigr$n[1])) {
                  return(bigr)
            }
            else {
                  nogram <- traintk1g
                  nogram <- nogram[,prob:=nogram$freq/sum(nogram$freq)]
                  return(nogram)
                  
            }
            
      }
      
}

seen3grams <- function(w_1w_2, trigrams, bigrams, tridisc) {
            trigr <- trigrams[w_1w_2]
            w_1 <- strsplit(w_1w_2,split = " ")[[1]][2]
            w_2 <- strsplit(w_1w_2,split = " ")[[1]][1]
            bigr <- bigrams[n == w_1 & n1 == w_2]
            trigr <- trigr[, prob := (trigr$freq-tridisc)/bigr$freq]
}
seen2grams <- function(w_1, bigrams, unigrams, bidisc) {
      bigr <- bigrams[w_1]
      uigr <- unigrams[w_1]
      bigr <- bigr[, prob := (bigr$freq-bidisc)/uigr$freq]
      return(bigr)

      
}
seen4grams <- function(w_1w_2w_3, fourgrams,trigrams, fourdisc, tridisc) {
      fourgr <- fourgrams[w_1w_2w_3]
      w_1 <- strsplit(w_1w_2w_3,split = " ")[[1]][3]
      w_2 <- strsplit(w_1w_2w_3,split = " ")[[1]][2]
      w_3 <- strsplit(w_1w_2w_3,split = " ")[[1]][1]
      w_2w_3 <- paste(w_3,w_2,sep = " ")
      trigr <- trigrams[n == w_1 & n1 == w_2w_3]
      fourgr <- fourgr[, prob := (fourgr$freq-fourdisc)/trigr$freq]
}

seen5grams <- function(w_1w_2w_3w_4, fivegrams, fourgrams) {
      fivegr <- fourgrams[w_1w_2w_3w_4]
      w_1 <- strsplit(w_1w_2w_3w_4,split = " ")[[1]][4]
      w_2 <- strsplit(w_1w_2w_3w_4,split = " ")[[1]][3]
      w_3 <- strsplit(w_1w_2w_3w_4,split = " ")[[1]][2]
      w_4 <- strsplit(w_1w_2w_3w_4,split = " ")[[1]][1]
      w_2w_3w_4 <- paste(w_4,w_3,w_2,sep = " ")
      fourgr <- fourgrams[n == w_1 & n1 == w_2w_3w_4]
      fivegr <- fivegr[, prob := (fivegr$freq)/fourgr$freq]
}

unseen2grams <- function(w_1, bigrams, unigrams, obs2gr, bidisc) {
     
      alpha2 <- 1- sum(obs2gr$prob)
      
      # Get words from the unigram that are not in the seen unigrams (tailword)
      unseentail <- unigrams[!(n %in% obs2gr$n)]

      unobs2g <- unseentail[,prob:= alpha2*unseentail$freq/sum(unseentail$freq)]
      unobs2g <- unobs2g[,n1:=w_1]
      unobs2g <- setcolorder(unobs2g,c("n1","n","freq","prob"))
}
unseen3grams <- function(w_1w_2, trigrams, bigrams, tridisc, unigrams, obs3gr, bigr, bidisc) {
            
            # Calculate alpha, i.e. mass for unseen bigrams taken from seen bigrams
            # This is bigrams that starts with the w_1, not the unseentail word
            w_1 <- strsplit(w_1w_2,split = " ")[[1]][2]
            
            
            # All bigrams that start with w_1
            
            alpha2 <- 1- sum(bigr$prob)
            
            # Get words from the unigram that are not in the seen unigrams (tailword)
            unseentail <- unigrams[!(n %in% obs3gr$n)]
            
            # Get the seen bigrams that contained the unseen trigrams tailword
            obs2gr <- bigr[n %in% unseentail$n]
            obs2gr <- obs2gr[,prob:=(obs2gr$freq-bidisc)/unigrams[w_1]$freq]
            
            # Unseen bigrams with the trigrams tail words
            unobs2g <- unseentail[!(n %in% obs2gr$n)]
            
            # Get the unigrams that contain unseen bigrams tail word
            freq <- unigrams[n %in% unobs2g$n]$freq
            unobs2g <- unobs2g[,prob:= alpha2*unigrams[n %in% unobs2g$n]$freq/sum(freq)]
            unobs2g <- unobs2g[,n1:=w_1]
            unobs2g <- setcolorder(unobs2g,c("n1","n","freq","prob"))
            
            # Calculate alpha3
            alpha3 <- 1- sum(obs3gr$prob)
            
            # Calculate unseen trigrams backed off probability
            allbigr <- rbind(obs2gr,unobs2g)
            unobs3g <- allbigr[,prob:= alpha3*allbigr$prob/sum(allbigr$prob)]
            unobs3g <- unobs3g[,n1:=w_1w_2]
}

unseen4grams <- function(w_1w_2w_3, fourgrams, trigrams, bigrams, unigrams, fourdisc, tridisc, bidisc, obs4gr, trigr, bigr) {
      
      # Calculate alpha, i.e. mass for unseen bigrams taken from seen bigrams
      # This is bigrams that starts with the w_1, not the unseentail word
      w_1 <- strsplit(w_1w_2w_3,split = " ")[[1]][3]
      w_2 <- strsplit(w_1w_2w_3,split = " ")[[1]][2]
      w_1w_2 <- paste(w_2,w_1,sep =" ")
      # All bigrams that start with w_1
      
      alpha2 <- 1- sum(bigr$prob)
      
      # Get words from the unigram that are not in the seen 4-grams (tailword)
      unseentail4gr <- unigrams[!(n %in% obs4gr$n)]
      
      # Detemine which of these words are seen 3-grams
      # trigr are all seen threegrams with w1w2, the probability has been calculated already
      
      obs3gr <- trigr[n %in% unseentail4gr$n]
      #obs3gr <- obs3gr[,prob:=(obs3gr$freq-tridisc)/bigrams[n == w_1 & n1 == w_2]$freq]
      
      # Ge the tailword that are not in seen trigrams
      unseentail <- unseentail4gr[!(n %in% obs3gr$n)]
      
      
      # Get the seen bigrams that contained the unseen trigrams tailword
      obs2gr <- bigr[n %in% unseentail$n]
      #obs2gr <- obs2gr[,prob:=(obs2gr$freq-bidisc)/unigrams[w_1]$freq]
      
      # Unseen bigrams with the trigrams tail words
      unobs2g <- unseentail[!(n %in% obs2gr$n)]
      
      #unobs2g <- unseentail[,prob:= alpha2*unseentail$freq/sum(unseentail$freq)]
      #print(unobs2g[n == "scholar"])
      # Get the unigrams that contain unseen bigrams tail word
      freq <- unigrams[n %in% unobs2g$n]$freq
      unobs2g <- unobs2g[,prob:= alpha2*unigrams[n %in% unobs2g$n]$freq/sum(freq)]
      
      unobs2g <- unobs2g[,n1:=w_1]
      unobs2g <- setcolorder(unobs2g,c("n1","n","freq","prob"))
      # Calculate alpha3
      alpha3 <- 1- sum(trigr$prob)
      
      # Calculate unseen trigrams backed off probability
      allbigr <- rbind(obs2gr,unobs2g)
      unobs3g <- allbigr[,prob:= alpha3*allbigr$prob/sum(allbigr$prob)]
      unobs3g <- unobs3g[,n1:=w_1w_2]
      
      # Observed 3-grams
      
      
      alltrigr <- rbind(obs3gr,unobs3g)
      
      alpha4 <- 1- sum(obs4gr$prob)
      
      unobs4g <- alltrigr[,prob:= alpha4*alltrigr$prob/sum(alltrigr$prob)]
      
      unobs4g <- unobs4g[,n1:=w_1w_2w_3]
}


# Combine
