# Used-Car-Pricing-Analysis

The concept fo car sales is dependent on many factors. For example, internal (specific features of that car), and external (life events happening at that point in time). The predictive advantage of data analysis allows us to estimate the prospective cost of a car, in this case, a used car, using its internal aspects. Thereupon, providing conducive decision-making information to either car dealerships and/or individuals. This information would be used for buying and/or selling purposes. 

# Objective

I was interested in this project to gain a better understanding of the factors that affect the pricing and performance of used cars. As such, I performed various data analytics tasks, then made interpretations to satisfy my research objectives. The objective was to figure out which characteristics pose the most/least influence on price, predict the carbody type for consumer preferences, make predictions of the price of user cars, and finally to partition cars into groups based on similarities. The models built were Correlation Matrix, Decision Tree, Multiple Linear Regression, and K-means Clustering. Additionally, performed each analysis in several ways, to yield the best result for our interpretations.


# Data Cleaning

Our dataset contains many variables. However, the most applicable are those that seem to have the most influence on the final price of a car. I will perform our analysis using 17 variables, some of which are either qualitative or quantitative in an nature. The variables that go no significance to the model will be neglected. The dataset originally had 27 variables (columns) and 205 observations. For our data cleaning, we decided the variables "car_ID and "symbolying" were redundant, so we removed them. This left us with 25 variables. The most important was "price," because it was used in all data analysis tasks. 

# Key Findings

## Which characteristic pose the most/least influence on price?

<img width="544" height="425" alt="Screenshot 2026-10-30 at 1 45 05 PM" src="https://github.com/user-attachments/assets/690d7535-cae4-4b1a-8772-3d3b6862a086" />

Correlation Matrix
- Purpose was to choose the correlated variables for our predictive models
- The highest associated variables to price and carbody
  - Price = enginesize + horsepower + curbweight
  - Carbody = doornumber + carlength + carheight + wheelbase


<img width="554" height="466" alt="Screenshot 2026-10-30 at 1 46 25 PM" src="https://github.com/user-attachments/assets/f7140a11-f4f6-41b8-8acd-7e790a903c60" />

Scatter Plot
- To provide visualization that will aid in stating the directional relationship. Also sourcing Linearity, Independence, and Equal Variance Assumptions
- All graphs are linear with positive relationships about x & y
- However, there seems to be a violation of Equal Variance and Independence
- There are a couple of outliers in each plot
- Overall, this demonstrates that these variables have a strong enough relationship to use within our predictive model. The Matrix denots the percentage relationship of engine-size, horsepower, and curb-weight are 87%, 81%, 85% respectively

## Predict a carbody suggestion based on consumers' criteria, for the use of sales

<img width="554" height="291" alt="Screenshot 2026-10-30 at 1 49 50 PM" src="https://github.com/user-attachments/assets/d9eed37c-8af3-4279-9215-aeff6412e993" />

Decision Tree
- Decision Node
  - Does the car have two doors? If yes go left. 44% of "hatchbacks" had two doors, with a high car body predicted probability of 67% or a low of 7%. If no go right. 56% of "sedans" had four doors, with a high carbody predicted probability of 70% or a low of 8%.
- Terminal Node
  - Is the price of the car greater than or equal to $32,000? If yes go left. 3% of "hardtops" satisfied this condition, with a high predicted probability of 49%, or a low of 29%. If no go right. 40% of "hatchbacks" cost disagreed with this condition, with a high predicted probability of 72% or a low of 5%.
  - Is the car's height less than 57? If yes go left. 50% of "sedans" satisfied this condition, with a high predicted probability of 78% or a low of 10%. If no go right. 6% of "wagons" satisfied this condition, with a high predicted probability of 100% or a low of 0%.
 
<img width="532" height="188" alt="Screenshot 2026-10-30 at 1 54 53 PM" src="https://github.com/user-attachments/assets/12cf595e-ccee-44d5-96ee-354290e9f772" />

Confusion Matrix of Pruned Decision Tree
- The accuracy was moderate but we wanted to do better

<img width="492" height="677" alt="Screenshot 2026-10-30 at 1 55 50 PM" src="https://github.com/user-attachments/assets/1212d720-24b4-4044-88fb-0ed9f1e29d73" />

Random Forest Confusion Matrix
- The purpose was to have the advantages to prevent overfitting and be more accurate in predictions.
- The best our model could achieve was 76% accuracy. Perhaps this is due to the relationships between carbody and variables were not statistically high. Though these used within the decision were the highest of all other variables within the matrix.


<img width="508" height="398" alt="Screenshot 2026-10-30 at 1 58 26 PM" src="https://github.com/user-attachments/assets/07080865-cf8e-4f20-91de-c5d4e6bb7883" />

Trained Random Forest
- To test the predictive potency of the Random Forest Model we designed
- The trained Random Forest Tree was able to predict the carbody with 100% accuracy. The Prediction Reference denotes that when the model tried to predict "convertible," it was indeed "convertible" 3 times and no other carbdoy. This was also for the other car bodies.

<img width="452" height="229" alt="Screenshot 2026-10-30 at 2 00 19 PM" src="https://github.com/user-attachments/assets/a8721881-70f8-4453-b646-f233774c938f" />

Variable Importance
- To get the significance of the variable during the prediction of the sample of from Random Forest.
- The Variable Importance chart states that the top three features that aid the prediction were "carheight," "doornumber," and "price."


## Make predictions of the price of used cars

<img width="562" height="755" alt="Screenshot 2026-10-30 at 2 02 01 PM" src="https://github.com/user-attachments/assets/acce276d-547d-4f41-a501-2f913252dc1e" />

Multiple Linear Regression
- This sample model would help consumers and car dealerships to have a reasonable price for used cars. So, no one is at a disadvantage.
- R-squared: 83% of the variability of the PRICE is attributed for, through the explanatory variables [carwdith, enginesize, stroke. fueltype, horsepower]
- Adjusted R Square: 82.7% for statistical inference, this is high and was the reason this model was selected opposed to the others that had lower percentages.
- F-statistics:  140.5 > 1. This proves that there is a relationship between the response and some of the explanatory variables
- Significance F: <2.2e-16 is the p-value of the F-statistics. It is < 0.05 which indicates the Ha is true. Concluding there are relationships, and this is unlikely to have occurred by chance alone.
- Coefficients:
  - Intercept: -3.125e+04 is the starting price when x = 0. This has no practical meaning because no one can pay negative dollars for a car.
  - Estimates of x variables: Carwidth and price have a positive relationship, such that ea. 1 unit increase in carwidth increases price by 5.777e+02, while other variables remain fixed. This goes for all other variables with positive coefficiencts. Stroke and price have a negative relationship such that ea. 1 unit increas in stroke decreases price by -2.660e+03, while other variables remain fixed. This goes for all other variables with positive coefficents.
- P-values: "caright," "enginesize," "stroke," "fueltype," "horsepower" state the relevance and relationship to the prediction of price. Whereas the remaining variables add no significance, despite them being statistically significant in the other two models. Overall, these outputs suggest that the model has a reasonably great fit for the data. This is based on the statistically relationships between the response and the explanatory variables.

## Partition cars into groups based on similarities and dissimilarities

<img width="473" height="319" alt="Screenshot 2026-10-30 at 2 13 45 PM" src="https://github.com/user-attachments/assets/6333fdcc-11df-47ea-9420-0a567298857a" />

K-Means Clustering
- There seem to be some cars that overlap in clusters 1, 2, and 3. Thus, no cluster is mutually exclusive. Majority of the observations belong to Cluster 1, then Cluster 2, then Cluster 3. Specifically 124 cars, 64 cars, and 17 cars respectfully.


<img width="456" height="415" alt="Screenshot 2026-10-30 at 2 19 59 PM" src="https://github.com/user-attachments/assets/389ec192-9e74-4b7e-890b-f1d0865251e1" />

Multiple K-Means Clustering
- To ascertain that K=3 was indeed optimal comparing it to other Ks
- Cluster 3 has a smoother clustering pattern, thus it is indeed the optimal k.

<img width="495" height="216" alt="Screenshot 2026-10-30 at 2 21 07 PM" src="https://github.com/user-attachments/assets/b509b23f-e471-41d1-b75c-2920b67ee570" />

Cluster Centers of K=3
- Noticeably cluster 3 on average had cars with higher averages for each feature
- The cars in cluster 3 cost the most, but traveled the shortest distance, as per their city, and highway mpgs
- Also they had the highest horsepower, which meant they have the largest enginesize, making them the least fuel efficient
- On average, they were bigger in body
- According to the decision tree, "Hardtops" contribute to the previously stated. From a marketing and sales perspective, we would neglect to have these models. They cost the most, travel the least, and are the least fuel efficient.

# Conclusion

Our objective was to perform some data analytical tasks for a cars-dataset. First, we created a Correlation Matrix to view the linear relationship and strengths between variables. The result from this influenced the variables we used within our Decision Tree and Multiple Linear Regression. Secondly, we modeled a Decision Tree to predict the carbody type, to aid in consumers' decision-making. The accuracy rate wasn't high enough, even after pruning, so we built a Random Forest that had a slightly higher accuracy. This gave the probability of the carbody being selected and its contributing percentage. Thirdly, we performed a Multiple Linear Regression, purposely to predict the price of used cars. With 17 variables, we ran three individual models and selected the one with the highest R-squared and Adjusted R-squared. From this, we learned that the prices of the used car are more dependent on performance-based features, rather than aesthetical features. Lastly, we clustered cars based on similarities and dissimilarities, through K-Means Clustering method. Here, the clusters occurred with the prediction of the decision tree. Specifically, "Hardtops" were the most expensive. So too, the cluster this car is in, has the greatest horsepower, lowest fuel efficiency, and shortest traveling distance.


