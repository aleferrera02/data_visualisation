ratio<-read.csv('data/NEW_DATASET/Cost_and_Salary.csv')

east_europe <- c("Czechia", "Bosnia and Herz.", "North Macedonia", "Montenegro", "Serbia",
                 "Albania", "Kosovo", "Moldova", "Ukraine", "Belarus", "Russia",
                 "Turkey", "Poland", "Slovakia", "Hungary", "Romania", "Bulgaria", "Croatia",
                 "Slovenia", "Estonia", "Latvia", "Lituania", "Armenia", "Azerbaijan", "Georgia")

ratio$Goodness <- (ratio$Net.Salary.euro-ratio$Total_Mean_Cost) /ratio$Net.Salary.euro
ratio$Region <- ifelse(Country %in% east_europe, "East", "West")


p = ggplot(ratio, aes(x = Country, y = Goodness,color=Region)) +
  geom_hline(yintercept =0, linewidth=1)+
  geom_segment(aes(xend = Country, yend = 0), 
               size = 1) +
  geom_point(size = 3,
             stroke = 1.5) +
  scale_color_manual(values = c("East" = "#DA624A", "West" = "#424779")) + 
  theme_minimal() + 
  labs(x = NULL, y = "Savings Ratio", color = "Group") +
  theme(axis.text.x = element_blank(),
        panel.grid = element_blank(),
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        legend.position = c(0.75, 0.08), 
        legend.title = element_blank(),  
        legend.background = element_blank(),  
        legend.key = element_blank(),       
        legend.text = element_text(size = 8), 
        legend.key.size = unit(0.4, 'cm'),
        axis.title.y = element_text(
          margin = margin(r = 15),  
          size = 11,               
          family = "serif"          
        ))
print(p)
