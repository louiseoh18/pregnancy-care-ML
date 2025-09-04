# RECIPES

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(recipes)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/pregnancy_split.rda"))
load(here("data_splits/pregnancy_folds.rda"))

## RECIPE 1 for parametric -----
recipe1 <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  # remove unique ID, date variable, and status of nicu stay
  step_rm(osf_id, delivery_date, nicu_stay) |> 
  # impute missing variables using knn 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode,
                  delivery_month, delivery_year) |> 
  # dummy encode all nominal predictors
  step_dummy(all_nominal_predictors()) |> 
  # remove variables with zero variance
  step_zv(all_predictors()) |>
  # normalize all numeric data to be ~ N(0, 1)
  step_normalize(all_numeric_predictors())
prep(recipe1) |>
  bake(new_data = NULL) |> 
  glimpse()
# 37 columns

## RECIPE 1 for trees -----
recipe1_tree <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date, nicu_stay) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode,
                  delivery_month, delivery_year) |> 
  # one-hot encode dummy variables
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
prep(recipe1_tree) |>
  bake(new_data = NULL) |> 
  glimpse()
# 43 columns

## RECIPE 2 for parametric -----
recipe2 <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date, nicu_stay) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode,
                  delivery_month, delivery_year) |> 
  # apply square root transform to postnatal_depression for normality
  step_sqrt(postnatal_depression) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  # add interaction term between anxiety and depression levels
  step_interact(~ promis_anxiety:postnatal_depression) 
prep(recipe2) |>
  bake(new_data = NULL) |> 
  glimpse()
# 38 columns

## RECIPE 2 for trees -----
recipe2_tree <- recipe(birth_weight ~ ., data = pregnancy_train) |> 
  step_rm(osf_id, delivery_date, nicu_stay) |> 
  step_impute_knn(maternal_age, postnatal_depression, promis_anxiety, gestational_age, 
                  birth_length, threaten_life, threaten_baby_danger, threaten_baby_harm,
                  household_income, maternal_education, delivery_mode,
                  delivery_month, delivery_year) |> 
  # sqrt postnatal_depression for normality
  step_sqrt(postnatal_depression) |> 
  # one-hot encode dummy variables
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors()) 
prep(recipe2_tree) |>
  bake(new_data = NULL) |> 
  glimpse()
# 43 columns

# save recipes
save(recipe1, recipe1_tree, 
     recipe2, recipe2_tree, 
     file = here("recipes/pregnancy_recipes.rda"))
