## .R Scripts

- `0_data_cleaning.R`: codes used to clean and save data ready for use

- `1_initial_setup.R`: codes used to split and fold data

- `2_eda.R`: codes used for eda of training data to create customized recipes

- `2_recipes.R`: codes used to create all recipes used for fitting the models

- `3_fit_null.R`: codes used to specify and fit/resample the null/baseline models

- `3_fit_lm.R`: codes used to specify and fit/resample the linear regression models

- `3_tune_lasso.R`: codes used to specify and fit/tune the lasso regression models

- `3_tune_ridge.R`: codes used to specify and fit/tune the ridge regression models

- `3_tune_knn_rec1.R`: codes used to specify and fit/tune the k-nearest neighbor model using the kitchen sink recipe

- `3_tune_knn_rec2.R`: codes used to specify and fit/tune the k-nearest neighbor model using the customized recipe

- `3_tune_bt_rec1.R`: codes used to specify and fit/tune the boosted tree model using the kitchen sink recipe

- `3_tune_bt_rec2.R`: codes used to specify and fit/tune the boosted tree model using the customized recipe

- `3_tune_rf_rec1.R`: codes used to specify and fit/tune the random forest model using the kitchen sink recipe

- `3_tune_rf_rec2.R`: codes used to specify and fit/tune the random forest model using the customized recipe

- `4_model_analysis.R`: codes used to analyze which model works best

- `5_fit_final.R`: codes used to fit the final model chosen for the prediction project

- `6_assess_final.R`: codes used to assess the final model fitted for the prediction project
