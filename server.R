#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
#

library(shiny)
library(ggplot2)
library(ggmap)


load("tweet_sentiment.Rdata")
load("location.Rdata")

# Define server logic required to aquire tweets and conduct sentiment analysis
shinyServer(function(input, output) {

  ### Map
  output$map <- renderPlot({
    map <- ggmap(get_map(location = "US", zoom=4))
    mapPoints <- map +  geom_point(data = loc, aes(x = lon, y = lat, col = locname), size = 10,  alpha=0.8) + labs(col = "Tweeter Location")
    print(mapPoints)
  })
  
  ### Plot
  output$Plot <- renderPlot({
    if (input$plot_type == "sep")
    {
      p <- ggplot(tweet_sentiment, aes(tweetID, sentiment, fill= index)) + 
        geom_bar(stat = "identity", show.legend = TRUE, position="dodge") +
        ylab("Sentiment counts") + xlab("") + labs(fill = "") +
        labs(title = "Individual Tweet Sentiment (All 3 locations)")+
        theme(plot.title = element_text(size=26))+
        theme(axis.title = element_text(size = 22))+
        theme(axis.text = element_text(size = 14)) +
        theme(legend.text = element_text(size = 14))
    }
    else if (input$plot_type == "total")
    {
      p <- ggplot(tweet_sentiment, aes(index, sentiment, fill= index)) + 
        geom_boxplot(stat="boxplot", position="dodge") +
        ylab("Sentiment counts") + xlab("") + labs(fill = "") +
        labs(title = "Tweet Sentiment Boxplot (All 3 locations)") +
        theme(plot.title = element_text(size=26)) +
        theme(axis.title = element_text(size = 22)) +
        theme(axis.text = element_text(size = 14))+
        theme(legend.text = element_text(size = 14))
    }
    else 
    {
      p <- ggplot(tweet_sentiment, aes(tweetID, sentiment, fill= index)) + 
        geom_bar(stat = "identity", show.legend = TRUE, position="dodge") +
        facet_grid(.~loc) +
        ylab("Sentiment counts") + xlab("") + labs(fill = "") +
        labs(title = "Individual Tweet Sentiment")+
        theme(plot.title = element_text(size=26))+
        theme(axis.title = element_text(size = 22))+
        theme(axis.text = element_text(size = 14)) +
        theme(legend.text = element_text(size = 14))
    }

    print(p)
    
  })
  
  ### Text
  output$Text <- renderText({
    if (input$plot_type == "sep")
    {
      print("This figure shows the sentiment towards cubs or indians of each individual tweets across ALL 3 locations. 
       The more positive the sentiment value, the more likely that this individual/tweet is in favor to the team he/she is tweeting about.
       You can see that most cubs related tweets are quite neutral or slightly positive (0~2), 
       whereas indians tweets seem more fluctuated, we see a couple really positive tweets and also some really negative ones.
      There doesn't seem to have an overal trend of pro-cubs or pro-indians among these three regions from this figure.")
      
    }
    else if(input$plot_type == "total")
    {
      print("This is a box plot showing sentiment of tweets accross ALL 3 locations.
            From this figure it seems that on average, more people dislike the indians whereas their feelings towards the cubs
            are relatively neutral or slightly positive.")
    }
    else
    {
      print("This graph shows the sentiment analysis by location. We can see quite a lot of cubs fans living in New York (or at 
            least tweeting pro-cubs + hate-indians tweets in NYC area), while we see roughly the same amount of cubs fans and indians fans
            living in California. As for Tornoto baseball lovers, they post the most amount of negative tweets about the indians also the most amount
            of positive tweets towards indians as well! It's likely that their baseball lovers either hate indians to guts or they support them a lot!")
    }
  })
})
