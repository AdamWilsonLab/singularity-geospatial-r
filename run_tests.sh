#!/usr/bin/env bash

export SINGULARITY_IMAGE="${SINGULARITY_IMAGE:-singularity-geospatial-r.simg}"
echo "Using Singularity image: ${SINGULARITY_IMAGE}"


readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
export PASSWORD=$(openssl rand -base64 15)

echo password=$PASSWORD
echo port=$PORT


# Verify RStudio Server installation
singularity exec rserver --verify-installation=1 --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper

echo "All tests passed, go have a cappuchino."
