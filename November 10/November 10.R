## ----setup, include=FALSE--------------------------------
knitr::opts_chunk$set(echo = TRUE)


## --------------------------------------------------------
library(Lahman)
library(dplyr)


## --------------------------------------------------------
Pitching %>% 
  filter(yearID >= 1980, yearID <= 2021) %>% 
  group_by(playerID, yearID) %>%
  summarize(SO = sum(SO),
            IP = sum(IPouts / 3)) -> S
head(S)


## --------------------------------------------------------
S %>% 
  filter(IP >= 100) -> S100


## --------------------------------------------------------
S100 %>% 
  mutate(SO_Rate = 9 * SO / IP) %>% 
  arrange(desc(SO_Rate)) -> S100
head(S100)


## --------------------------------------------------------
inner_join(select(People, playerID,
                  nameFirst, nameLast),
           S100, by = "playerID") %>% 
  mutate(Name = paste(nameFirst, nameLast)) %>% 
  select(Name, yearID, SO_Rate)  %>% 
  arrange(desc(SO_Rate)) -> S100
head(S100)


## --------------------------------------------------------
tail(S100)


## --------------------------------------------------------
Pitching %>% 
  filter(yearID >= 1980, yearID <= 2021) %>% 
  group_by(playerID) %>%
  summarize(SO = sum(SO),
            IP = sum(IPouts / 3)) %>% 
  filter(IP >= 1000) %>% 
  mutate(SO_Rate = 9 * SO / IP) -> S_cum 


## --------------------------------------------------------
  inner_join(select(People, playerID,
                  nameFirst, nameLast),
             S_cum,
             by = "playerID") -> S_cum 


## --------------------------------------------------------
S_cum %>% 
  mutate(Name = paste(nameFirst, nameLast)) %>% 
  select(Name, IP, SO_Rate) %>% 
  arrange(desc(SO_Rate)) %>% 
  head(6)

