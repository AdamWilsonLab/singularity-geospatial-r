# pull image
cd /panasas/scratch/grp-adamw/;
singularity pull -F shub://AdamWilsonLab/singularity-geospatial-r


mkdir mytmp myrun


#  New method following https://www.rocker-project.org/use/singularity/
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
export PASSWORD=$(openssl rand -base64 15)
echo ssh -N -L 8787:${HOSTNAME}:${PORT} ${USER}@horae.ccr.buffalo.edu
echo $PASSWORD

#    -B $(pwd):/home/rstudio -B $(pwd):$HOME \


singularity exec \
    --bind /projects/academic/adamw/ \
    -B mytmp:/tmp --bind myrun:/run \
    singularity-geospatial-r_latest.sif \
    rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper


# use an instance
singularity instance start --bind /projects/academic/adamw/ \
-B mytmp:/tmp --bind myrun:/run \
singularity-geospatial-r_latest.sif \
rserver


singularity exec instance://rserver rserver --www-port ${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper
