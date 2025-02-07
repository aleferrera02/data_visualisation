library(ggplot2)
library(dplyr)
library(reshape2)
library(scales)

df <- read.csv("data/NEW_DATASET/Cost_of_living_europe_restricted.csv")

east_europe <- c("Czechia", "Bosnia and Herz.", "North Macedonia", "Montenegro", "Serbia",
                 "Albania", "Kosovo", "Moldova", "Ukraine", "Belarus", "Russia",
                 "Turkey", "Poland", "Slovakia", "Hungary", "Romania", "Bulgaria", "Croatia",
                 "Slovenia", "Estonia", "Latvia", "Lituania", "Armenia", "Azerbaijan", "Georgia")

df <- df %>%
  mutate(TotalCost = Food_monthly + Mean_House_cost + Mean_Cost_transport + Extra,
         Food = Food_monthly / TotalCost,
         House = Mean_House_cost / TotalCost,
         Transport = Mean_Cost_transport / TotalCost,
         Extra = Extra / TotalCost,
         Region = ifelse(Country %in% east_europe, "East", "West"))

df_melted <- melt(df, id.vars = "Region", measure.vars = c("Food", "House", "Transport", "Extra"),
                  variable.name = "Cost_Type", value.name = "Percentage")
df_melted$Region <- factor(df_melted$Region, levels = c("West", "East"))
custom_palette <- c("West" = "#424779", "East" = "#DA624A")

p = ggplot(df_melted, aes(x = Cost_Type, y = Percentage, fill = Region)) +
  geom_violin(width = 0.6, position = position_dodge(0.75)) +
  geom_boxplot(width = 0.1, position = position_dodge(0.75), outlier.shape = NA, alpha = 0.5) +
  scale_fill_manual(values = custom_palette) +
  scale_y_continuous(labels = percent_format(), limits = c(0, 0.75)) +
  theme_minimal() +
  theme(legend.title = element_blank(),
        legend.position = c(0.9,0.9),
        panel.border = element_rect(colour = "black", fill = NA),
        legend.background = element_blank()) +
  labs(x = NULL, y = NULL, title = NULL) +
  theme(plot.title = element_text(hjust = 0.5))
print(p)