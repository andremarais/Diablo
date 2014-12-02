url1 <- "http://eu.battle.net/d3/en/rankings/era/1/rift-barbarian"

diablo <- httpGET(url,curl = getCurlHandle())

#if(grep("The account could not be found", diablo) == 1 ) return("No such profile")
# else if (grep("The account could not be found", diablo) != 1 ) { 
# parse html




herolist <- data.frame(matrix(NA))
herolist[1,1] <- gregexpr(paste(">\n",1,"\\.", sep= ""), diablo)

for (i in 2:1001) {
  
  herolist[i,1] <- as.integer(gregexpr(paste(">\n",i,"\\.", sep= ""), substring(diablo, herolist[i-1,1], nchar(diablo)))) + herolist[i-1,1] -1
  proiflename.start <- gregexpr("/profile/", substring(diablo, herolist[i-1,1], herolist[i,1])) 
  profilename.end <- gregexpr("/\\\" title=", substring(diablo, herolist[i-1,1], herolist[i,1]))
  herolist[i-1,2] <- substring(diablo, herolist[i-1,1]+as.integer(proiflename.start) + as.integer(attributes(proiflename.start[[1]])[1])-1
                               , herolist[i-1,1]+as.integer(profilename.end) -2 )[1]
  
}
herolist
