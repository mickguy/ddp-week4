




Developing Data Products Week 4 Assignment
========================================================
title: Developing Data Products Week 4 Assignment
author: Mick Guy
date: October 19, 2016
autosize: true
css: styles.css

Sherlock Word Cloud
========================================================
type: exclaim


  ![wordcloud based on a Sherlock Holmes story](wordcloud_m.png)
  
  ***
  
  - A fun app to create word clouds from Sherlock Holmes stories.
  - Select a single story or multiple stories
  - Input custom words
  - Adjust the frequency of the words displayed.
  - Adjust the maximum number of words displayed 

Calculating the Term Document Matrix
========================================================
type: exclaim

The Term Document Matrix describes the frequency of terms that occur in a collection of documents. 

```r
table.frequent.terms <- function (tdm, min.freq=20, max.freq=Inf){
  ft <- findFreqTerms(tdm, lowfreq = min.freq , highfreq = max.freq)
  ft.tdm <- data.frame(as.matrix(tdm[ft,]))
  colnames(ft.tdm) <- c("Doc A", "Doc B", "Doc C", "Doc D")
  return(ft.tdm)
}
```


Term Document Matrix - Result
========================================================
type: exclaim

Columns correspond to documents in the collection and rows correspond to terms.

```r
table.frequent.terms(tdm, min.freq=40)
```

```
       Doc A Doc B Doc C Doc D
door       9    13    17     7
face      10    10    13     9
holmes    46    48    26    38
house      3    14    22     6
man       18    22    27    37
one       18    27    31    37
street    10    18     5    12
```

References 
========================================================
type: header

  Fork on Github    
  https://github.com/mickguy/ddp-week4   
  
  Basic Text Mining   
    http://bit.ly/1n0DxTE 
       
  UI Layout inspired by    
    http://shiny.rstudio.com/gallery/bus-dashboard.html   
     
  Frequency and Max Word Sliders inspired by   
    http://shiny.rstudio.com/gallery/word-cloud.html   
     
    
