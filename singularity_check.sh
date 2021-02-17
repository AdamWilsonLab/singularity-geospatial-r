#! /usr/bin/env bash


PASSWORD=${singularity exec instance://rserver bash -c 'echo $PASSWORD'}
PORT=${singularity exec instance://rserver bash -c 'echo $PORT'}
SSH_COMMAND=${singularity exec instance://rserver bash -c 'echo ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu'}

echo "
    1. SSH tunnel from your workstation using the following command:

       ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu

       and point your web browser to http://localhost:8787

    2. log in to RStudio Server using the following credentials:

       user: ${USER}
       password: ${PASSWORD}

    When done using RStudio Server, terminate the job by:

    1. Exit the RStudio Session ("power" button in the top right corner of the RStudio window)
    2. Issue the following command on the login node:

          singularity instance stop rserver

"
