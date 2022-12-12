

# situational home run hitting

library(dplyr)
library(ggplot2)
library(readr)

# read in a Retrosheet dataset from a complete season

d2021 <- read_csv("https://raw.githubusercontent.com/bayesball/HomeRuns2021/main/retro2021.csv")

# what is the home run rate (HR / AB)

d2021 %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = sum(AB_FL)) %>%
  mutate(HR_Rate = 100 * HR / AB)

# who hit the most home runs?

d2021 %>%
  group_by(BAT_ID) %>%
  summarize(HR = sum(EVENT_CD == 23)) %>%
  arrange(desc(HR)) %>%
  head(5)

# how does the home run rate depend on the count?

d2021 %>%
  mutate(Count = paste(BALLS_CT, STRIKES_CT, sep = "-")) ->
  d2021

d2021 %>%
  filter(AB_FL == TRUE) %>%
  group_by(Count) %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = n()) %>%
  mutate(HR_Rate = 100 * HR / AB) -> S

ggplot(S, aes(Count, HR_Rate)) +
  geom_point()

# what is the home run rate for each team
# at home, at away games

d2021 %>%
  mutate(HOME_TEAM_ID = substr(GAME_ID, 1, 3),
         BAT_TEAM_ID = ifelse(BAT_HOME_ID == 0,
                              AWAY_TEAM_ID,
                              HOME_TEAM_ID)) -> d2021

d2021 %>%
  group_by(BAT_TEAM_ID) %>%
  summarize(HR_Home = sum((EVENT_CD == 23) *
                            (BAT_HOME_ID == 1)),
            HR_Away = sum((EVENT_CD == 23) *
                           (BAT_HOME_ID == 0))) -> S1


# what inning is it most likely to see a HR hit?

d2021 %>%
  filter(AB_FL == TRUE) %>%
  group_by(INN_CT) %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = n()) %>%
  mutate(HR_Rate = 100 * HR / AB)

# which is the largest count of home runs hit against
# a single pitcher by a single hitter?

d2021 %>%
  group_by(BAT_ID, PIT_ID) %>%
  summarize(HR = sum(EVENT_CD == 23)) %>%
  arrange(desc(HR)) %>%
  head(10)
