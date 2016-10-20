# Sherlock Word Cloud pdfminer.R
# Author: Mick Guy
# Ref: Basic Text Mining in R https://rstudio-pubs-static.s3.amazonaws.com/31867_8236987cf0a8444e962ccd2aec46d9c3.html

library(tm)
library(SnowballC)
library(wordcloud)   


# Create a list of books from the directory
sherlock.books <- list.files(path="./MiningSherlock/books", pattern = "pdf$") 
Rpdf <- readPDF(engine=c("xpdf"),control = list(text = "-layout"))
book.paths <- paste("./MiningSherlock/books/", sherlock.books, sep="" )
# Read in the first 4 books in the directory
docs <- Corpus(URISource(book.paths[1:4]), readerControl = list(reader = Rpdf))
# Prep corpora for mining, remove unnecessary space, word etc.
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

# Create Term Document Matrix
tdm <- TermDocumentMatrix(docs, control = list(removePunctuation = TRUE,
                                                            stopwords = TRUE,
                                                            tolower = TRUE,
                                                            stemming = FALSE,
                                                            removeNumbers = TRUE,
                                                            bounds = list(global = c(3, Inf)))) 



# Takes a term document matrix and returns a dataframe of the frequency of terms that 
# occur in a collection of documents
table.frequent.terms <- function (tdm, min.freq=20, max.freq=Inf){
  ft <- findFreqTerms(tdm, lowfreq = min.freq , highfreq = max.freq)
  ft.tdm <- data.frame(as.matrix(tdm[ft,]))
  colnames(ft.tdm) <- c("Doc A", "Doc B", "Doc C", "Doc D")
  return(ft.tdm)
}



