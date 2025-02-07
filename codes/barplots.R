library(ggplot2)

CL_europa <- read.csv('data/NEW_DATASET/Cost_and_Salary.csv')

countries_of_interest <- c('Georgia','Bulgaria', 'Greece', 'Italy', 'France', 'Luxembourg', 'Switzerland')
filtered_data <- CL_europa[CL_europa$Country %in% countries_of_interest,]

data_costs <- data.frame(
  Country = rep(filtered_data$Country, times = 4),
  Cost_Type = factor(rep(c('Food Costs', 'Housing Costs', 'Transport Costs', 'Extra Costs'), each = nrow(filtered_data))),
  Value = c(filtered_data$Food_monthly, filtered_data$Mean_House_cost, filtered_data$Mean_Cost_transport, filtered_data$Extra)
)

data_salary <- data.frame(
  Country = filtered_data$Country,
  Value = filtered_data$Net.Salary.euro,
  Cost_Type = 'Salary'
)

data_costs_minmax <- data.frame(
  Country = filtered_data$Country,
  Value_min = c(filtered_data$Total_Min_Cost,filtered_data$Total_Max_Cost)
)

data_costs$Country <- factor(data_costs$Country, levels = countries_of_interest)
data_salary$Country <- factor(data_salary$Country, levels = countries_of_interest)

p = ggplot() +
  geom_bar(data = data_costs, aes(x = Country, y = Value, fill = Cost_Type), stat = 'identity', position = 'stack', width = 0.4) +
  geom_segment(data = filtered_data, 
               aes(x = Country, 
                   xend = Country, 
                   y = Total_Min_Cost, 
                   yend = Total_Max_Cost), 
               color = "#552884", 
               linewidth = 0.7, 
               lineend = "butt") +
  geom_errorbar(data = filtered_data, 
               aes(x = Country, 
                   ymin = Total_Min_Cost, 
                   ymax = Total_Max_Cost), 
               width=0.2) +
  geom_bar(data = data_salary, aes(x = Country, y = Value, fill = Cost_Type), stat = 'identity',  width = 0.4, position = position_nudge(x = -0.4)) +
  labs(x = NULL,
       y = 'EUR') +
  theme_minimal() +
  coord_cartesian(xlim=c(0.5,7))+
  scale_fill_manual(values = c('#c2f0ee', '#6fd9d4', '#39B5B1', '#046B66','#7341A7')) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        legend.position = c(0.20, 0.79), 
        legend.title = element_blank(),  
        legend.background = element_blank(),  
        legend.key = element_blank(),       
        legend.text = element_text(size = 8), 
        legend.key.size = unit(0.4, 'cm'),
        axis.title.x = element_text(
          margin = margin(t = 15), 
          size = 11,               
          family = "serif"          
        ),
        axis.title.y = element_text(
          margin = margin(r = 15),  
          size = 11,               
          family = "serif"          
        ))
        
print(p)

