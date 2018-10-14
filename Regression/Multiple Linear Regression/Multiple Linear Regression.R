#Multiple Linear Regression

# Data Preprocessing
# no need to import any libraries for pre-processing

#importing the dataset
dataset = read.csv('50_Startups.csv')

# Encoding categorical data
dataset$State = factor(dataset$State,
                         levels = c('New York','California','Florida'),
                         labels = c(1, 2, 3))

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
install.packages('caTools')

#to execute library selection:
library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

#Feature Scaling
# training_set[, 2:3] = scale(training_set[, 2:3])
# test_set[, 2:3] = scale(test_set[, 2:3])


#Fitting Multiple Linear Regressor to the Training Set
#Profit ~ . = Profit ~ iv1 + iv2 + iv3 + ... + iv_n
regressor = lm(formula = Profit ~ .,
               data = training_set)
summary(regressor)

#Predicting the Test set Results
y_pred = predict(regressor, newdata = test_set)

#Visualizing the Training set results
# install.packages('ggplot2')
# library(ggplot2)
# ggplot() +
#   geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
#              color = 'red') +
#   geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
#             color = 'blue') +
#   ggtitle('Salary vs Experience (Training Set)') +
#   xlab('Years of Experience') +
#   ylab('Salary')
# 
# ggplot() +
#   geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
#              color = 'red') +
#   geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
#             color = 'blue') +
#   ggtitle('Salary vs Experience (Test Set)') +
#   xlab('Years of Experience') +
#   ylab('Salary')