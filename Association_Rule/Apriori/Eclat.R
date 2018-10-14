# Eclat (Ekla)
# This is a simplified version of Apriori model

# Data Preprocessing
# install packages
library(arules)
dataset = read.csv('Market_Basket_Optimisation.csv', header = FALSE)
dataset = read.transactions('Market_Basket_Optimisation.csv', sep = ',' , rm.duplicates = TRUE)
summary(dataset)
itemFrequencyPlot(dataset, topN = 20)

# Training Eclat on the dataset
rules = eclat(data = dataset, parameter = list(support = 0.004, minlen = 2))

# Visualizing the results
inspect(sort(rules, by = 'support')[1:10])

# Now we only have set of products that have been bought together