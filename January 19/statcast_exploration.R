# collect Statcast data for two pitchers (Aaron Nola and
# Zack Wheeler) from 2022 season

# load in several packages I will be using

library(dplyr)
library(ggplot2)
library(readr)
library(janitor)

# read in dataset from my Github site

sc <- read_csv("https://raw.githubusercontent.com/bayesball/HUGO/main/January%2019/two_pitchers.csv")

# sc is a data frame with 5397 observations of 93 variables

dim(sc)

# each row has data on a single pitch

# interested in type of pitch, speed and break of these
# pitches, location, outcome of pitch

# want to compare these two Phillies pitchers on
# these variables

# types of pitches?

sc %>%
  tabyl(pitcher, pitch_type)

# show as row proportions

sc %>%
  tabyl(pitcher, pitch_type) %>%
  adorn_percentages("row")

# pitch types vary by break and speed

sc %>%
  filter(pitcher == 605400) -> nola

sc %>%
  filter(pitcher == 554430) -> wheeler

# plot pitch breaks, color by pitch type

ggplot(nola, aes(pfx_x, pfx_z, color = pitch_type)) +
  geom_point() +
  ggtitle("Nola pitch breaks by pitch type")

# pitch speeds?

ggplot(nola, aes(release_speed, pitch_type)) +
  geom_boxplot() +
  ggtitle("Nola pitch breaks by pitch type")

# pitch locations

ggplot(filter(nola, pitch_type == "KC"),
       aes(plate_x, plate_z)) +
  geom_point()

# add function to add zone border

add_zone <- function(Color = "red"){
  topKzone <- 3.5
  botKzone <- 1.6
  inKzone <- -0.85
  outKzone <- 0.85
  kZone <- data.frame(
    x=c(inKzone, inKzone, outKzone, outKzone, inKzone),
    y=c(botKzone, topKzone, topKzone, botKzone, botKzone)
  )
  geom_path(aes(.data$x, .data$y), data=kZone,
            lwd=1, col=Color)
}

ggplot(filter(nola, pitch_type == "KC"),
       aes(plate_x, plate_z)) +
  geom_point() +
  add_zone()  +
  ggtitle("Locations of Nola Curve Balls")

# pitch outcome variable

nola %>%
  group_by(description) %>%
  count()

# how does outcome depend on pitch type?

nola %>%
  tabyl(pitch_type, description) %>%
  adorn_percentages("row") %>%
  adorn_rounding(digits = 3)

wheeler %>%
  tabyl(pitch_type, description) %>%
  adorn_percentages("row") %>%
  adorn_rounding(digits = 3)

# how many home runs does each player let up and on
# what pitch types

sc %>%
  group_by(pitcher) %>%
  summarize(HR = sum(events == "home_run",
                     na.rm = TRUE))

sc %>%
  filter(events == "home_run") %>%
  tabyl(pitcher, pitch_type)

# locations of home runs

ggplot(filter(sc, events == "home_run"),
       aes(plate_x, plate_z,
           color = as.character(pitcher))) +
  geom_point() +
  add_zone()
