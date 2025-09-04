# Define and fit linear regression

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

# load training data
load(here("data_splits/pregnancy_split.rda"))
load(here("data_splits/pregnancy_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/pregnancy_recipes.rda"))

## USING RECIPE 1 -----
# model specification
lm_spec <- linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 
# define workflow
lm_workflow1 <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe1)
# fit workflow/model
lm_fit1 <- lm_workflow1 |> 
  fit_resamples(
    resamples = pregnancy_folds,
    control = control_resamples(save_workflow = TRUE),
    metrics = metric_set(rmse)
)

## USING RECIPE 2 -----

# model specification
lm_spec <- linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 
# define workflow
lm_workflow2 <- workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe2)
# fit workflow/model
lm_fit2 <- lm_workflow2 |> 
  fit_resamples(
    resamples = pregnancy_folds,
    control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(lm_fit1, lm_fit2, file = here("results/fit_lm.rda"))
