# SVM
# Logistic Regression

#importing the dataset
dataset = read.csv('Social_Network_Ads.csv')
dataset =dataset[3:5]

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
library(caTools)
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature Scaling

training_set[, 1:2] = scale(training_set[, 1:2])
test_set[, 1:2] = scale(test_set[, 1:2])

# Creating and Fitting SVM to the Training Set
library(e1071)
classifier = svm(formula = Purchased ~ . ,
                 data = training_set,
                 type = 'C-classification' ,
                 kernel = 'linear')


# Predicting the Test Set Results
y_pred = predict(classifier, newdata = test_set[-3])

# Making the Confusion Matrix
cm = table(test_set[ ,3], y_pred)

# Visualizing the Training Set Results
# install.packages('ElemStatLearn')
library(ElemStatLearn)
set = training_set
X1 = seq(min(set[ ,1]) - 1, max(set[ , 1]) + 1, by=0.01)
X2 = seq(min(set[ ,2]) - 1, max(set[ , 2]) + 1, by=0.01)
grid_set = expand.grid(X1,X2)
colnames(grid_set) = c('Age','EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3],
     main = 'SVM (Training Set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1) , ylim = range(X2))
contour(X1,X2,matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg= ifelse(set[, 3] == 1, 'green4', 'red3'))

# Visualizing the Test Set Results

set = test_set
X1 = seq(min(set[ ,1]) - 1, max(set[ , 1]) + 1, by=0.01)
X2 = seq(min(set[ ,2]) - 1, max(set[ , 2]) + 1, by=0.01)
grid_set = expand.grid(X1,X2)
colnames(grid_set) = c('Age','EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3],
     main = 'Logistic Regression (Test Set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1) , ylim = range(X2))
contour(X1,X2,matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg= ifelse(set[, 3] == 1, 'green4', 'red3'))

# X_grid = seq(from = min(dataset$), to = max(dataset$Level), by = 0.001)
# 
# ggplot() +
#   geom_point(aes(x = dataset$Level, y = dataset$Salary),
#              color = 'red') +
#   geom_line(aes(x = X_grid, y = predict(regressor, newdata = data.frame(Level = X_grid))),
#             color = 'blue') +
#   ggtitle('Salary vs Level (Random Forest Regression)') +
#   xlab('Level') +
#   ylab('Salary')