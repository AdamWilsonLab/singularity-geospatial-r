#! /usr/bin/env bash

SINGULARITY_LOCALCACHEDIR=/panasas/scratch/grp-adamw/singularity/$USER
SINGULARITY_CACHEDIR=$SINGULARITY_LOCALCACHEDIR
SINGULARITY_TMPDIR=$SINGULARITY_LOCALCACHEDIR

export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR


PASSWORD=${singularity exec instance://myserver bash -c 'echo $PASSWORD'}
PORT2=$(singularity exec instance://myserver bash -c 'echo $PORT')
SSH_COMMAND=${singularity exec instance://myserver bash -c 'echo ssh -N -L 8787:${HOSTNAME}:${PORT2} ${USER}@horae.ccr.buffalo.edu'}

singularity exec --bind /projects/academic/adamw/ \
-B $SINGULARITY_LOCALCACHEDIR/tmp:/tmp --bind $SINGULARITY_LOCALCACHEDIR/run:/run \
instance://myserver rserver \
--www-port $PORT2 \
--auth-none=0 --auth-pam-helper-path=pam-helper

#singularity exec instance://rserver rserver


# Check status: port/password
# singularity exec instance://rserver bash -c 'echo ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu'
# singularity exec instance://rserver bash -c 'echo ssh -N -L 8787:hor:${PORT} ${USER}@hor'

# singularity exec instance://rserver rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper
# singularity exec instance://rserver rserver


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
