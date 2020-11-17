# Singularity Status

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4930)


# Geospatial R
This container builds upon the [rocker geospatial container](https://hub.docker.com/r/rocker/geospatial), which I ported to [Singularity here](https://singularity-hub.org/collections/4908).  This repository/collection then adds additional packages.

# Development Notes

I started with [nickjer's very helpful example](https://github.com/nickjer/singularity-rstudio/blob/master/.travis.yml) and updated it to pull from the geospatial version of the versioned rocker stack instead of the repository based R.  This should make it easier to keep up to date.  I also pulled from the

# Useful Links

A few links I found useful while developing this container

* https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
* https://hub.docker.com/r/rocker/geospatial
* https://singularity-hub.org/collections/4930
* https://pawseysc.github.io/singularity-containers/23-web-rstudio/index.html
* https://www.rocker-project.org/use/singularity/
* https://github.com/grst/rstudio-server-conda/issues/3
