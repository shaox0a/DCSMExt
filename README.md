# Supplementary Program and Dataset

This repository contains the supplementary program and dataset for the manuscript:

**"Modeling Nonstationary Extremal Dependence via Deep Spatial Deformations"**

## 1. Overview

The folder `Scripts&Codes/` contains:

- `AppData/`: application data and modelling results
- `SimData/`: simulated data and modelling results
- `Functions/`: functions used by the main scripts
- `application_UKpr.R`: script for the UK precipitation data application
- `simulation.R`: script for a simulation demo

Some required datasets and precomputed objects are not included directly in this repository and must be downloaded from Zenodo:

[https://zenodo.org/records/15459157](https://zenodo.org/records/15459157)

## 2. Installation

The current program has been tested with:

- **Python 3.7.11**
- **TensorFlow 2.11.0**

Some newer TensorFlow versions are not compatible with the current implementation. In particular, **TensorFlow 2.19.0 is not compatible**.

Running the scripts requires:

- Python
- TensorFlow
- TensorFlow-related packages in R

### Install the required R packages

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

### Create a Python environment and install TensorFlow

Run the following commands in R:

```r
library(reticulate)

py_version <- "3.7.11"
path_to_python <- reticulate::install_python(version = py_version)

reticulate::virtualenv_create(
  envname = "dcsmext",
  python = path_to_python,
  version = py_version
)

reticulate::use_virtualenv("dcsmext", required = TRUE)

tensorflow::install_tensorflow(
  method = "virtualenv",
  envname = "dcsmext",
  version = "2.11.0"
)

keras::install_keras(
  method = "virtualenv",
  envname = "dcsmext",
  version = "2.11.0"
)

reticulate::virtualenv_install(
  envname = "dcsmext",
  packages = "tensorflow-probability"
)
```

### Check that the installation works

```r
library(reticulate)
library(tensorflow)

py_config()
tf$constant("TensorFlow is available")
```

If these commands run without error, the environment is ready.

## 3. Getting started

### Simulation demo

To run `simulation.R`, download the following files from Zenodo and place them directly in `Scripts&Codes/SimData/`:

- `r-Pareto_max+AWU_RBF_2D_7+5000_10201_range(0.2).rds`
- `r-Pareto_site+AWU_RBF_2D_7+5000_10201_range(0.2).rds`
- `r-Pareto_sum+AWU_RBF_2D_7+5000_10201_range(0.2).rds`

These files are provided because simulating r-Pareto processes under the max-functional can be time-consuming.

Then run:

```r
source("simulation.R")
```

### UK precipitation application

To run `application_UKpr.R`, download the following file from Zenodo and place it directly in `Scripts&Codes/AppData/`:

- `UKpr_waleswindow.rds`

The file

- `UKpr_r-Pareto_max_empextdep.rds`

may also be downloaded from Zenodo and placed in `AppData/`, but it can also be generated within `application_UKpr.R`.

Then run:

```r
source("application_UKpr.R")
```

Please make sure that downloaded files are placed **directly inside** `AppData/` and `SimData/`, rather than inside an additional nested download folder.
