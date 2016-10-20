# Sherlock Word Cloud miningsherlock.R
# Author: Mick Guy
# Ref: Basic Text Mining in R https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

library(tm)
library(wordcloud)   
library(plotly)

# Create list of books for multi-select input "Choose a Book" in ui.R
sherlock.books <<- list.files(path="./books", pattern = "pdf$") 

# output$cloud in server.R reactively sends list of books chosen in ui.R
# pdf's loaded from books directory
makeWordCloud <- function(book){
  Rpdf <- readPDF(engine=c("xpdf"),control = list(text = "-layout"))
  book.path <- paste("./books/", book, sep="" )
  docs <- Corpus(URISource(book.path), readerControl = list(reader = Rpdf))
  docs <- tm_map(docs, content_transformer(function(x) iconv(enc2utf8(x), sub = "byte")))
  docs <- tm_map(docs, removePunctuation)
  docs <- tm_map(docs, removeNumbers) 
  docs <- tm_map(docs, tolower)  
  docs <- tm_map(docs, removeWords, stopwords("english"))
  docs <- tm_map(docs, removeWords, c("and", "but", "for", "had", "have", "his", "mr.", "not", "said","that", "the", "was", "with", "you", "will", "upon", "little", "see", "well"))   
  docs <- tm_map(docs, removeWords, c("can", "come", "done", "every", "good", "might", "must", "now", "put", "say", "took", "small", "asked", "answered", "just", "know", "thought", "left", "remarked"))
  docs <- tm_map(docs, removeWords, c("much", "shall", "never", "yes", "sir", "heard", "right", "nothing", "day", "morning", "first"))
  docs <- tm_map(docs, removeWords, c("came", "made", "may", "men", "quite", "think", "way", "whole", "always", "started", "though", "ever", "however", "dont", "comes", "sure", "since"))
  docs <- tm_map(docs, removeWords, c("seen", "yet", "twice", "five", "seemed", "went", "something", "whether", "really", "another", "suddenly", "behind", "told", "enough", "dear", "doubt"))
  docs <- tm_map(docs, removeWords, c("yes", "rather", "looked", "without", "matter", "still", "indeed", "back", "front", "look", "make", "side", "tell", "end", "like", "take", "away"))
  docs <- tm_map(docs, removeWords, c("let", "ing", "got", "great", "anything", "call", "many", "else", "get", "also", "looking", "already", "better", "lay", "going", "hardly", "less", "turned", "oclock", "either"))
  
  docs <- tm_map(docs, stripWhitespace)  
  docs <- tm_map(docs, PlainTextDocument) 
 
  dtm <- DocumentTermMatrix(docs)
  freq <- colSums(as.matrix(dtm))   
  dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
  freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
  return(freq)
}




# Parse out text input words with their corresponding frequency into a dataframe
# Called in the render plot function
str.split.to.columns <- function(textstring){
  if(length(textstring) > 0){
    nums <- as.vector(str_extract_all(textstring, pattern="([0-9]+)"))
    words <- as.vector(str_extract_all(textstring, pattern="[a-zA-Z]+([:space:]*[a-zA-Z])*+"))
  } else {
    return(NULL)
  }
 
  if(length(nums[[1]]) != length(words[[1]])){
    # Something is wrong, the count of frequencies do not match the word count
    return(NULL)
  } else {
    
    tmp.frame <- data.frame(freq=as.integer(nums[[1]]), words=words[[1]], stringsAsFactors = FALSE)
    return(tmp.frame)
  }
  
  
}


