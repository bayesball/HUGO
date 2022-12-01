# interested in constructing a career trajectory graph for
# Albert Pujols where we plot his home run rate (HR / AB)
# against age.  We'll compare his trajectory to that of
# a similar player

# we'll be using the Lahman, dplyr, and ggplot2 packages

library(Lahman)
library(dplyr)
library(ggplot2)

# first I need to obtain Pujols' player id

People %>% 
  filter(nameFirst == "Albert",
         nameLast == "Pujols") %>% 
  pull(playerID) -> albert_id

# collect Pujols season to season stats

Batting %>% 
  filter(playerID == albert_id) %>% 
  select(yearID, HR, AB) -> albert_data

head(albert_data)

# want to compute an age variable
# obtain his official birthyear from Baseball Reference
# also I will compute his HR rate (as a percentage)

birthyear <- 1980

albert_data %>% 
  mutate(Age = yearID - birthyear,
         HR_Rate = 100 * HR / AB) ->
  albert_data

head(albert_data)

# construct a scatterplot of HR Rate against Age

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point()

# will add a smoothing curve to plot to see general
# pattern

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point() +
  geom_smooth()

# when did Pujols get signed by the Angels -- might
# be helpful to indicate this season by a vertical line

# checking Baseball Reference again

angels_start <- 2012

# I will add a vertical line to the graph at 2011.5

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point() +
  geom_smooth() +
  geom_vline(xintercept = 2011.5 - birthyear)

# change attributes of the graph

# change color of points to blue, shape to large diamonds

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point(color = "blue",
             shape = 2,
             size = 5) +
  geom_smooth() +
  geom_vline(xintercept = 2011.5 - birthyear)

# change axis labels and a title

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point(color = "blue",
             shape = 2,
             size = 5) +
  geom_smooth() +
  geom_vline(xintercept = 2011.5 - birthyear) +
  xlab("Player Age") +
  ylab("Home Run Rate (Pct)") +
  ggtitle("Home Run Trajectory of Albert Pujols")

# add a label to the vertical lines

ggplot(albert_data,
       aes(Age, HR_Rate)) +
  geom_point(color = "blue",
             shape = 2,
             size = 5) +
  geom_smooth() +
  geom_vline(xintercept = 2011.5 - birthyear) +
  xlab("Player Age") +
  ylab("Home Run Rate (Pct)") +
  annotate(geom = "text",
           x = 35, y = 8.5,
           size = 6,
           label = "Signed by Angels")

# let's compare Pujols with Henry Aaron 

# get Aaron data

People %>% 
  filter(nameFirst == "Hank",
         nameLast == "Aaron") %>% 
  pull(playerID) -> aaron_id

Batting %>% 
  filter(playerID == aaron_id) %>% 
  select(yearID, HR, AB) -> henry_data

# add age and HR Rate variables

henry_data %>% 
  mutate(Age = yearID - 1934,
         HR_Rate = 100 * HR / AB) -> henry_data

# I want to compare the two player trajectories on the
# same graph.

# I will add a Name variable to each data frame,
# and merge the two data frames

albert_data %>% 
  mutate(Name = "Albert Pujols") -> albert_data

henry_data %>% 
  mutate(Name = "Hank Aaron") -> henry_data

all_data <- rbind(albert_data, henry_data)

# Now we'll see a nice feature of ggplot2

ggplot(all_data,
       aes(Age, HR_Rate, color = Name)) +
  geom_point() +
  geom_smooth()

# another way to compare is to put them in different
# plotting frames (facets)

ggplot(all_data,
       aes(Age, HR_Rate)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~ Name, ncol = 1)


