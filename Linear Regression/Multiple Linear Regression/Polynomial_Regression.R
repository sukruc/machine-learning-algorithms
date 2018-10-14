#Polynomial Regression

# Data Preprocessing
# no need to import any libraries for pre-processing

#importing the dataset
dataset = read.csv('Position_Salaries.csv')
dataset =dataset[2:3]

# Encoding categorical data
# dataset$State = factor(dataset$State,
#                        levels = c('New York','California','Florida'),
#                        labels = c(1, 2, 3))

#taking care of missing data
# dataset$Age = ifelse(test = is.na(dataset$Age),
#                      ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
#                      dataset$Age)
# 
# dataset$Salary = ifelse(test = is.na(dataset$Salary),
#                         ave(dataset$Salary, FUN = function(x) mean(x, na.rm = TRUE)),
#                         dataset$Salary)



# dataset$Purchased = factor(dataset$Purchased,
#                            levels = c('No', 'Yes'),
#                            labels = c(0, 1))

#Splitting the dataset into TRAINING SET and TEST SET
# install.packages('caTools')

#to execute library selection:
# library(caTools)
# set.seed(123)
# split = sample.split(dataset$Profit, SplitRatio = 0.8)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)

#Feature Scaling
# training_set[, 2:3] = scale(training_set[, 2:3])
# test_set[, 2:3] = scale(test_set[, 2:3])


#Fitting Linear Regressor to the Training Set
#Profit ~ . = Profit ~ iv1 + iv2 + iv3 + ... + iv_n
lin_reg = lm(formula = Salary ~ Level,
               data = dataset)
summary(lin_reg)

#Excluding the iv with highest p-value
# regressor = lm(formula = Profit ~ R.D.Spend + Administration + Marketing.Spend,
#                data = dataset)
# summary(regressor)

#Excluding the iv with highest p-value
# regressor = lm(formula = Profit ~ R.D.Spend + Marketing.Spend,
#                data = dataset)
# summary(regressor)

#Predicting the Test set Results
# y_pred = predict(regressor, newdata = test_set)

#Automatic Implementation of Backward Elimination

'backwardElimination <- function(x, sl) {
numVars = length(x)
for (i in c(1:numVars)){
regressor = lm(formula = Profit ~ ., data = x)
maxVar = max(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"])
if (maxVar > sl){
j = which(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"] == maxVar)
x = x[, -j]
}
numVars = numVars - 1
}
return(summary(regressor))
}

SL = 0.05
dataset = dataset[, c(1,2,3,4,5)]
backwardElimination(training_set, SL)'

# Fitting polynomial model to the dataset
#We need to add squared levels to our dataset

dataset$Level2 = dataset$Level^2
dataset$Level3 = dataset$Level^3
dataset$Level4 = dataset$Level^4
dataset$Level5 = dataset$Level^5
dataset$Level6 = dataset$Level^6
dataset$Level7 = dataset$Level^7
poly_reg = lm(formula = Salary ~ .,
               data = dataset)
summary(poly_reg)


# Visualizing the Linear Regression Results
install.packages('ggplot2')
library(ggplot2)
ggplot() +
  geom_point(aes(x = dataset$Level, y = dataset$Salary),
             color = 'red') +
  geom_line(aes(x = dataset$Level, y = predict(lin_reg, newdata = dataset)),
            color = 'blue') +
  ggtitle('Salary vs Level (Linear Model)') +
  xlab('Level') +
  ylab('Salary')
# 
X_grid = seq(from = min(dataset$Level), to = max(dataset$Level), by = 0.1)


ggplot() +
  geom_point(aes(x = dataset$Level, y = dataset$Salary),
             color = 'red') +
  geom_line(aes(x = X_grid, y = predict(poly_reg, data.frame(Level = X_grid,
                                                             Level2= X_grid^2,
                                                             Level3= X_grid^3,
                                                             Level4= X_grid^4,
                                                             Level5= X_grid^5,
                                                             Level6= X_grid^6,
                                                             Level7= X_grid^7))),
            color = 'blue') +
  ggtitle('Salary vs Level (Polynomial Model)') +
  xlab('Level') +
  ylab('Salary')

# Predicting a new result with Linear Regressor

y_pred_lin = predict(lin_reg, data.frame(Level = 6.5))

#PRedicting a new result with Polynomial Regression
y_pred_poly = predict(poly_reg, data.frame(Level = 6.5,
                                           Level2= 6.5^2,
                                           Level3= 6.5^3,
                                           Level4= 6.5^4,
                                           Level5= 6.5^5,
                                           Level6= 6.5^6,
                                           Level7= 6.5^7))