#! /usr/bin/env bash



# cd to user singularity directory
cd /panasas/scratch/grp-adamw/singularity/$USER;
# download the most recent version of the container
wget -O singularity-geospatial-r_latest.sif \
   https://github.com/AdamWilsonLab/singularity-geospatial-r/releases/download/0.0.1/AdamWilsonLab-singularity-geospatial-r.latest.sif
