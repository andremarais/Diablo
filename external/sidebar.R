#source("external/uiHead.R",local=T)

column(4,
       wellPanel(
         selectInput("server",
                     label = "Server",
                     choices = list("EU",
                                    "US"),
                     selected = "EU"),
         textInput("BTName",
                   label = "Battle Tag Name"),
         textInput("BTCode",
                   label = "Battle Tag Code")
         
         
         ),
       wellPanel(
         uiOutput("herolist"),
         uiOutput("heroinfo")
       )
)
