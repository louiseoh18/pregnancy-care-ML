# Define and fit lasso regression

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
lasso_spec <- linear_reg(penalty = tune(), 
                         mixture = 1) |> 
  set_engine("glmnet") |> 
  set_mode("regression")
# define workflow
lasso_workflow1 <- workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(recipe1)
# hyperparameter tuning grid
lasso_params <- hardhat::extract_parameter_set_dials(lasso_spec)
# build tuning grid
lasso_grid <- grid_regular(lasso_params, levels = 5) 
# fit workflow/model
lasso_tuned1 <- lasso_workflow1 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = lasso_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
  )

## USING RECIPE 2 -----
# model specification
lasso_spec <- linear_reg(penalty = tune(), 
                         mixture = 1) |> 
  set_engine("glmnet") |> 
  set_mode("regression")
# define workflow
lasso_workflow2 <- workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(recipe2)
# hyperparameter tuning grid
lasso_params <- hardhat::extract_parameter_set_dials(lasso_spec)
# build tuning grid
lasso_grid <- grid_regular(lasso_params, levels = 5)
# fit workflow/model
lasso_tuned2 <- lasso_workflow2 |> 
  tune_grid(
    resamples = pregnancy_folds,
    grid = lasso_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
  )

# write out results (fitted/trained workflows) ----
save(lasso_tuned1, lasso_tuned2, file = here("results/tuned_lasso.rda"))
