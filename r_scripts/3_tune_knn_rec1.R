# Define and fit k nearest neighbor

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)

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
knn_spec <- nearest_neighbor(mode = "regression",
                             neighbors = tune()) |> 
  set_engine("kknn")
# define workflow
knn_workflow1 <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(recipe1_tree)
# hyperparameter tuning grid
knn_params <- hardhat::extract_parameter_set_dials(knn_spec) |> 
  update(neighbors = neighbors(range = c(40, 80)))
# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 15)
# fit workflow/model
knn_tuned1 <- knn_workflow1 |> 
  tune_grid(
    pregnancy_folds, 
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(rmse)
    )

# write out results (fitted/trained workflows) ----
save(knn_tuned1, file = here("results/tuned_knn_rec1.rda"))