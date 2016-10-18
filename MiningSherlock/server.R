# Sherlock Word Cloud server.R
# Author: Mick Guy

shinyServer(function(input, output, session) {
  
   output$cloud <- renderPlot({
     word.freq <- makeWordCloud(input$selection)
     words.dt <- data.frame(freq=word.freq, words=names(word.freq), stringsAsFactors = FALSE)
     custom.words <- ""
     if (length(input$text) > 0){
       custom.words <- str.split.to.columns(input$text)
       if(is.null(custom.words)){
         custom.words <- words.dt
       } else {
         custom.words <- rbind(words.dt, custom.words)
      }
     }
    
     wordcloud(custom.words[,2], custom.words[,1], min.freq=input$min.freq, max.words=input$max.words, random.color = TRUE, scale=c(6, .5), colors=brewer.pal(6, "Dark2"),rot.per=.3)   
     
     
    })
  
   
})
