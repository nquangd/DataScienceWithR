require(data.table)
load("/Users/QD/datascience/C10/traintk1g.RData")
load("/Users/QD/datascience/C10/traintk2g.RData")
load("/Users/QD/datascience/C10/traintk3g.RData")
predictword <- function(input,tridisc = 0, bidisc = 0)
{
      Rprof(file = "profile.txt")
      input <- tolower(input)
      intext <- strsplit(input, split = " ")
      tl <- length(intext[[1]])
      # If 1 word 
      if ( tl < 2) {
            w_1 <- as.character(intext[[1]][tl])
            bigr <- traintk2g[w_1]
            ## Use datatable
            # datatable always sort the results
            # Used to calculate prob if needed
            #ungr <- traintraintk1g[w_1]
            #as.character(bigr[which.max(bigr$freq/ungr$freq),n])
            
            as.character(bigr$n[1:3])
      }
      # If 2 words
      else if ( tl >= 2) {
            w_1 <- as.character(intext[[1]][tl])
            w_2 <- as.character(intext[[1]][tl-1])
            w_1w_2 <- paste(w_2,w_1,sep = " ")
            bigr <- seen2grams(w_1,traintk2g, traintk1g, bidisc)
            seen3gr <- seen3grams(w_1w_2, traintk3g, traintk2g, tridisc)
            unseen3gr <- unseen3grams(w_1w_2, traintk3g, traintk2g, tridisc, traintk1g, seen3gr,bigr,bidisc)
            total3gr <- rbind(seen3gr,unseen3gr)
            as.character(total3gr$n[1:3])
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

# Combine
