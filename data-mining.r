#install packages to conduct data analysis
install.packages(c("ggplot2", "gcookbook", "MASS", "dplyr","tidyverse","regclass","rpart"))
#to install libraries in order to run the visualizations and further analysis
library(tidyverse);library(regclass);library(ggplot2);library(dplyr); library(datasets)
library(caret);library(grid);library(gridExtra);library(GGally);library(rpart);library(corrplot)
library(rpart.plot);library(cluster);library(rattle);library(NbClust)
CarPrice_Assignment <- CarPrice_Assignment[, -c(1,2)]#To remove unnecessary variables
CarPrice_Assignment.copy <- CarPrice_Assignment #To create a copy of the dataset
#------------------------------------------------------------------------------------------
#ANALYSIS 1 CORRELATION MATRIX
#To convert all character variables to numeric
CarPrice_Assignment.copy <- CarPrice_Assignment.copy %>%
mutate_at(vars(carbody,fueltype,doornumber,cylindernumber),as.numeric)
#To identify the numeric columns
car_numeric <- sapply(CarPrice_Assignment.copy, is.numeric)
#To store only the numeric columns in the new data frame
car_numeric <- CarPrice_Assignment.copy[, car_numeric]
#To store the Correlation Matrix into an object
CPA_matrix <- cor_matrix(car_numeric)
#To set graphical parameters to reduce plot size & adjust the margin sizes
par(mar = c(8, 6, 8, 8))
corrplot(CPA_matrix, method = "number") #To print the CORRELATION MATRIX plot
#-------- Scatterplots of CORRELATION
#To set up parameters for the scatterplots
fig <- function(width, heigth)
{options(repr.plot.width = width, repr.plot.height = heigth)}
fig(10, 6)
#To parameters to get the scatterlots
fig_1 <- CarPrice_Assignment.copy %>%
group_by(carbody, enginesize, horsepower) %>% ggplot(aes(enginesize, horsepower, color =
carbody)) +
geom_point() + theme_minimal() +
theme(legend.position = "none") + labs(title = "")
fig_2 <- CarPrice_Assignment.copy %>%
group_by(carbody, horsepower, price) %>% ggplot(aes( horsepower, price, color = carbody)) +
geom_point() + theme_minimal() +
theme(legend.position = "none") + labs(title = "")
fig_3 <- CarPrice_Assignment.copy %>%
group_by(carbody, curbweight, horsepower) %>% ggplot(aes(curbweight, horsepower, color =
carbody)) +
geom_point() + theme_minimal() +
theme(legend.position = "none") + labs(title = "")
fig_4 <- CarPrice_Assignment.copy %>%
group_by(carbody, enginesize, price) %>% ggplot(aes(enginesize, price, color = carbody)) +
geom_point() + theme_minimal() +
theme(legend.position = "none") + labs(title = "")
grid.arrange(fig_1, fig_2, fig_3, fig_4, ncol = 2) #print side by side scatterplots 2:2

#----------------------------------------------------------------------------------
#ANALYSIS 2 - DECISION TREE
table(CarPrice_Assignment$carbody ) #to get the frequencies of the car bodies
#To ensure the same result with reproducibility
set.seed(522)
#To return a uniform distribution generating n uniform random numbers between 0 and 1
#taking vectors as all its arguments, conditionally splitting into 75-25 ratio
CarPrice_Assignment[, 'train'] <- ifelse(runif(nrow(CarPrice_Assignment)) < 0.75, 1, 0)
training_Set <- CarPrice_Assignment[CarPrice_Assignment$train == 1,]
testing_Set <- CarPrice_Assignment[CarPrice_Assignment$train == 0, ]
#To fix the dataset
trainColNum <- grep('train', names(training_Set)); trainColNum
#To remove the train column from training and testing datasets
training_Set <- training_Set[, -trainColNum]
testing_Set <- testing_Set[, -trainColNum]
#To set up the parameters for the tree
tree_Fit_mod <- rpart(carbody ~ price + doornumber + carlength + carheight + wheelbase,
data = CarPrice_Assignment, method = "class",cp=0.01); print(tree_Fit_mod)
rattle::fancyRpartPlot(tree_Fit_mod, type = 1, sub = "") #print fancier version of decision
tree
rpart.plot(tree_Fit_mod) #print alternative version, less fancy
#To set up the parameters to run a prediction on test dataset via confusion matrix
Prediction1 <- predict(tree_Fit_mod,newdata=testing_Set[-5],type = 'class')
confusionMatrix(Prediction1,testing_Set$carbody) # Print the confusion matrix to check the
accuracy
#To prune the decision tree
printcp(tree_Fit_mod)
tree_fit_mod.1 <- which.min(tree_Fit_mod$cptable[,'xerror'])
cp_tree_mod <- tree_Fit_mod$cptable[tree_fit_mod.1, 'CP']
pruned_modeltree <- prune(tree_Fit_mod,cp_tree_mod)
rpart.plot(pruned_modeltree, box.col=c("red", "green")) #plot the pruned tree
Prediction2 <- predict(pruned_modeltree,newdata=testing_Set[-5],type = 'class') #To setup the
prediction parameters
mn002 <- mean(Prediction2==testing_Set$carbody);mn002
confusionMatrix(Prediction2,testing_Set$carbody) #To print the decision tree
#----------------------------------
#RANDOM FOREST
# Train/validation split
set.seed(123) # for reproducibility
idx_randtree <- createDataPartition(factor(CarPrice_Assignment$carbody),times = 1,p = 0.5,list
= FALSE)
train2set <- CarPrice_Assignment[idx_randtree,]
validation_set_carbody <- CarPrice_Assignment[-idx_randtree,] %>% select(-carbody)
validation_labels_carbody <- CarPrice_Assignment[-idx_randtree,] %>% select(carbody)
#To train our model.
control_carbody <- trainControl(method = "cv",verboseIter = TRUE, savePredictions = "final",
classProbs = TRUE)
set.seed(123)
#To set yp the paramters for the random forest model
rand_modeling1 <- train(carbody ~ price + doornumber + carlength + carheight + wheelbase,

data = CarPrice_Assignment, method = "rf", trControl = control,
maximize = TRUE, tuneGrid = data.frame(mtry = 4)); rand_modeling1 #call the

function
confusionMatrix.train(rand_modeling1)
val_preds_carbody <- predict(rand_modeling1, validation_set_carbody)
confusionMatrix(val_preds_carbody, validation_labels_carbody$carbody)
varImp(rand_modeling1)
#----------------------------------------------------------------------------------------
#ANALYSIS II - MULTIPLE LINEAR REGRESSION
#MLR 1 to predict the price of a used car
lmcars1 <- lm(price~fueltype+carbody+horsepower+

peakrpm+citympg+highwaympg, data=CarPrice_Assignment.copy)

summary(lmcars1) #1st regression analysis
#MLR 2 with different variables
lmcars2 <- lm(price~wheelbase+carlength+carwidth+carheight+curbweight

+enginesize+boreratio+stroke+compressionratio+doornumber+cylindernumber,
data=CarPrice_Assignment.copy); summary(lmcars2)

#MLR 3 with significant variaables from MLR 1 & 2
lmcars3 <- lm(price~carwidth+curbweight+enginesize+stroke+fueltype
+horsepower+highwaympg, data = CarPrice_Assignment.copy)

summary(lmcars3) #official MLR w/ highest adjusted R-square
#ANALYSIS II - MULTIPLE LINEAR REGRESSION
#MLR 1 to predict the price of a used car
lmcars1 <- lm(price~fueltype+carbody+horsepower+

peakrpm+citympg+highwaympg, data=CarPrice_Assignment.copy)

summary(lmcars1) #1st regression analysis
#MLR 2 with different variables
lmcars2 <- lm(price~wheelbase+carlength+carwidth+carheight+curbweight

+enginesize+boreratio+stroke+compressionratio+doornumber+cylindernumber,
data=CarPrice_Assignment.copy); summary(lmcars2)

#MLR 3 with significant variaables from MLR 1 & 2
lmcars3 <- lm(price~carwidth+curbweight+enginesize+stroke+fueltype
+horsepower+highwaympg, data = CarPrice_Assignment.copy)

summary(lmcars3) #official MLR w/ highest adjusted R-square
anova(lmcars3) #ANOVA for lmcars3
#---------------------------------------------------------------------------------------
#ANALYSIS III -Kmeans clustering
install.packages("NbClust"); install.packages("factoextra"); install.packages("cluster")
library(NbClust); library(factoextra); library(cluster)
set.seed(1234)
#To pre-process the data
scaled_cars <- scale(car_numeric)
#To determine the optimal number of clusters needed
opt_clusters <- NbClust(car_numeric, min.nc = 2, max.nc = 5, method = "kmeans");opt_clusters
#To get the optimal number graphically
barplot(table(nc$Best.n[1,]),
xlab="Numer of Clusters", ylab="Number of Criteria",
main="Number of Clusters Chosen by 26 Criteria")
table(nc$Best.n[1,]) #print a bar graph of suggested k number
km003 <-kmeans(car_numeric, centers = 3, nstart = 25) #construct the kmeans
#To print the cluster
plot_km003 <- fviz_cluster(km003, geom = "point", data = car_numeric, xlab = "", ylab = "") +
ggtitle("k = 3"); plot_km003 #kmeans visual

km003$centers #To get the cluster center of the optimal suggestion
aggregate(car_numeric, by=list(cluster=km003$cluster), mean) #To get the mean of the
head(km003$cluster, 4)
# Cluster number for each of the observations
km003$cluster
# Cluster size
km003$size
# Cluster means
km003$centers
#To create other clusters with different "k"
km002 <-kmeans(car_numeric, centers = 2, nstart = 25)
km004 <- kmeans(car_numeric, centers = 4, nstart = 25)
km005 <- kmeans(car_numeric, centers = 5, nstart = 25)
#To compare clusters with different "k"
plot_km002 <- fviz_cluster(km002, geom = "point", data = car_numeric,xlab = "", ylab = "") +
ggtitle("k = 2")
plot_km004 <- fviz_cluster(km004, geom = "point", data = car_numeric,xlab = "", ylab = "") +
ggtitle("k = 4")
plot_km005 <- fviz_cluster(km005, geom = "point", data = car_numeric,xlab = "", ylab = "") +
ggtitle("k = 5")
install.packages("gridExtra")
library(gridExtra)
grid.arrange(plot_km002, plot_km003, plot_km004, plot_km005, nrow = 2) #print the comparison
visuals
#----------------------------------------------------------------------------------------
