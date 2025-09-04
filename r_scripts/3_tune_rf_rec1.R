# Define and fit/tune random forest - recipe 2

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(ranger)

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

## USING RECIPE 1 tree -----
# model specification
rf_spec <- rand_forest(mode = "regression",
                       trees = 1000, 
                       min_n = tune(),
                       mtry = tune()) |> 
  set_engine("ranger")
# define workflow
rf_workflow1 <- workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe1_tree)
# hyperparameter tuning grid
hardhat::extract_parameter_set_dials(rf_spec)
# change hyperparameter range
rf_param1 <- parameters(rf_spec) |> 
  update(mtry = mtry(c(2, 30)),
         min_n = min_n(c(2, 30))) 
# build tuning grid
rf_grid1 <- grid_regular(rf_param1, levels = 5) 
# fit workflow/model
rf_tuned1 <- rf_workflow1 |> 
  tune_grid(
    pregnancy_folds, 
    grid = rf_grid1,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
    )

# write out results (fitted/trained workflows) ----
save(rf_tuned1, file = here("results/tuned_rf_rec1.rda"))
