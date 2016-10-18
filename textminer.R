# Textmining pdfs

library(tm)
files <- list.files(pattern = "pdf$")
Rpdf <- readPDF(engine=c("xpdf"),control = list(text = "-layout"))
opinions <- Corpus(URISource(files), readerControl = list(reader = Rpdf))
opinions.tdm <- TermDocumentMatrix(opinions, control = list(removePunctuation = TRUE,
                                                            stopwords = TRUE,
                                                            tolower = TRUE,
                                                            stemming = TRUE,
                                                            removeNumbers = TRUE,
                                                            bounds = list(global = c(3, Inf)))) 
summary(opinions)
docs <- Corpus(URISource(files), readerControl = list(reader = Rpdf))
docs <- tm_map(docs, content_transformer(function(x) iconv(enc2utf8(x), sub = "byte")))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers) 
docs <- tm_map(docs, tolower)  

new.stop.words.1 <- c("and", "but", "for", "had", "have", "his", "mr.", "not", "said","that", "the", "was", "with", "you", "will", "upon", "little", "man", "one", "see", "well") 
new.stop.words.2 <- c("can", "come", "done", "every", "good", "might", "must", "now", "put", "say", "took", "small")
# docs <- tm_map(docs, removeWords, new.stop.words.1, new.stop.words.2, stopwords("english"))  
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("and", "but", "for", "had", "have", "his", "mr.", "not", "said","that", "the", "was", "with", "you", "will", "upon", "little", "see", "well"))   
docs <- tm_map(docs, removeWords, c("can", "come", "done", "every", "good", "might", "must", "now", "put", "say", "took", "small", "asked", "answered", "just", "know", "thought", "left", "remarked"))
docs <- tm_map(docs, removeWords, c("much", "shall", "never", "yes", "sir", "heard", "right", "nothing", "day", "morning", "first"))
docs <- tm_map(docs, removeWords, c("came", "made", "may", "men", "quite", "think", "way", "whole", "always", "started", "though", "ever", "however", "dont", "comes", "sure", "since"))
docs <- tm_map(docs, removeWords, c("seen", "yet", "twice", "five", "seemed", "went", "something", "whether", "really", "another", "suddenly", "behind", "told", "enough", "dear", "doubt"))
docs <- tm_map(docs, removeWords, c("yes", "rather", "looked", "without", "matter", "still", "indeed", "back", "front", "look", "make", "side", "tell", "end", "like", "take", "away"))
docs <- tm_map(docs, removeWords, c("let", "ing", "got", "great", "anything", "call", "many", "else", "get", "also", "looking", "already", "better", "lay", "going", "hardly", "less", "turned", "oclock", "either"))
# could use word clouds to inspire stories ie. make a story from the main words

# It might be interesting to see how many times he uses certain terms like "day", "morning" etc
# or descriptions such as eyes, face, hair, head etc.
# Do not use stemDocument if you don't want to lose the suffixes ie holm instead of holmes

# docs <- tm_map(docs, stemDocument)   
docs <- tm_map(docs, stripWhitespace)  
docs <- tm_map(docs, PlainTextDocument) 
dtm <- DocumentTermMatrix(docs)
inspect(dtm[1, 1:20])
tdm <- TermDocumentMatrix(docs) 
# inspect(tdm[1, 1:6])

freq <- colSums(as.matrix(dtm))   
length(freq)   
ord <- order(freq) 
dtms <- removeSparseTerms(dtm, 0.1) # This makes a matrix that is 10% empty space, maximum.   
inspect(dtms)  

findFreqTerms(dtms, lowfreq = 10, highfreq = Inf)
freq[head(ord)] 
freq[tail(ord)] 
head(table(freq), 10)   
tail(table(freq), 10)
freq <- colSums(as.matrix(dtms))   
freq   

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 140)

findFreqTerms(dtm, lowfreq=10)

wf <- data.frame(word=names(freq), freq=freq)   
tail(wf)
library(ggplot2)   
p <- ggplot(subset(wf, freq>8), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p 

library(wordcloud)   
set.seed(142)   
wordcloud(names(freq), freq, min.freq=7, random.color = TRUE, scale=c(5, .1), colors=brewer.pal(6, "Dark2"),rot.per=.3, use.r.layout=FALSE)   

findAssocs(dtm, c("adler", "wilson"), corlimit=0.98)
