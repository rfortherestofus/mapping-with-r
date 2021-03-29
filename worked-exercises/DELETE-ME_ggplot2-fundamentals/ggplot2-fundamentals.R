library("tidyverse")


gss_cat %>% 
  count(marital) %>% 
  mutate(marital = fct_reorder(marital, n)) %>% 
  ggplot(aes(x = n,
             y = marital)) +
  geom_col() +
  theme_minimal()

library("fivethirtyeight")

bechdel %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point() +
  scale_colour_brewer(palette = "Set2")

bechdel %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point(aes(colour = binary)) +
  scale_colour_brewer(palette = "Set2")

bechdel %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point(aes(colour = binary)) +
  scale_colour_manual(values = c("FAIL" = "coral3",
                                 "PASS" = "forestgreen")) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(reverse = TRUE,
                               override.aes = list(size = 5)))

bechdel %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point(aes(colour = binary)) +
  scale_colour_manual(values = c("FAIL" = "coral3",
                                 "PASS" = "forestgreen")) +
  theme_minimal() +
  theme(legend.position = "bottom") +
    guides(colour = guide_legend(override.aes = list(size=10)))

scale_colour_identity()

scale_fill_viridis_c()

gss_cat %>% 
  count(marital) %>% 
  ggplot(aes(x = n,
             y = marital)) +
  geom_col()



scale_fill