# Load library
library(data.table)
library(funModeling)
library(Hmisc)
library(ggplot2)

# Read data
df <- fread("owid-covid-data.csv")
View(df)

# Get to know dataset (null values, data type, etc)
nrow(df) #167481
ncol(df)  #67
df_status(df)
# Different ways to find null 
#df[, lapply(.SD, function(x) sum(is.na(x))/ nrow(dt))]
#sum(is.na.data.frame(df))
#lapply(df,function(x) { length(which(is.na(x)))})
#summary(df)
#colSums(is.na(df))

# Plot freq for categorical
freq(df)
# Numerical
plot_num(df)

# Statistic summary numerical variables | variation_coef signifies presence of outliers
profiling_num(df[,.(male_smokers, female_smokers)])
#View(profiling_num(df[,.(male_smokers, female_smokers)]))

# Create dataset for vietnam
vn <-df[location == 'Vietnam']
vn <- df[location == 'Vietnam', .(iso_code, location, date, total_vaccinations, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred)]
vn
vn <-vn[complete.cases(vn)] # Drop na (vn <- vn[!is.na(total_vaccinations)])
vn

# Visualization
vnplot <- ggplot(data = vn, aes(x = date, y = people_vaccinated_per_hundred, color = location))
vnplot + geom_line(size = 2) + scale_y_continuous(breaks=c(0,20,40,60), labels = scales::comma) 
vnplot + labs(titles = '% of vaccinated people in the Vietnam', x = 'Date', y = '% vaccinated people')

# Visualization Vietnam with other countries
countries <- ggplot(data = df[location %in% c("Vietnam", "Thailand", "China") & !is.na(people_vaccinated_per_hundred)], aes(x = date, y = people_vaccinated_per_hundred, color = location))
countries + geom_line(size=2) + scale_y_continuous(breaks=c(0,20,40,60), labels= scales::comma) 
countries + labs(titles = '% of vaccinated people in the Vietnam, Thailand, and China', x = 'Date', y = '% vaccinated people')

