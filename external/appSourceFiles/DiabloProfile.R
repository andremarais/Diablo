#install packages----
#install.packages("httpRequest")


# install.packages("XML")
# install.packages("RCurl")

#load packages----
#require(httpRequest)
# require(RCurl)
# require(XLM)

library("RCurl", lib.loc="~/R/win-library/3.1")
library("XML", lib.loc="~/R/win-library/3.1")

#setting up variables ----
battletag.name <- "Veldrin"
battletag.code <- 2890
zone = "eu"
host <- paste(zone, ".battle.net", sep = "")

#download profile data----
url <- paste(host, "/api/d3/profile/" , battletag.name,"-" ,battletag.code, "/", sep = "")
diablo <- httpGET(url,curl = getCurlHandle())


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

herolist[1,1]  <- substring(hnames[1], regexpr(":",hnames[1])+3,regexpr(",",hnames[1])-2)  
herolist[1,2] <- substring(hclasses[1], regexpr(":",hclasses[1])+3,regexpr(",",hclasses[1])-2)  
herolist[1,3] <- substring(hlevels[1], regexpr("\\:",hlevels[1])+2,regexpr("\\,",hlevels[1])-1) # offest is due to integer value of levels
herolist[1,4] <- substring(hseasonal[1], regexpr("\\:",hseasonal[1])+2,regexpr("\\,",hseasonal[1])-1) #^^
herolist[1,5] <- substring(hid[1], regexpr("\\:",hid[1])+2,regexpr("\\,",hid[1])-1) #^^
herolist[1,6] <- substring(hgender[1], regexpr("\\:",hgender[1])+2,regexpr("\\,",hgender[1])-1) #^^
herolist[1,7] <- substring(hhardcore[1], regexpr("\\:",hhardcore[1])+2,regexpr("\\,",hhardcore[1])-1) #^^
herolist[1,8] <- substring(hdead[1], regexpr("\\:",hdead[1])+2,regexpr("\\,",hdead[1])-1) #^^

#populates rest of data
for (i in 2:length(hnames)) {

  herolist <- rbind( herolist, c(substring(hnames[i], regexpr(":",hnames[i])+3,regexpr(",",hnames[i])-2),
               substring(hclasses[i], regexpr(":",hclasses[i])+3,regexpr(",",hclasses[i])-2),
               substring(hlevels[i], regexpr("\\:",hlevels[i])+2,regexpr("\\,",hlevels[i])-1),
               substring(hseasonal[i], regexpr("\\:",hseasonal[i])+2,regexpr("\\,",hseasonal[i])-1), 
               substring(hid[i], regexpr("\\:",hid[i])+2,regexpr("\\,",hid[i])-1),
               substring(hgender[i], regexpr("\\:",hgender[i])+2,regexpr("\\,",hgender[i])-1),
               substring(hhardcore[i], regexpr("\\:",hhardcore[i])+2,regexpr("\\,",hhardcore[i])-1),
               substring(hdead[i], regexpr("\\:",hdead[i])+2,regexpr("\\,",hdead[i])-1)))
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
herolist$Dead <- as.factor(herolist$Dead)
levels(herolist$Dead) <- c("No", "Yes")



a<-list(herolist$Hero.Name)
