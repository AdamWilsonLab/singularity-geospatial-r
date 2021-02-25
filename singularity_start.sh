#! /usr/bin/env bash

# create symlink to singularity folder in project storage
# mkdir /projects/academic/adamw/singularity/$USER/.singularity
# ln -s /projects/academic/adamw/singularity/$USER/.singularity .singularity

# Symlinks for RStudio
# mkdir /projects/academic/adamw/rstudio/$USER
# mv .local/share/rstudio /projects/academic/adamw/rstudio/$USER/
# ln -s /projects/academic/adamw/rstudio/$USER/rstudio .local/share/rstudio

# mount project folder inside container:
export PROJECT_FOLDER="/projects/academic/adamw/"
# path to singularity container file:
export CONTAINER_PATH="/panasas/scratch/grp-adamw/singularity/singularity-geospatial-r_latest.sif"
# to use for ssh:
export SERVER_URL="horae.ccr.buffalo.edu"
# folder to hold temporary singularity files - unique for each user:
export SINGULARITY_LOCALCACHEDIR="/panasas/scratch/grp-adamw/singularity/"$USER

# Run as particular group to use group storage
newgrp grp-adamw


##################################################
# shouldn't need to edit anything below this point

# define a few more folders used by singularity
export SINGULARITY_CACHEDIR=$SINGULARITY_LOCALCACHEDIR
export SINGULARITY_TMPDIR=$SINGULARITY_LOCALCACHEDIR

# Create the folders if they don't already exist
mkdir -p $SINGULARITY_LOCALCACHEDIR/tmp
mkdir -p $SINGULARITY_LOCALCACHEDIR/run


# Following https://www.rocker-project.org/use/singularity/
# Find an open port
export PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
# generate a random password
export PASSWORD=$(openssl rand -base64 15)

# export SINGULARITYENV_USER=$USER
# export SINGULARITYENV_PASSWORD=$PASSWORD
# export SINGULARITYENV_PORT=$PORT

# report on current settings
echo "
For debugging:
-----------------------------------------
PROJECT_FOLDER is set to: $PROJECT_FOLDER
CONTAINER_PATH is set to: $CONTAINER_PATH
SERVER_URL is set to: $SERVER_URL
SINGULARITY_LOCALCACHEDIR is set to: $SINGULARITY_LOCALCACHEDIR
PORT is set to: $PORT
-----------------------------------------
"

# Start the instance using variables above
singularity instance start \
      --bind $PROJECT_FOLDER:$PROJECT_FOLDER \
      --bind $SINGULARITY_LOCALCACHEDIR/tmp:/tmp \
      --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
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
