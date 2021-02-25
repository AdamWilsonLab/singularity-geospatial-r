#! /usr/bin/env bash

# Details for CCR


# setup
mkdir -p /panasas/scratch/grp-adamw/singularity/$USER
cd /panasas/scratch/grp-adamw/singularity/$USER;
singularity pull -F shub://AdamWilsonLab/singularity-geospatial-r
