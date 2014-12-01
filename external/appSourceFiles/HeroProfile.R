
herostats <- data.frame(matrix(NA))


for (i in 1:length(herolist$Hero.ID)){


battletag.name <- BTN
battletag.code <- BTC
hero.id <- herolist$Hero.ID[i]
zone <- Zone
host <- paste("http://", zone, ".battle.net", sep = "")



#download profile data----
url <- paste(host, "/api/d3/profile/" , battletag.name,"-" ,battletag.code, "/hero/",hero.id , sep = "")
hero <- httpGET(url,curl = getCurlHandle())


doc <- htmlParse(hero, asText=TRUE)
plain.text <- xpathSApply(doc, "//p", xmlValue)
hero<-capture.output(cat(paste(plain.text, collapse = "\n")))

#last stats is where (not the) gold is
s <- grep("stats\\\" : \\{", hero)[length(grep("stats\\\" : \\{", hero))]
hero.subset  <- hero[s:(s+35)]

life <- hero.subset[grep("life\\\" :", hero.subset )]
damage <- hero.subset[grep("damage\\\" :", hero.subset )]
armor <- hero.subset[grep("armor\\\" :", hero.subset )]
str <- hero.subset[grep("strength\\\" :", hero.subset )]
dex <- hero.subset[grep("dexterity\\\" :", hero.subset )]
vit <- hero.subset[grep("vitality\\\" :", hero.subset )]
int <- hero.subset[grep("intelligence\\\" :", hero.subset )]
elites <- hero.subset[grep("elites\\\" :", hero.subset )]


herostats[i,1] <- substring(life, regexpr(":", life) + 2,regexpr(",", life)-1)
herostats[i,2] <- substring(damage, regexpr(":", damage) + 2,regexpr(",", damage)-1)
herostats[i,3] <- substring(armor, regexpr(":", armor) + 2,regexpr(",", armor)-1)
herostats[i,4] <- substring(str, regexpr(":", str) + 2,regexpr(",", str)-1)
herostats[i,5] <- substring(dex, regexpr(":", dex) + 2,regexpr(",", dex)-1)
herostats[i,6] <- substring(vit, regexpr(":", vit) + 2,regexpr(",", vit)-1)
herostats[i,7] <- substring(int, regexpr(":", int) + 2,regexpr(",", int)-1)
herostats[i,8] <- substring(elites, regexpr(":", elites) + 2,nchar(elites))


}
rownames(herostats) <- c(herolist$Hero.Name)
colnames(herostats) <- c("Life", "Damage", "Armor", "Strenth", "Dexterity", "Vitality", "Intelligence", "Elite.Kills") 
