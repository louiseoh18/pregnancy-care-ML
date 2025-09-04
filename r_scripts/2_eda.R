# EDA for RECIPES

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# set seed for random process
set.seed(100)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/pregnancy_split.rda"))

# glimpse data
glimpse(pregnancy_train)

## TARGET VARIABLE -----

# distribution
target_dist <- ggplot(pregnancy_train, aes(x = birth_weight)) +
  geom_histogram(fill = "skyblue", color = "black", bins = 35) +
  theme_minimal() +
  labs(title = "Distribution of Child's Weight at Birth",
       x = "Birth Weight (g)",
       y = NULL)
target_dist

# summary stats
target_stats <- pregnancy_train |>
  summarise(Min = min(birth_weight),
            Q1 = quantile(birth_weight, 0.25),
            Median = median(birth_weight),
            Mean = mean(birth_weight),
            Q3 = quantile(birth_weight, 0.75),
            Max = max(birth_weight)) |> 
  knitr::kable()
target_stats

# save plot and table
save(target_dist, target_stats, file = here("analysis/stats_target_var.rda"))

## UNIVARIATE -----
vars <- pregnancy_train |> 
  colnames()
for (var in vars) {
  if (is.numeric(pregnancy_train[[var]])) {
    # create histogram for the current numerical variable
    hist <- ggplot(pregnancy_train, aes(x = !!as.name(var))) +
      geom_histogram() +
      theme_minimal()
    print(hist)
  } else {
    # create bar plot for non-numeric variables
    bar <- ggplot(pregnancy_train, aes(x = !!as.name(var))) +
      geom_bar() +
      theme_minimal()
    print(bar)
  }
}

## postnatal_depression scaling
ggplot(pregnancy_train, aes(x = (postnatal_depression))) +
  geom_histogram() +
  theme_minimal()

## BIVARIATE -----
# correlation plot
corr <- pregnancy_train |> 
  select(where(is.numeric)) |> 
  cor()
ggcorrplot::ggcorrplot(corr, 
                       type = "lower",
                       lab = TRUE, 
                       method = "square")
## promis_anxiety and postnatal_depression = .8
## threaten_baby_danger and threaten_baby_harm = .73

