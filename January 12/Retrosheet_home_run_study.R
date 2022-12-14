
# situational home run hitting

library(dplyr)
library(ggplot2)
library(readr)

# read in a Retrosheet dataset from a complete season (2022)

# first I will download a R workspace file
# https://github.com/bayesball/HomeRuns2021/pbp.2022.Rdata
# then I will read this datafile into R
# (menu Workspace > Load Workspace file)

# want to make sure that the file d2022 is in the R workspace

ls()

# here is a description of all of the variables in this
# data frame
# https://www.retrosheet.org/datause.txt

# what is the overall home run rate (HR / AB)

d2022 %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = sum(AB_FL)) %>%
  mutate(HR_Rate = 100 * HR / AB)

# who hit the most home runs?

d2022 %>%
  group_by(BAT_ID) %>%
  summarize(HR = sum(EVENT_CD == 23)) %>%
  arrange(desc(HR)) %>%
  head(5)

# how does the home run rate depend on the count?

d2022 %>%
  mutate(Count = paste(BALLS_CT, STRIKES_CT, sep = "-")) ->
  d2022

d2022 %>%
  filter(AB_FL == TRUE) %>%
  group_by(Count) %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = n()) %>%
  mutate(HR_Rate = 100 * HR / AB) -> S

ggplot(S, aes(Count, HR_Rate)) +
  geom_point()

# what is the home run count for each team
# at home, at away games

d2022 %>%
  mutate(HOME_TEAM_ID = substr(GAME_ID, 1, 3),
         BAT_TEAM_ID = ifelse(BAT_HOME_ID == 1,
                              HOME_TEAM_ID,
                              AWAY_TEAM_ID)) -> d2022

d2022 %>%
  group_by(BAT_TEAM_ID) %>%
  summarize(HR_Home = sum((EVENT_CD == 23) *
                            (BAT_HOME_ID == 1)),
            HR_Away = sum((EVENT_CD == 23) *
                           (BAT_HOME_ID == 0))) -> S1

ggplot(S1, aes(HR_Home - HR_Away, BAT_TEAM_ID)) +
  geom_point() +
  geom_vline(xintercept = 0, color = "red")

# what inning is it most likely to see a HR hit?

d2022 %>%
  filter(AB_FL == TRUE) %>%
  group_by(INN_CT) %>%
  summarize(HR = sum(EVENT_CD == 23),
            AB = n()) %>%
  mutate(HR_Rate = 100 * HR / AB)

# which is the largest count of home runs hit against
# a single pitcher by a single hitter?

d2022 %>%
  group_by(BAT_ID, PIT_ID) %>%
  summarize(HR = sum(EVENT_CD == 23)) %>%
  arrange(desc(HR)) %>%
  head(10)
