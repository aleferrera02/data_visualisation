mean_salary<-read.csv("data/EU_av_salaries.csv")

C_europa<-read.csv('data/NEW_DATASET/Cost_of_living_europe_restricted.csv')

attach(C_europa)

mean_salary$Country[mean_salary$Country == 'Czech Republic'] <- 'Czechia'
mean_salary$Country[mean_salary$Country == 'Bosnia and Herzegovina'] <- 'Bosnia and Herz.'

C_europa <- merge(C_europa,mean_salary,by="Country")

write.csv(C_europa, file = 'data/NEW_DATASET/Cost_and_Salary.csv', row.names = FALSE)

#install.packages(c("ggplot2","dplyr"))
library(ggplot2)
library(dplyr)

C_europa$highlight <- ifelse(C_europa$Country %in% c("Italy", "Switzerland", "France", "Luxembourg", "Bulgaria", "Greece"), "highlighted", "normal")
C_europa$highlight <- factor(C_europa$highlight)

p <- ggplot(data = C_europa, aes(x = Total_Mean_Cost, y = Net.Salary.euro)) +
  geom_point(data = C_europa[C_europa$highlight == "normal", ], size = 1.5, color = "#24627C") +
  geom_point(data = C_europa[C_europa$highlight == "highlighted", ], size = 1.5, color = "#64cbf5") +
  geom_smooth(color = '#5fa5c2', linetype = "solid", method = "lm", fill = "#AFDAEF", level = 0.95, se = TRUE) +
  geom_abline(aes(color = "Identity Line", linetype = "Identity Line", slope = 1, intercept = 0),linewidth=0.6) +
  labs(x = "Total Cost",
       y = "Average Net Salary") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        panel.background = element_blank(),
        legend.position = c(0.21, 0.89), 
        legend.title = element_blank(),
        legend.key.size = unit(0.5, 'cm'),
        axis.title.x = element_text(
          margin = margin(t = 15), 
          size = 11,               
          family = "serif"          
        ),
        axis.title.y = element_text(
          margin = margin(r = 15),  
          size = 11,               
          family = "serif"          
        )) +
  scale_color_manual(values = c("Identity Line" = "red")) +  
  scale_linetype_manual(values = c("Identity Line" = "dashed")) + 
  geom_text(data = C_europa[C_europa$Country == "Italy", ], 
            aes(label = Country), 
            vjust = -0.5, hjust=1.2 ,size = 2.5, color = "black") +
  geom_text(data = C_europa[C_europa$Country == "Switzerland", ], 
            aes(label = Country), 
            vjust = 0.2, hjust=1.15 ,size = 2.5, color = "black") +
  geom_text(data = C_europa[C_europa$Country == "France", ], 
            aes(label = Country), 
            vjust = -0.2, hjust=-0.2,size = 2.5, color = "black") +
  geom_text(data = C_europa[C_europa$Country == "Bulgaria", ], 
            aes(label = Country), 
            vjust = -1.5, hjust=0.5 ,size = 2.5, color = "black") +
  geom_text(data = C_europa[C_europa$Country == "Luxembourg", ], 
            aes(label = Country), 
            vjust = -0.5, hjust=1 ,size = 2.5, color = "black") +
  geom_text(data = C_europa[C_europa$Country == "Greece", ], 
            aes(label = Country), 
            vjust = -0.5, hjust=1.1 ,size = 2.5, color = "black") +
  guides(color = guide_legend(override.aes = list(linetype = c( "dashed"), color = c("red"))),
         linetype = FALSE)

print(p)

