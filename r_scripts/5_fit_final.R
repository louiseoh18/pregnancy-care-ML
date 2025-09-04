# Fit & predict using chosen final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# parallel over
library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# load testing data
load(here("data_splits/pregnancy_split.rda"))
load(here("data_splits/pregnancy_folds.rda"))

# load fits and recipes
load(here("results/tuned_rf_rec1.rda"))
load(here("recipes/pregnancy_recipes.rda"))

## RANDOM FOREST USING RECIPE 1 tree -----
# finalize workflow 
final_workflow1 <- rf_tuned1 |> 
  extract_workflow() |>  
  finalize_workflow(select_best(rf_tuned1, metric = "rmse"))
# train final model 
final_fit <- fit(final_workflow1, pregnancy_train)

# final prediction -----
final_pred <- pregnancy_test |> 
  bind_cols(predict(final_fit, pregnancy_test)) |> 
  select(birth_weight, .pred)

# save final fit and prediction
save(final_fit, final_pred, file = here("results/fit_final.rda"))

