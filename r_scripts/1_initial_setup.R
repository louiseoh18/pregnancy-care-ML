# DATA SPLITTING

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load clean data
load(here("data/pregnancy_clean.rda"))

# split data
pregnancy_split <- initial_split(pregnancy, prop = 0.8, strata = birth_weight)
pregnancy_train <- training(pregnancy_split)
pregnancy_test <- testing(pregnancy_split)

# set up folds
pregnancy_folds <- vfold_cv(pregnancy_train, v = 10, repeats = 5, strata = birth_weight)

# save datasets
save(pregnancy_train, pregnancy_test, pregnancy_folds, file = here("data_splits/pregnancy_split.rda"))
save(pregnancy_folds, file = here("data_splits/pregnancy_folds.rda"))
