## How to Use This Repository

For most users, the easiest way to start is to download and follow the R Markdown user guide:

**`causal_ml_review_simple_user_guide_v3.Rmd`**

This guide shows how to load the review data, view the main tables, join paper-level metadata with scores, inspect evidence excerpts, and export analysis-ready tables.

The main data-loading script is:

**`data_loading_module.R`**

Users do not need to manually create the `.RDS` file. The script automatically builds the review tables and saves the RDS file.

To load the data directly from GitHub, run:

```r
source(
  "https://raw.githubusercontent.com/sharashankr/Causal_ML_Literature_Review_Data_Analyses/main/data_loading_module.R",
  encoding = "UTF-8"
)
