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
- `reproduce_prepare.R`: a reference script used to test the code on a fresh Windows machine

Some required datasets and precomputed objects are not included directly in this repository and must be downloaded from Zenodo:

[https://zenodo.org/records/15459157](https://zenodo.org/records/15459157)

## 2. Installation

To help users prepare a reproducible runtime environment, we provide the script:

- `reproduce_prepare.R`

This script was used to test the code on a fresh Windows machine. It is included as a reference for environment setup, rather than as a one-click installation script for all users.

Because users may have different local machine settings (for example, different R versions or missing system tools), we do **not** recommend directly running:

```r
source("reproduce_prepare.R")
```

Instead, we recommend that users follow the setup steps in `reproduce_prepare.R` and adapt them when needed to match their own system configuration. In particular, some components may require manual setup, such as:

- Git
- Rtools

The current program has been tested using the setup specified in `reproduce_prepare.R`, namely:

- **Python 3.11**
- **TensorFlow 2.19.0**
- **Keras 2.15.0**
- **TensorFlow Probability 0.15.1**

### Environment setup workflow

Below we provide a setup workflow similar to the one used in `reproduce_prepare.R`.

### Step 1. Set up the Python environment

```r
install.packages("reticulate")
library(reticulate)

py_version <- "3.11:latest"
path_to_python <- reticulate::install_python(version = py_version)

reticulate::virtualenv_create(
  envname = "dcsmext",
  python = path_to_python,
  version = py_version
)
```

### Step 2. Restart the R session and install TensorFlow-related Python packages

After creating the virtual environment, **restart the R session**. Then run:

```r
library(reticulate)
reticulate::use_virtualenv("dcsmext", required = TRUE)

tensorflow::install_tensorflow(
  method = "virtualenv",
  envname = "dcsmext",
  version = "2.19.0"
)

keras::install_keras(
  method = "virtualenv",
  envname = "dcsmext",
  version = "2.15.0"
)

reticulate::virtualenv_install(
  envname = "dcsmext",
  packages = "tensorflow-probability",
  version = "0.15.1"
)
```

### Step 3. Install the required R packages

```r
install.packages(c(
  "reticulate",
  "tensorflow",
  "keras",
  "tfprobability",
  "dplyr",
  "fields",
  "ggplot2",
  "ggpubr",
  "ggnewscale",
  "elevatr",
  "RColorBrewer",
  "this.path",
  "gridExtra",
  "viridis"
))
```

## 3. Optional packages for reproducing UK precipitation figures

The packages `maps` and `contoureR` are only needed for reproducing the plots in the UK precipitation application. If you do not need to reproduce those figures, you may skip this section.

Install them with:

```r
install.packages("maps")
install.packages("contoureR")
```

### Note on `contoureR`

`contoureR` is mainly available for older R versions (for example, R 4.3.2). If you are using a newer version of R (for example, R 4.5.x), the package may need to be installed from source. On Windows, this usually requires Rtools.

If needed, you may try installing `contoureR` with:

```r
install.packages(
  "contoureR",
  repos = c("https://cran.r-universe.dev", "https://cloud.r-project.org")
)
library(contoureR)
```

## 4. Check that the installation works

After the environment is set up, run:

```r
library(reticulate)
library(tensorflow)

py_config()
tf$constant("TensorFlow is available")
```

If these commands run without error, the environment is ready.

## 5. Getting started

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
