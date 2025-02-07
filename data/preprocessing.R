#PreProcessing of cost of living Dataset

CL<-read.csv('data/cost-of-living.csv')
ES<-read.csv('data/EU_av_salaries.csv')

CL<-t(CL)
colnames(CL) <- CL[1, ] 
CL <- CL[-1, ] 

CL <- cbind(row.names(CL), CL)
row.names(CL)<-NULL

data <- strsplit(CL[,1], "\\.\\.")
data<-unlist(data)
data <- data[nchar(data) != 2]
data<-data[data!="Krakow"]
city<-rep(0,length(data)/2)
country<-rep(0,length(data)/2)
count=1

for (i in seq(1, length(data), by = 2)){
  city[count]<-data[i]
  country[count]<-data[i+1]
  count=count+1
}

CL[,1]<-country
CL<-cbind(city, CL)

colnames(CL)[1:2]=c('City','Country')

CL <- as.data.frame(CL, stringsAsFactors = FALSE)

CL$Country[CL$Country == '.Poland'] <- 'Poland'
CL$Country <- gsub("\\.", " ", CL$Country)
CL$City <- gsub("\\.", " ", CL$City)

Cl_europa<-CL[tolower(CL$Country) %in% tolower(ES$Country),]

attach(Cl_europa)

row1<-c("Lausanne", "Switzerland",22.00,111.25,14.97,7.12,6.69,3.74,3.83,1.67,2.11,
        6.84,18.35,1.15,12.83,2.01,2.99,8.28,4.13,22.25,73.65,1.81,34829.41,
        1500.00,1275.00,2750.00,2360.00,254.53,0,57.50,68.60,39.00,19.47,99.55,50.83,
        128.33,187.50,15662.62,10748.91,5050.00,2.53,7.01,3.19,57.34,3.42,3.07,2.37,
        2.34,5.00,2.44,6.17,1.87,2.25,46.52,34554.13,2813.96,32033.15)

row2<-c("Luxembourg", "Luxembourg",19.87,88.12,10.25,5.14,5.90,3.25,3.00,1.10,2.37,
        3.18,19.87,0.92,8.67,1.61,1.95,5.21,2.00,11.66,35.24,1.33,25218,1638.89,1372.57,3112.50,
        2310.00,249.47,0,56.20,45.00,22.75,11.51,75.29,39.83,109.37,129.83,12430.57,9250.67,
        3832.24,1.75,3.50,3.00,30.25,2.39,2.27,1.91,1.70,3.39,2.46,4.09,1.32,1.82,18.88,27365.96,
        1207.29,16940.67)

row3<-c("Pristina", "Kosovo",3.88,17.50,3.19,1.47,1.52,0.77,0.62,0.86,0.42,
        1.16,3.50,0.42,3.33,0.73,0.90,2.73,0.40,2.64,12.40,1.17,20000,270.00,210.00,450.00,
        320.00,63.26,0,13.60,21.60,5.83,4.65,32.50,30,56.67,49.17,1491.67,788.33,
        464.17,4.21,2,0.73,5,0.64,0.94,0.47,0.50,1.04,1,0.62,0.96,0.50,6.50,21000,
        141.43,3866.67)

row4<-c("Skopje", "North Macedonia",5.40,20.61,3.84,1.74,1.93,1.21,0.86,0.84,0.50,
        1.55,5.30,0.42,4.60,0.79,1.06,2.39,0.60,4.59,23.80,1.12,29215,264.88,168.56,428.00,
        284.11,113,0,18.70,24.80,11.44,4.64,63.26,33.76,69.76,88.81,1334.64,976.22,
        438.55,4.99,0.97,0.57,6.49,0.81,1.04,0.52,0.44,1.33,1.06,1.03,1.02,0.60,7.01,25935.68,
        269.41,3845.83)

Cl_europa <- rbind(Cl_europa, row1)
Cl_europa <- rbind(Cl_europa, row2)
Cl_europa <- rbind(Cl_europa, row3)
Cl_europa <- rbind(Cl_europa, row4)

colnames(Cl_europa)[7] <- 'Imported Beer (0.33 liter bottle Restaurant)'

library(dplyr)

dati<-Cl_europa[,3:56]
dati <- dati %>%
  mutate(across(where(is.character), ~ as.numeric(as.character(.))))

Cl_europa[,3:56]<-dati

Cl_europa <- Cl_europa %>%
  group_by(Country) %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE))

write.csv(Cl_europa, file = 'data/NEW_DATASET/Cost_of_living_europe.csv', row.names = FALSE)

