Using N-grams model for next word predicting
========================================================
author: Duy Nguyen      
date: 2019-Jan-15
#autosize: true
width: 1440
height: 900

N-grams model
========================================================
n-gram is a contiguous sequence of n items from a given sample of text or speech.  

In this example: "You make me feel|...""  

      2-grams are: "You make", "make me", "me feel", "feel..."  

      So what is in "..."?  It coudld be "happy", "bad", "sad", etc.

From a dataset (a corpus, i.e. a collection of what people has written), N-grams model will calculate the possibility of each of the word "happy", "bad", "sad", etc. based on their frequency in the dataset.

The words with highest probability will be the prediction

Questions to consider: 
      How large is n? 3,4,5, or higher?
      
      How large is the dataset. In fact, a larger dataset would cover more n-grams have been used



The dataset & The approach
========================================================
The dataset was taken from 3 sources: Blog, News, and Tweets with the summary shown belown.  

The dataset is too large to be used entirely for a web application with memory and performance constraint.

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> Lines </th>
   <th style="text-align:right;"> Word </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Blog </td>
   <td style="text-align:right;"> 899288 </td>
   <td style="text-align:right;"> 37334131 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> News </td>
   <td style="text-align:right;"> 1010242 </td>
   <td style="text-align:right;"> 34372530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tweet </td>
   <td style="text-align:right;"> 2360148 </td>
   <td style="text-align:right;"> 30373545 </td>
  </tr>
</tbody>
</table>

APPROACH IN THIS WORK:
Develop the prediction tool based on: 

      Two different fractions of the dataset to compare accuracy versus speed

      5-grams, 4-grams, and 3-grams are evaluated and compared

      Katz backoff model to treat unseen n-grams


Performance
========================================================
<small>The Accuracy: starting from the first word, used the models to predict the next word in the sentence. This is done for 3,4,5-grams model and 2 datasets and 100 sentences. The answer is registered in three ways:  
      (eval = one, three, five):  The first (or One of the first 3 or 5) predicted word with highest probability matches the real next word  
As seen, the accuracy (shown below) varies from 17% to 37% depends on the evaluation methods, the n-grams models, and the size of the dataset  
The predicting speed has the same magnitude for all n-grams model</small>


```
  Data   Eval sentence fivegram fourgram trigram
1  20%    one      100    21.81    21.81   17.59
2  20%  three      100    30.91    30.91   27.36
3  20%   five      100    36.87    36.87   34.01
4  10%   one1      100    13.02    13.02   12.89
5  10% three1      100    22.49    22.49   21.98
6  10%  five1      100    27.62    27.62   27.55
```

```
  Data     Ngram user.self sys.self elapsed
1  20% Fivegrams     0.174    0.018   0.193
2  20% Fourgrams     0.151    0.015   0.167
3  20%  Trigrams     0.115    0.009   0.125
```

The Shinny Application
========================================================
Taken a text input, the shiny application returns 3 features:  
      (1) Suggestion of the word we are typing  
      (2) 5 suggestions for the next word  
      (3) A wordcloud shows what people have typed on this application  
![ex](appscreenshot.png)
