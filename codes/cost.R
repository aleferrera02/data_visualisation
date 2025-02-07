#Calculating the cost of living in each city

CL_europa<-read.csv('data/NEW_DATASET/Cost_of_living_europe.csv')
attach(CL_europa)

cost_food<-Meal..Inexpensive.Restaurant*7+Meal.for.2.People..Mid.range.Restaurant..Three.course+
  McMeal.at.McDonalds..or.Equivalent.Combo.Meal.*2+Imported.Beer..0.33.liter.bottle.*10+
  Coke.Pepsi..0.33.liter.bottle.*2+Water..1.5.liter.bottle.*12+Milk..regular....1.liter.*6+
  Loaf.of.Fresh.White.Bread..500g.*8+Eggs..regular...12.*2+Local.Cheese..1kg./2+
  Bottle.of.Wine..Mid.Range.*2+Chicken.Breasts..Boneless..Skinless....1kg.*3+Apples..1kg.*2+
  Oranges..1kg.+Potato..1kg.*2+Lettuce..1.head.*3+Rice..white....1kg.*2+Tomato..1kg.*3+
  Banana..1kg.*2+Onion..1kg.+Beef.Round..1kg...or.Equivalent.Back.Leg.Red.Meat.*2

CL_europa <- cbind(CL_europa,cost_food)
colnames(CL_europa)[ncol(CL_europa)]<-'Food_monthly'

cost_transport<-Monthly.Pass..Regular.Price./2+(Toyota.Corolla.1.6l.97kW.Comfort..Or.Equivalent.New.Car.+
                Volkswagen.Golf)/(2*8*12*2)+Gasoline..1.liter.*60/2

CL_europa <- cbind(CL_europa,cost_transport)
colnames(CL_europa)[ncol(CL_europa)]<-'Mean_Cost_transport'

cost_transport_max<-Toyota.Corolla.1.6l.97kW.Comfort..Or.Equivalent.New.Car./(8*12*2)+Gasoline..1.liter.*60

CL_europa <- cbind(CL_europa,cost_transport_max)
colnames(CL_europa)[ncol(CL_europa)]<-'Max_Cost_transport'

cost_transport_min<-Monthly.Pass..Regular.Price.

CL_europa <- cbind(CL_europa,cost_transport_min)
colnames(CL_europa)[ncol(CL_europa)]<-'Min_Cost_transport'

house_mean<-(Apartment..1.bedroom..in.City.Centre+Apartment..1.bedroom..Outside.of.Centre+
               Apartment..3.bedrooms..in.City.Centre/3+Apartment..3.bedrooms..Outside.of.Centre/3)/4+
              Basic..Electricity..Heating..Cooling..Water..Garbage..for.85m2.Apartment*0.7+
              Internet..60.Mbps.or.More..Unlimited.Data..Cable.ADSL./2

CL_europa <- cbind(CL_europa,house_mean)
colnames(CL_europa)[ncol(CL_europa)]<-'Mean_House_cost'

house_max<-Apartment..1.bedroom..in.City.Centre+
              Basic..Electricity..Heating..Cooling..Water..Garbage..for.85m2.Apartment*0.7+
              Internet..60.Mbps.or.More..Unlimited.Data..Cable.ADSL./2

CL_europa <- cbind(CL_europa,house_max)
colnames(CL_europa)[ncol(CL_europa)]<-'Max_House_cost'
  
house_min<-Apartment..3.bedrooms..Outside.of.Centre/3+
                Basic..Electricity..Heating..Cooling..Water..Garbage..for.85m2.Apartment*0.7+
                Internet..60.Mbps.or.More..Unlimited.Data..Cable.ADSL./2

CL_europa <- cbind(CL_europa,house_min)
colnames(CL_europa)[ncol(CL_europa)]<-'Min_House_cost'

extra<-Cinema..International.Release..1.Seat*2+Fitness.Club..Monthly.Fee.for.1.Adult+
      X1.Pair.of.Jeans..Levis.501.Or.Similar.+X1.Summer.Dress.in.a.Chain.Store..Zara..H.M......+
      X1.Pair.of.Nike.Running.Shoes..Mid.Range./4+X1.Pair.of.Men.Leather.Business.Shoes/12

CL_europa <- cbind(CL_europa,extra)
colnames(CL_europa)[ncol(CL_europa)]<-'Extra'

attach(CL_europa)

total_cost<-Food_monthly+Mean_House_cost+Mean_Cost_transport+Extra
CL_europa <- cbind(CL_europa,total_cost)
colnames(CL_europa)[ncol(CL_europa)]<-'Total_Mean_Cost'

attach(CL_europa)

library(dplyr)
library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(viridis)

CL_europa$Country[CL_europa$Country == 'Czech Republic'] <- 'Czechia'
CL_europa$Country[CL_europa$Country == 'Bosnia And Herzegovina'] <- 'Bosnia and Herz.'


europe_map <- ne_countries(continent = "Europe", scale = "medium", returnclass = "sf")
europe_data <- merge(europe_map, CL_europa, by.x = "name", by.y = "Country")


p = ggplot(data = europe_data) +
  geom_sf(aes(fill = Total_Mean_Cost)) +  
  scale_fill_viridis_c(option = "plasma", na.value = "grey50") + 
  theme_minimal() +  
  labs(fill = "EUR") +  
  theme(axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        panel.grid = element_blank())+
  xlim(-30, 50) + 
  ylim(35, 72) 

print(p)

CL_eu_restr<-CL_europa[,c("Country", "Food_monthly","Mean_Cost_transport","Min_Cost_transport",
                         "Max_Cost_transport","Mean_House_cost","Min_House_cost","Max_House_cost","Extra","Total_Mean_Cost")]
min_cost<-Extra+Min_Cost_transport+Min_House_cost+Food_monthly
max_cost<-Extra+Max_Cost_transport+Max_House_cost+Food_monthly
CL_eu_restr<-cbind(CL_eu_restr,min_cost,max_cost)
colnames(CL_eu_restr)[11:12]<-c("Total_Min_Cost","Total_Max_Cost")

write.csv(CL_eu_restr, file = 'data/NEW_DATASET/Cost_of_living_europe_restricted.csv', row.names = FALSE)
