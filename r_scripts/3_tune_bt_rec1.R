# Define and fit boosted tree model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)

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
bt_spec <- boost_tree(mode = "regression",
                      trees = 1000,
                      min_n = tune(),
                      mtry = tune(), 
                      learn_rate = tune()) |> 
  set_engine("xgboost")
# define workflow
bt_workflow1 <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(recipe1_tree)
# hyperparameter tuning value
hardhat::extract_parameter_set_dials(bt_spec)
# change hyperparameter ranges
bt_param1 <- parameters(bt_spec) |> 
  update(mtry = mtry(c(2, 25)),
         min_n = min_n(c(2, 25)))
# build tuning grid
bt_grid1 <- grid_regular(bt_param1, levels = 5) 
# fit workflow/model
bt_tuned1 <- bt_workflow1 |> 
  tune_grid(
    pregnancy_folds, 
    grid = bt_grid1,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
    )

# write out results (fitted/trained workflows) ----
save(bt_tuned1, file = here("results/tuned_bt_rec1.rda"))