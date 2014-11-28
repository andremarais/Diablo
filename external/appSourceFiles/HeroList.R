source("external/appSourceFiles/DiabloProfile.R", local = T)



output$herolist <- renderUI({
  selectInput("hero",
              label = "Choose Hero",
              choices = list(herolist$Hero.Name)
)
  
  
})
