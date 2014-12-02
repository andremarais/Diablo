source("external/appSourceFiles/DiabloProfile.R", local = T)



output$herolist <- renderUI({
  #& !is.null(input$BTCode)
  if(input$BTName != "" & input$BTCode >= 1000 ) {
    selectInput("hero",
                label = "Choose Hero",
                choices = GetProfile(input$BTName,input$BTCode,input$server)$Hero.Name)
    
  } 
  else if (input$BTName == "" | input$BTCode < 1000) h6("Please enter account details")
})
