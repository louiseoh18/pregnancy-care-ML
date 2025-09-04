# Define and fit ridge regression

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(glmnet)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# parallel over
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load training data
load(here("data_splits/pregnancy_split.rda"))
load(here("data_splits/pregnancy_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/pregnancy_recipes.rda"))

## USING RECIPE 1 -----
# model specification
ridge_spec <- linear_reg(penalty = tune(), 
                         mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")
# define workflow
ridge_workflow1 <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(recipe1)
# hyperparameter tuning grid
ridge_params <- hardhat::extract_parameter_set_dials(ridge_spec)
# build tuning grid
ridge_grid <- grid_regular(ridge_params, levels = 5)
# fit workflow/model
ridge_tuned1 <- ridge_workflow1 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = ridge_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
  )

## USING RECIPE 2 -----
# model specification
ridge_spec <- linear_reg(penalty = tune(), 
                         mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")
# define workflow
ridge_workflow2 <- workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(recipe2)
# hyperparameter tuning grid
ridge_params <- hardhat::extract_parameter_set_dials(ridge_spec)
# build tuning grid
ridge_grid <- grid_regular(ridge_params, levels = 5)
# fit workflow/model
ridge_tuned2 <- ridge_workflow2 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = ridge_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
  )

# write out results (fitted/trained workflows) ----
save(ridge_tuned1, ridge_tuned2, file = here("results/tuned_ridge.rda"))
