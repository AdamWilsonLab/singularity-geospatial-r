#! /usr/bin/env bash

# Details for CCR

SINGULARITY_LOCALCACHEDIR=/panasas/scratch/grp-adamw/singularity/
SINGULARITY_CACHEDIR=/panasas/scratch/grp-adamw/singularity/
SINGULARITY_TMPDIR=/panasas/scratch/grp-adamw/singularity/
export SINGULARITY_LOCALCACHEDIR
export SINGULARITY_CACHEDIR
export SINGULARITY_TMPDIR

export SINGULARITY_BINDPATH="$SINGULARITY_TMPDIR:/var/run,/active,/archive"
export PATH="/usr/local/bin:/usr/lib/rstudio-server/bin:$PATH"
export SINGULARITYENV_PATH="$PATH"
#export MODULEPATH="/depot/Modules/modulefiles"


mkdir -p $SINGULARITY_LOCALCACHEDIR
newgrp grp-adamw
