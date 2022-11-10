# Data frame manipulations

# Reference:  Chapter 5 in R for Data Science
# https://r4ds.had.co.nz/transform.html

# In the `dplyr` package, here are some verbs
# for data manipulation:

# - `select` will choose variables (columns)
# - `filter` will choose observations (rows)
# - `mutate` will define new variables
# - `arrange` will sort the data frame with respect to some
#    variable
# - `summarize` will compute a data summary

# The piping symbol `%>%` passes the data frame from one operation to another operation.

# A common thing to do is to divide the data frame by a `group_by` on some variable and `summarize` each subgroup.

#  Exploring Lahman's Pitching Table

# Suppose we are interested in finding the pitchers with the highest strikeout rates (9 x SO / IP) in the seasons 1980 through 2021.  Interested in

# the highest rates for a particular season
# the highest career rates

# Load the `Lahman` and `dplyr` packages.

library(Lahman)
library(dplyr)

Pitching %>%
  filter(yearID >= 1980, yearID <= 2021) %>%
  group_by(playerID, yearID) %>%
  summarize(SO = sum(SO),
            IP = sum(IPouts / 3)) -> S
head(S)

S %>%
  filter(IP >= 100) -> S100

S100 %>%
  mutate(SO_Rate = 9 * SO / IP) %>%
  arrange(desc(SO_Rate)) -> S100
head(S100)

inner_join(select(People, playerID,
                  nameFirst, nameLast),
           S100, by = "playerID") %>%
  mutate(Name = paste(nameFirst, nameLast)) %>%
  select(Name, yearID, SO_Rate)  %>%
  arrange(desc(SO_Rate)) -> S100
head(S100)

tail(S100)

Pitching %>%
  filter(yearID >= 1980, yearID <= 2021) %>%
  group_by(playerID) %>%
  summarize(SO = sum(SO),
            IP = sum(IPouts / 3)) %>%
  filter(IP >= 1000) %>%
  mutate(SO_Rate = 9 * SO / IP) -> S_cum

inner_join(select(People, playerID,
                  nameFirst, nameLast),
             S_cum,
             by = "playerID") -> S_cum

S_cum %>%
  mutate(Name = paste(nameFirst, nameLast)) %>%
  select(Name, IP, SO_Rate) %>%
  arrange(desc(SO_Rate)) %>%
  head(6)

