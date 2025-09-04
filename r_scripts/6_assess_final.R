# Analyze the final model

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
load(here("results/fit_final.rda"))
load(here("recipes/pregnancy_recipes.rda"))

# final metrics -----
mape_value <- mean(abs(final_pred$.pred - final_pred$birth_weight) / final_pred$birth_weight)*100
final_metrics <- metric_set(rmse, mae, rsq)
final_table <- tibble(
  metric = c("RMSE", "MAE", "RSQ", "MAPE"),
  RandomForest = c(final_metrics(final_pred, truth = birth_weight, estimate = .pred) |> 
                     pull(.estimate), 
                   mape_value)
  ) |> 
  knitr::kable()

# plot actual vs. pred -----
final_plot <- pregnancy_test |>
  select(birth_weight) |>
  bind_cols(predict(final_fit, pregnancy_test)) |>
  ggplot(aes(x = birth_weight, y = .pred)) +
  geom_point(alpha = 0.2) + 
  geom_abline(linetype = 5, color = "blue") + 
  theme_minimal() +
  labs(title = "Baby's Actual vs. Predicted Birth Weight",
       x = "Birth Weight (g)", 
       y = "Predicted Birth Weight (g)") +
  coord_obs_pred()
final_plot

# save final tables and plots
save(final_table, final_plot, file = here("analysis/assess_final_fit.rda"))
