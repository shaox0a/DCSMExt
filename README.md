# Supplementary Program and Dataset

This repository contains the supplementary program and dataset for the manuscript:

**"Modeling Nonstationary Extremal Dependence via Deep Spatial Deformations"**

## Repository structure

The folder `Scripts&Codes/` contains the following components:

1. **AppData**: application data and modelling results.
2. **SimData**: simulated data and modelling results.
3. **Functions**: functions used for modelling in `application_UKpr.R` and `simulation.R`.
4. **application_UKpr.R**: the script for the UK precipitation data application.
5. **simulation.R**: the script for a simulation demo. It can simulate r-Pareto processes with the provided risk functional and other hyperparameters.

## Data download and file placement

Some required datasets and precomputed objects are **not included directly** in this repository and must be downloaded separately from Zenodo:

**Zenodo record:** [https://zenodo.org/records/15459157](https://zenodo.org/records/15459157)

After downloading, place the files **directly** into the corresponding folders below.

### 1. Files for the simulation demo

For `simulation.R`, download the following files and place them in:

`Scripts&Codes/SimData/`

Required files:

- `r-Pareto_max+AWU_RBF_2D_7+5000_10201_range(0.2).rds`
- `r-Pareto_site+AWU_RBF_2D_7+5000_10201_range(0.2).rds`
- `r-Pareto_sum+AWU_RBF_2D_7+5000_10201_range(0.2).rds`

These files contain the simulated datasets used in the simulation study for the site-, max-, and sum-functionals. They are provided because simulating r-Pareto processes under the max-functional can be time-consuming.

### 2. Files for the UK precipitation application

For `application_UKpr.R`, place the application data files in:

`Scripts&Codes/AppData/`

Relevant files:

- `UKpr_waleswindow.rds`
- `UKpr_r-Pareto_max_empextdep.rds`

The file `UKpr_waleswindow.rds` must be downloaded from Zenodo and placed in `AppData/` before running `application_UKpr.R`.

The file `UKpr_r-Pareto_max_empextdep.rds` is a precomputed object related to the application workflow. It can also be **generated within `application_UKpr.R`**, so users may either:

- download it from Zenodo and place it in `AppData/`, or
- run `application_UKpr.R` and let the script generate it.

### 3. Folder structure after download

After downloading, the folder structure should look like this:

```text
Scripts&Codes/
├── AppData/
│   ├── UKpr_waleswindow.rds
│   └── UKpr_r-Pareto_max_empextdep.rds
├── Functions/
├── SimData/
│   ├── r-Pareto_max+AWU_RBF_2D_7+5000_10201_range(0.2).rds
│   ├── r-Pareto_site+AWU_RBF_2D_7+5000_10201_range(0.2).rds
│   └── r-Pareto_sum+AWU_RBF_2D_7+5000_10201_range(0.2).rds
├── application_UKpr.R
└── simulation.R
```
Please make sure that these files are placed **directly inside** `AppData/` and `SimData/`, rather than inside an additional nested download folder.


## Remarks

The current program works with:

- **TensorFlow version 2.11.0**
- **Python version 3.7.11**

Some updated TensorFlow versions, such as **2.19.0**, are not compatible with the current implementation.

Running the scripts requires installation of:

- Python
- TensorFlow
- the required TensorFlow-related packages in R


## Software installation

The code has been tested with:

- **Python 3.7.11**
- **TensorFlow 2.11.0**

Newer TensorFlow versions, such as `2.19.0`, may not be compatible.

### 1. Install the required R packages

```r
install.packages(c(
  "reticulate",
  "tensorflow",
  "keras",
  "tfprobability",
  "dplyr",
  "fields",
  "maps",
  "ggplot2",
  "ggpubr",
  "ggnewscale",
  "elevatr",
  "contoureR",
  "RColorBrewer",
  "this.path",
  "gridExtra"
))
```

### 2. Create a Python environment and install TensorFlow

Run the following commands in R:

```r
library(reticulate)

py_version <- "3.7.11"
path_to_python <- reticulate::install_python(version = py_version)

reticulate::virtualenv_create(
  envname = "dscext_tf211",
  python = path_to_python,
  version = py_version
)

reticulate::use_virtualenv("dscext_tf211", required = TRUE)

tensorflow::install_tensorflow(
  method = "virtualenv",
  envname = "dscext_tf211",
  version = "2.11.0"
)

keras::install_keras(
  method = "virtualenv",
  envname = "dscext_tf211",
  version = "2.11.0"
)

reticulate::virtualenv_install(
  envname = "dscext_tf211",
  packages = "tensorflow-probability"
)
```

### 3. Check that the installation works

```r
library(reticulate)
library(tensorflow)
library(keras)

py_config()
tf$constant("TensorFlow is available")
keras::is_keras_available()
```

If these commands run without error, the environment is ready.


## How to start

1. Install the required software and packages.
2. Download the required data files from Zenodo and place them in the correct folders.
3. Run `simulation.R` for the simulation demo, or run `application_UKpr.R` for the UK precipitation data application.
