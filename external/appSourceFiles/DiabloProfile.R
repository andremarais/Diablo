GetProfile <- function(BTN, BTC, Zone){
battletag.name <- BTN
battletag.code <- BTC
zone <- Zone
host <- paste(zone, ".battle.net", sep = "")

#download profile data----
url <- paste(host, "/api/d3/profile/" , battletag.name,"-" ,battletag.code, "/", sep = "")
diablo <- httpGET(url,curl = getCurlHandle())

#if(grep("The account could not be found", diablo) == 1 ) return("No such profile")
# else if (grep("The account could not be found", diablo) != 1 ) { 
# parse html
doc <- htmlParse(diablo, asText=TRUE)
plain.text <- xpathSApply(doc, "//p", xmlValue)
DProfile<-capture.output(cat(paste(plain.text, collapse = "\n")))


#find hero section:
heroesS <- grep("heroes", DProfile)
heroesE <- grep("\\]", DProfile[1:length(DProfile)])
heroes <- DProfile[heroesS:heroesE[1]]

#find heroe names
hnames <- heroes[grep("name", heroes)]
hclasses <- heroes[grep("class", heroes)]
hlevels <- heroes[grep("level", heroes)]
hseasonal <- heroes[grep("seasonal", heroes)]
hid <- heroes[grep("id", heroes)]
hgender <- heroes[grep("gender", heroes)]
hhardcore <- heroes[grep("hardcore", heroes)]
hdead <- heroes[grep("dead", heroes)]


herolist <- NULL
#sets first row for data frame
herolist <- data.frame(matrix(NA))
#populates rest of data
for (i in 1:length(hnames)) {

  
  
  herolist[i,1] <- substring(hnames[i], regexpr(":",hnames[i])+3,regexpr(",",hnames[i])-2)  
  herolist[i,2] <- substring(hclasses[i], regexpr(":",hclasses[i])+3,regexpr(",",hclasses[i])-2)  
  herolist[i,3] <- substring(hlevels[i], regexpr("\\:",hlevels[i])+2,regexpr("\\,",hlevels[i])-1) # offest is due to integer value of levels
  herolist[i,4] <- substring(hseasonal[i], regexpr("\\:",hseasonal[i])+2,regexpr("\\,",hseasonal[i])-1) #^^
  herolist[i,5] <- substring(hid[i], regexpr("\\:",hid[i])+2,regexpr("\\,",hid[i])-1) #^^
  herolist[i,6] <- substring(hgender[i], regexpr("\\:",hgender[i])+2,regexpr("\\,",hgender[i])-1) #^^
  herolist[i,7] <- substring(hhardcore[i], regexpr("\\:",hhardcore[i])+2,regexpr("\\,",hhardcore[i])-1) #^^
  herolist[i,8] <- substring(hdead[i], regexpr("\\:",hdead[i])+2,regexpr("\\,",hdead[i])-1) #^^
  
  
  
}
colnames(herolist) <- c("Hero.Name", "Class", "Level", "Seasonal", "Hero.ID", "Gender", "Hardcore", "Dead")


#refining fields
#levels

herolist$Level <- as.integer(herolist$Level)
#gender
herolist$Gender <- as.factor(herolist$Gender)
levels(herolist$Gender) <- c("Male", "Female")
#season
herolist$Seasonal <- as.factor(herolist$Seasonal)
levels(herolist$Seasonal) <- c("No", "Yes")
#hardcore
herolist$Hardcore <- as.factor(herolist$Hardcore)
levels(herolist$Hardcore) <- c("No", "Yes")
#Dead state
# herolist$Dead <- as.factor(herolist$Dead)
levels(herolist$Dead) <- c("No", "Yes")



if(grep("The account could not be found", diablo) == 1 ) return("No such profile")
#else if(grep("The account could not be found", diablo) =="logical(0)" ) return(herolist)
return(herolist)
}
