# Cole (Yankees), Marlins pitcher, Kershaw, Cortez (Yankees)

library(ShinyBaseball)

chadwick %>% filter(name_first == "Gerrit",
                    name_last == "Cole") %>%
  pull(key_mlbam) -> gc

chadwick %>% filter(name_first == "Sandy",
                    name_last == "Alcantara") %>%
  pull(key_mlbam) -> sa

chadwick %>% filter(name_first == "Clayton",
                    name_last == "Kershaw") %>%
  pull(key_mlbam) -> ck

chadwick %>% filter(name_first == "Nestor",
                    name_last == "Cortes") %>%
  pull(key_mlbam) -> nc

four_pitchers <- filter(sc2022, pitcher %in%
                          c(gc, sa, ck, nc))

write_csv(four_pitchers, "four_pitchers.csv")
