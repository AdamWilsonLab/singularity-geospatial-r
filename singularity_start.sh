#! /usr/bin/env bash

# create symlink to singularity folder in project storage
# mkdir /projects/academic/adamw/singularity/adamw/.singularity
# ln -s /projects/academic/adamw/singularity/adamw/.singularity .singularity

# Symlinks for RStudio
# mkdir /projects/academic/adamw/rstudio/adamw
# mv .local/share/rstudio /projects/academic/adamw/rstudio/adamw/
# ln -s /projects/academic/adamw/rstudio/adamw/rstudio .local/share/rstudio

PROJECT_FOLDER=/projects/academic/adamw/
CONTAINER_PATH=/panasas/scratch/grp-adamw/singularity/singularity-geospatial-r_latest.sif
SERVER_URL=horae.ccr.buffalo.edu
SINGULARITY_LOCALCACHEDIR=/panasas/scratch/grp-adamw/singularity/$USER

# Run as particular group to use group storage
newgrp grp-adamw

# Set up singularity paths
SINGULARITY_CACHEDIR=$SINGULARITY_LOCALCACHEDIR
SINGULARITY_TMPDIR=$SINGULARITY_LOCALCACHEDIR

export PROJECT_FOLDER
export SERVER_URL
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR


# Create the folders if they don't already exist
mkdir -p $SINGULARITY_LOCALCACHEDIR
mkdir -p $SINGULARITY_LOCALCACHEDIR/tmp
mkdir -p $SINGULARITY_LOCALCACHEDIR/run


#  New method following https://www.rocker-project.org/use/singularity/
# Find an open port
export PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
# generate a random password
export PASSWORD=$(openssl rand -base64 15)

# use exec instead of instance
#singularity exec --bind /projects/academic/adamw/ \
#-B $SINGULARITY_LOCALCACHEDIR/tmp:/tmp --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
#/panasas/scratch/grp-adamw/singularity/singularity-geospatial-r_latest.sif \
#rserver  --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper &


# Start the instance
singularity instance start --bind $PROJECT_FOLDER \
-B $SINGULARITY_LOCALCACHEDIR/tmp:/tmp  --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
$CONTAINER_PATH rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper

# write a file with the details (port and password)
echo "
    1. SSH tunnel from your workstation using the following command:

       ssh -N -L 8787:${SERVER_URL}:${PORT} ${USER}@${SERVER_URL}

       and point your web browser to http://localhost:8787

    2. log in to RStudio Server using the following credentials:

       user: ${USER}
       password: ${PASSWORD}

    3. to repeat these instructions:

      cat ~/singularity_status.txt


    When done using RStudio Server, terminate the job by:

    1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
    2. Issue the following command on the login node:

          singularity instance stop rserver


" > ~/singularity_status.txt

cat ~/singularity_status.txt
