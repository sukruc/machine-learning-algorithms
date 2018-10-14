# Random Forest Regression

#importing the dataset
dataset = read.csv('Position_Salaries.csv')
dataset =dataset[2:3]

# Encoding categorical data

# dataset$State = factor(dataset$State,
#                        levels = c('cat1','cat2','cat3'),
#                        labels = c(1, 2, 3))
# dataset$Purchased = factor(dataset$Purchased,
#                            levels = c('No', 'Yes'),
#                            labels = c(0, 1))

#taking care of missing data

# dataset$Age = ifelse(test = is.na(dataset$Age),
#                      ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
#                      dataset$Age)
# 
# dataset$Salary = ifelse(test = is.na(dataset$Salary),
#                         ave(dataset$Salary, FUN = function(x) mean(x, na.rm = TRUE)),
#                         dataset$Salary)

#Splitting the dataset into TRAINING SET and TEST SET

# install.packages('caTools')
# to execute library selection:
# library(caTools)
# set.seed(123)
# split = sample.split(dataset$Profit, SplitRatio = 0.8)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)

# Feature Scaling

# training_set[, 2:3] = scale(training_set[, 2:3])
# test_set[, 2:3] = scale(test_set[, 2:3])

# Fitting the Random Forest Regression to the dataset
install.packages('randomForest')
library(randomForest)
set.seed(1234)
regressor = randomForest(x = dataset[1],
                         y = dataset$Salary,
                         ntree = 1000)

# Predicting a new result
y_pred = predict(regressor, data.frame(Level = 6.5))


# Fitting polynomial model to the dataset
# We need to add squared levels to our dataset

# dataset$Level2 = dataset$Level^2
# dataset$Level3 = dataset$Level^3
# dataset$Level4 = dataset$Level^4
# regressor = lm(formula = Salary ~ .,
#                data = dataset)
# summary(regressor)

# Visualizing Polynomial regressor results

X_grid = seq(from = min(dataset$Level), to = max(dataset$Level), by = 0.001)

ggplot() +
  geom_point(aes(x = dataset$Level, y = dataset$Salary),
             color = 'red') +
  geom_line(aes(x = X_grid, y = predict(regressor, newdata = data.frame(Level = X_grid))),
            color = 'blue') +
  ggtitle('Salary vs Level (Random Forest Regression)') +
  xlab('Level') +
  ylab('Salary')
  
  
  #PRedicting a new result with Polynomial Regression
  y_pred_poly = predict(regressor, data.frame(Level = 6.5))
