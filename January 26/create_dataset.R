library(dplyr)
library(readr)

statcast2022 %>%
  filter(type == "X") %>%
  filter(is.na(launch_angle) == FALSE,
         is.na(launch_speed) == FALSE) %>%
  select(batter, pitcher, launch_angle,
         launch_speed, events,
         estimated_ba_using_speedangle,
         estimated_woba_using_speedangle) -> sc2022_ip
write_csv(sc2022_ip, "sc2022_ip.csv")
