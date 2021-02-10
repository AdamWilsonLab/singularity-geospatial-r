# Singularity Status

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4930)


# Geospatial R
This container builds upon the [rocker geospatial container](https://hub.docker.com/r/rocker/geospatial), which I ported to [Singularity here](https://singularity-hub.org/collections/4908).  This repository/collection then adds additional packages.

# Development Notes

I started with [nickjer's very helpful example](https://github.com/nickjer/singularity-rstudio/blob/master/.travis.yml) and updated it to pull from the geospatial version of the versioned rocker stack instead of the repository based R.  This should make it easier to keep up to date.

## rocker updates

`docker run -d -p 8787:8787 -e PASSWORD=really_clever_password -v /Users/adamw/Documents:/Users/adamw/Documents rocker/rstudio`

# Errors

* Error "Could not acquire revocation list file lock" resolved with help from [here](https://www.gitmemory.com/issue/rocker-org/rocker-versioned/213/726807289)


# PuTTY Instructions

1. in PuTTY, enter the server address (host name) and "22" (port) on the "Session" tab.
2. On the "SSH/Tunnels" tab, enter the port number of the rsession  under “Source port” and type in "10.122.15.25:33720" (server IP address + the port number) as the destination address. Then, click "Add".
3. Connect and login as usual in the terminal.
4. Point the web browser to `http://localhost:PORT` (where PORT is the port number)" and log in with the user name and the previously generated password.


# Useful Links

A few links I found useful while developing this container

* https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
* https://hub.docker.com/r/rocker/geospatial
* https://singularity-hub.org/collections/4930
* https://pawseysc.github.io/singularity-containers/23-web-rstudio/index.html
* https://www.rocker-project.org/use/singularity/
* https://github.com/grst/rstudio-server-conda/issues/3
