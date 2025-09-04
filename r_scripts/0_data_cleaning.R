# DATA CLEANING

# load library
library(tidyverse)
library(lubridate)
library(here)

# load data
pregnancy_raw <- read_csv(here("data/pregnancy.csv")) |> 
  janitor::clean_names()

# glimpse raw data
glimpse(pregnancy_raw)

# cleaned dataset will be named pregnancy

# filter all rows with missing outcome variable values
pregnancy <- pregnancy_raw |> 
  filter(!is.na(birth_weight))

# rename variables
pregnancy <- pregnancy |> 
  rename(postnatal_depression = edinburgh_postnatal_depression_scale,
         delivery_date = delivery_date_converted_to_month_and_year,
         gestational_age = gestational_age_at_birth)

# change date format
pregnancy <- pregnancy |> 
  mutate(delivery_month = substr(delivery_date, 1, 3),
         delivery_year = substr(delivery_date, 4, 7))

# change variable types
for (col in names(pregnancy)) {
  if (is.character(pregnancy[[col]])) {
    pregnancy[[col]] <- factor(pregnancy[[col]])
  }
}

# rename levels
pregnancy <- pregnancy |> 
  mutate(household_income = fct_recode(household_income,
                              "$100,000-$124,999" = "$100,000 -$124,999",
                              "$125,000-$149,999" = "$125,000- $149,999",
                              "$150,000-$174,999" = "$150,000 - $174,999",
                              "$175,000-$199,999" = "$175,000- $199,999",
                              "<$20,000" = "Less than $20, 000"),
         maternal_education = fct_recode(maternal_education,
                                         "college/trade" = "College/trade school",
                                         "doctoral" = "Doctoral Degree",
                                         "highschool" = "High school diploma",
                                         "less than highschool" = "Less than high school diploma",
                                         "masters" = "Masters degree",
                                         "undergraduate" = "Undergraduate degree"),
         delivery_mode = fct_recode(delivery_mode,
                                    "c-section" = "Caesarean-section (c-section)",
                                    "vaginally" = "Vaginally"))

# view clean data
glimpse(pregnancy)
skimr::skim_without_charts(pregnancy)

# save data
save(pregnancy, file = here("data/pregnancy_clean.rda"))

# data codebook
pregnancy_codebook <- as_tibble(data.frame(
  variable = c(
    "osf_id", 
    "maternal_age", 
    "household_income",  
    "maternal_education", 
    "postnatal_depression",
    "promis_anxiety",
    "gestational_age_at_birth",  
    "delivery_month", 
    "delivery_year",
    "birth_length",  
    "birth_weight",  
    "delivery_mode",  
    "nicu_stay",  
    "language",  
    "threaten_life",  
    "threaten_baby_danger", 
    "threaten_baby_harm"  
  ),
  description = c(
    "unique ID of each mother",
    "age of mother at intake (years)",
    "total household income before taxes and deductions of all the household members in 2019 ($)",
    "highest education degree achieved by mother (less than high school, highschool, college/trade, undergraduate, masters, doctoral)",
    "Edinburgh Postnatal Depression Scale (0: least depressed - 30: most depressed)",
    "Patient-Reported Outcomes Measurement Information System on Anxiety (7: least anxious - 35: most anxious)",
    "gestational age at birth (weeks)",
    "month of delivery",
    "year of delivery",
    "length/height of the baby (cm)",
    "weight of the baby (g)",
    "method of delivery (vaginally, c-section: Caesarean-section)",
    "status of infant admission to the Neonatal Intensive Care Unit (Yes, No)",
    "language the survey was taken in",
    "Percentage the mother thought her life is/was in danger during the COVID-19 pandemic (%)",
    "Percentage the mother thought her unborn baby's life is/was in danger during the COVID-19 pandemic (%)",
    "Percentage the mother was worried that exposure to the COVID-19 virus will harm her unborn baby (%)"
  )
))

# save data codebook 
save(pregnancy_codebook, file = here("data/pregnancy_codebook.rda"))

