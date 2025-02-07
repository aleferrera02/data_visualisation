library(ggplot2)
library(dplyr)
library(readxl)


CL_europa <- read.csv( "data/NEW_DATASET/SavingsRatio.csv")
happy<-read_excel("data/happy2.xls")

happy$`Country name`[happy$`Country name`=="Bosnia and Herzegovina"] <- "Bosnia and Herz."
happy$`Country name`[happy$`Country name`=="Czech Republic"] <- "Czechia"


colnames(happy)[1]<-'Country'

merged_data <- merge(happy, CL_europa, by = "Country")

colnames(merged_data)[3]<-'Happiness'

p = ggplot(merged_data, aes(x=Goodness, y=Happiness)) + 
  geom_point(color='#5A2241',size=2.5) + 
  geom_smooth(aes(color = "Regression Line"),method=lm,formula = y ~exp(x),se = FALSE) + 
  labs(title=NULL, x="Goodness", y="Happiness")+
  theme_minimal()+
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        panel.background = element_blank(),
        legend.position = c(0.1, 0.95), 
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
  scale_color_manual(values = c("Regression Line" = '#C45364'),
                     labels = c("Regression Line" = expression(paste("e"^x))))
 print(p) 
