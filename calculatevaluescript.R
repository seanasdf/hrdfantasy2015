library(stats)
library(dplyr)

directory <- "C:\\Users\\Sean\\Documents\\Fantasy\\Fantasy Baseball 2015\\HouseResearch\\"
setwd(directory)


positions <- c("catcher","firstbase","secondbase","thirdbase","shortstop","outfield","dh","pitcher")

for (position in positions) {
      pos <- position
      temp <- read.csv(paste(directory,position,".csv", sep=""), stringsAsFactors = FALSE)
      assign(pos, temp)
      drop(temp)
}


for (position in c("catcher","firstbase","secondbase","thirdbase","shortstop","dh")) {

      if (!exists("infield")) {
            infield <- get(position)
      }
      
      else {
           infield <- rbind(infield, get(position))
      }
}


infield$points <- infield$R+infield$RBI
outfield$points <- outfield$R + outfield$RBI
pitcher$points <- pitcher$W * 6 + pitcher$SV * 4.5

infield$position <- "infield"
outfield$position <- "outfield"


infield <- infield[infield$Team %in% c("Orioles",
                                "Red Sox",
                                "White Sox",
                                "Indians",
                                "Tigers",
                                "Astros",
                                "Royals",
                                "Angels",
                                "Twins",
                                "Yankees",
                                "Althetics",
                                "Mariners",
                                "Rays",
                                "Rangers",
                                "Blue Jays",
                                "Cubs",
                                "Brewers"),]


outfield <- outfield[outfield$Team %in% c("Orioles",
                                       "Red Sox",
                                       "White Sox",
                                       "Indians",
                                       "Tigers",
                                       "Astros",
                                       "Royals",
                                       "Angels",
                                       "Twins",
                                       "Yankees",
                                       "Althetics",
                                       "Mariners",
                                       "Rays",
                                       "Rangers",
                                       "Blue Jays",
                                       "Cubs",
                                       "Brewers"),]

pitcher <- pitcher[pitcher$Team %in% c("Orioles",
                                          "Red Sox",
                                          "White Sox",
                                          "Indians",
                                          "Tigers",
                                          "Astros",
                                          "Royals",
                                          "Angels",
                                          "Twins",
                                          "Yankees",
                                          "Althetics",
                                          "Mariners",
                                          "Rays",
                                          "Rangers",
                                          "Blue Jays",
                                          "Cubs",
                                          "Brewers"),]


hitters <- rbind(infield, outfield)
hitters <- hitters[order(-hitters$points),]
names(hitters)[1] <- "Name"
hitters <- hitters[,c("Name","position","R","RBI","points")]
hitters <- by(hitters, hitters$Name, head, n=1)
hitters <- do.call("rbind",as.list(hitters))
hitters <- hitters[order(-hitters$points),]

names(pitcher)[1] <- "Name"
pitcher$position <- "pitcher"
pitcher <- pitcher[,c("Name","position","SV","W","points")]

rankings <- rbind_list(hitters,pitcher)
rankings <- rankings[order(-rankings$points),]
