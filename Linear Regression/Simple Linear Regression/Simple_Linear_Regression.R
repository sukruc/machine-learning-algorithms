# Data Preprocessing Template

# Import the dataset
dataset = read.csv('Salary_Data.csv')

# Taking care of the missing data
# dataset$Age = ifelse(is.na(dataset$Age),
#                     ave(dataset$Age, FUN = function(x) mean(x, na.rm = TRUE)),
#                     dataset$Age)

# dataset$Salary = ifelse(is.na(dataset$Salary),
#                        ave(dataset$Salary, FUN = function(x) mean(x, na.rm = TRUE)),
#                        dataset$Salary)

# Encoding categorical data
# dataset$Country = factor(dataset$Country,
#                         levels = c('France', 'Spain', 'Germany'),
#                         labels = c(1,2,3))

# dataset$Purchased = factor(dataset$Purchased,
#                           levels = c('No', 'Yes'),
#                           labels = c(0,1))

# Splitting the dataset into the Training set and Test set

# install required packages, if not already available

# install.packages('caTools')
# library(caTools)
set.seed(123)
split = sample.split(dataset$Salary, SplitRatio = 2/3)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature Scaling - not required when performing linear regression with 1 variable
#training_set[, 1] = scale(training_set[, 2:3])
#test_set[, 1] = scale(test_set[, 2:3])

# Fitting Simple Linear Regression to the Training Set

regressor = lm(formula = Salary ~ YearsExperience, 
               data = training_set)

summary(regressor)

# Predicting the Test set results
y_pred = predict(regressor, newdata = test_set)

# Visualizing test set results
#install.packages('ggplot2')
#library(ggplot2)
ggplot() +
  geom_point(aes(x = training_set$YearsExperience, y = training_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary vs Experience') +
  xlab('Years of Experience') +
  ylab('Salary')

# Visualizing training set results
ggplot() +
  geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary),
             colour = 'red') +
  geom_line(aes(x = training_set$YearsExperience, y = predict(regressor, newdata = training_set)),
            colour = 'blue') +
  ggtitle('Salary vs Experience (Test Set)') +
  xlab('Years of Experience') +
  ylab('Salary')
