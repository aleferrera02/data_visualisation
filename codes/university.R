uni = read.csv("data/qs-world-rankings-2025.csv")
as = read.csv("data/NEW_DATASET/Cost_and_Salary.csv")

as$Goodness <- (as$Net.Salary.euro-as$Total_Mean_Cost) /as$Net.Salary.euro
as2<-as[,c(1,15)]

uni$Location.Full[uni$Location.Full == 'Czech Republic'] <- 'Czechia'
uni$Location.Full[uni$Location.Full == 'Bosnia And Herzegovina'] <- 'Bosnia and Herz.'

restr_uni<-uni
restr_uni[restr_uni == "-"] <- NA
restr_uni <- na.omit(restr_uni)

lm(as.numeric(restr_uni$QS.Overall.Score)~ as.matrix(restr_uni[,7:15]))
beta=c(0.3,0.15,0.10,0.20,0.05,0.05,0.05,0.05,0.05)


library(dplyr)
top_universities <- uni %>%
  group_by(Location.Full) %>%
  arrange(desc(QS.Overall.Score)) %>%
  slice_head(n = 3) %>%
  ungroup()

top_universities <- top_universities %>%
  filter(Location.Full %in% as$Country)

top_universities[is.na(top_universities)] <- 0

for (i in 1:nrow(top_universities)){
  if (as.character(top_universities$QS.Overall.Score[i])=='-'){
    top_universities$QS.Overall.Score[i]=beta%*%as.numeric(top_universities[i,7:15])
  }
}

result_mean <- aggregate(as.numeric(QS.Overall.Score) ~ Location.Full, data = top_universities, FUN = mean)

colnames(result_mean)<-c('Country','Qs Ranking')

merged_data <- merge(result_mean, as2, by = "Country", all = TRUE)

merged_data <- na.omit(merged_data)

#boxcox(merged_data$`Qs Ranking`~merged_data$Goodness)
p1 = ggplot(data = merged_data, aes(x = `Qs Ranking`, y = Goodness)) +
  geom_point(color="#235F1D",size=2) + 
  geom_point(aes(x=50,y=0.9,),color="white")+
  labs(x = "QS",
       y = "Savings Ratio") +
  theme_minimal()+
  scale_y_continuous(breaks = seq(-1.5, 1, by = 0.5)) +
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        panel.background = element_blank(),
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
p2 = ggplot(data = merged_data, aes(x = log(`Qs Ranking`), y = Goodness)) +
  geom_point(aes(x=3.5,y=0.9,),color="white")+
  geom_point(color="#235F1D",size=2) + 
  geom_smooth(method = "lm", formula = y ~ x,level = 0.95, color='#66B253',fill = "#8AD275",se = TRUE)  +
  labs(x = "log(QS)",
       y = NULL) +
  scale_y_continuous(breaks = seq(-1.5, 1, by = 0.5)) +
  theme_minimal()+
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA), 
        panel.background = element_blank(),
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
library(gridExtra)
grid.arrange(p1,p2,ncol = 2)

write.csv(as2, file = "data/NEW_DATASET/SavingsRatio.csv", row.names = FALSE)


