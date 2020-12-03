#! /usr/bin/env bash

SINGULARITY_LOCALCACHEDIR=/panasas/scratch/grp-adamw/singularity/$USER
SINGULARITY_CACHEDIR=$SINGULARITY_LOCALCACHEDIR
SINGULARITY_TMPDIR=$SINGULARITY_LOCALCACHEDIR

export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

mkdir -p $SINGULARITY_LOCALCACHEDIR
mkdir -p $SINGULARITY_LOCALCACHEDIR/tmp
mkdir -p $SINGULARITY_LOCALCACHEDIR/run

newgrp grp-adamw

#  New method following https://www.rocker-project.org/use/singularity/
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
export PASSWORD=$(openssl rand -base64 15)

singularity exec --bind /projects/academic/adamw/ \
-B $SINGULARITY_LOCALCACHEDIR/tmp:/tmp --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
/panasas/scratch/grp-adamw/singularity/singularity-geospatial-r_latest.sif \
rserver  --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper &

# use an instance
#singularity instance start --bind /projects/academic/adamw/ \
#-B $SINGULARITY_LOCALCACHEDIR/tmp:/tmp --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
#/panasas/scratch/grp-adamw/singularity/singularity-geospatial-r_latest.sif \
#rserver  --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper



cat 1>&2 <<END
    1. SSH tunnel from your workstation using the following command:

       ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu

       and point your web browser to http://localhost:8787

    2. log in to RStudio Server using the following credentials:

       user: ${USER}
       password: ${PASSWORD}

    When done using RStudio Server, terminate the job by:

    1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
END

#    2. Issue the following command on the login node:
#
#          singularity instance stop rserver


#singularity exec instance://rserver rserver


#singularity exec --bind /projects/academic/adamw/ \
#-B $SINGULARITY_LOCALCACHEDIR/mytmp:/tmp --bind $SINGULARITY_LOCALCACHEDIR/myrun:/run \
#instance://rserver rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper

#singularity exec instance://rserver rserver


# Check status: port/password
# singularity exec instance://rserver bash -c 'echo ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu'
# singularity exec instance://rserver bash -c 'echo ssh -N -L 8787:hor:${PORT} ${USER}@hor'

# singularity exec instance://rserver rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper
# singularity exec instance://rserver rserver