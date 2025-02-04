# bbVTCwm

**Kubota, E., Yan, X., Tung, S., Fascendini, B., Tyagi, C., Duhameau, S., 
Ortiz, D., Grotheer, M., Natu, V.S., Keil, B., & Grill-Spector,K. (2024).
White matter connections of human ventral temporal cortex are 
organized by cytoarchitecture, eccentricity, and category-selectivity from birth.**


This repository contains code to analyze the data, compute statistics, and make the individual figure elements. 

#### Overall organization 
`code` folder contains the R code used to generate all other figures and statistics in the `figures/` and `statistics/` subdirectories. 

The `analyses/` subdirectory contains code used to preprocess diffusion data, intersect connectomes with fROIs, quantify connectivity profiles, and perform PCA.

`data` includes the processed data used for figure generation and statistics.

`figures` contains the output figures. 

`supplement` includes code to generate Supplementary Figures. 

`labels` contains the ROIs used for the analyses in fsaverage space within the `evc\` and `frois\` subdirectories.

#### Dependencies
The code should be runnable on your local machine assuming the following dependencies:

```
R (>= 4.3.1)

tidyverse
lmerTest
patchwork
viridis 
ggcorrplot

```

```
For preprocessing and analyses

MATLAB 2015a
Freesurfer v7.0 
ANTS
cuda 9.1
AFQ
mrTrix3
https://github.com/VPNL/fat
https://github.com/cvnlab/cvncode
https://github.com/smeisler/fsub_extractor

```
