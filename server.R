
shinyServer(function(input, output) {
  source("external/appSourceFiles/HeroList.R", local = T)
  output$text1 <- renderText({ 
    "You have selected this"
  })
  
}
)
