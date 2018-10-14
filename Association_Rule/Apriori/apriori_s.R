#Apriori

#DATA PREPROCESSING

#install.packages('arules')
library(arules)
dataset = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',', rm.duplicates = TRUE) 
#duplicates must be removed in sparse matrix
summary(dataset) #gives a summary of the dataset
itemFrequencyPlot(dataset, topN = 10)

# Training Apriori on the dataset
rules = apriori(dataset, parameter = list(support = 0.003, confidence = 0.8 )) 
#support: minimal for rarely purchased elements
#refer to itemFrequencyPlot, we've chosen our min.support value based on items bought 3 times a day:
# 3*7/7500 = 0.0028
#If we're not satisfied with the increase in revenue, we may change minimum support later
#If we set a confidence value too high, it gives too obvious rules which actually doesn't need a machine learning algorithm
#If we set the conf. value too low, the machine may give out irrelevant rules

#At confidence val 0.8, we couldn't be able to get any rules, let's decrease the confidence
rules = apriori(dataset, parameter = list(support = 0.003, confidence = 0.4 ))

# Algorithm:
#   Step 1 - Set a minimum support and confidence
#   Step 2 - Take all the subsets in transactions having higher support than the minimum support
#   Step 3 - Take all the rules of these subsets having higher confidence than minimum confidence
#   Step 4 - Sort the rules by decreasing lift

# Visualising the results
inspect(sort(rules, by = 'lift')[1:10]) # Take a look at the first [1:n] rules, that are sorted in decreasing lift order

rules = apriori(dataset, parameter = list(support = 0.003, confidence = 0.2 ))
inspect(sort(rules, by = 'lift')[1:10])
#Let's take a look at the products bought 4 times a day: 4*7/7500
rules = apriori(dataset, parameter = list(support = (0.004), confidence = 0.2 ))
inspect(sort(rules, by = 'lift')[1:10])
#Now, the person in charge needs to test these new rules by placing those products together 
#     and observing the change insrevenue