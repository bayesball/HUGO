## problem:  find all hitters in the 1980 season who had a
## .300 batting average with at least 200 AB

library(Lahman)
library(dplyr)

Batting %>% 
  filter(yearID == 1980) %>%
  group_by(playerID) %>%
  summarize(H = sum(H),
            AB = sum(AB))  %>%
  mutate(AVG = round(H / AB, 3)) %>%
  filter(AB >= 200) %>%
  filter(AVG == .300) 