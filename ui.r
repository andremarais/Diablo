require(RCurl)
require(XML)



#source("external/uiHead.R",local=T)
shinyUI(fluidPage(
  #source("external/header.R",local=T)$value,
  fluidRow(
    source("external/sidebar.R",local=T)$value
    #source("external/main.R",local=T)$value
  )
))
