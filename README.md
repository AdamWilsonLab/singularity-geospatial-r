# Singularity Status

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4930)

# Overview
This repository includes a definition file for a singularity container _and_ instructions for starting up an instance on CENTOS in a HPC environment.  

Basic Steps:

1. SSH to the server and pull the container from the Singularity Hub (or other source).  This has already been done for horae.
2. Run the [singularity_start.sh](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/singularity_start.sh) script to start up a singularity instance. This includes a few system specific settings for the Buffalo CCR.  This should only need to be done once (as long as the instance keeps running).
3. Connect to the instance via SSH with port Forwarding
4. Open RStudio at localhost:8787 in your local browser.


## Singularity Container: Geospatial R
This container builds upon the [rocker geospatial container](https://hub.docker.com/r/rocker/geospatial), which I ported to [Singularity here](https://singularity-hub.org/collections/4908).  This repository/collection then [adds additional packages in this file](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/Singularity.latest).  That's the file to modify if you want to add more linux packages, etc.

# Connecting via SSH

## *NIX systems
Use terminal to ssh to the server as explained in [singularity_start.sh](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/singularity_start.sh).
Add something like the following to your .ssh/config file to simplify connecting with port forwarding via ssh.

```
Host rserver
HostName HOST
LocalForward 8787 HOST:PORT_NUMBER
User adamw
ForwardX11 yes
ForwardAgent yes
```

## Windows

### PuTTY Instructions
On Windows you will need to use PuTTY or a similar terminal program.
1. In PuTTY, enter the server address (host name) and "22" (port) on the "Session" tab.
2. On the "SSH/Tunnels" tab, enter the port number of the rsession  under “Source port” and type in HOST:PORT (replace with the actual server IP address + the port number) as the destination address. Then, click "Add".
3. Connect and login as usual in the terminal.
4. Point the web browser to `http://localhost:PORT` (where PORT is the port number)" and log in with the user name and the previously generated password.



# Development Notes

I started with [nickjer's very helpful example](https://github.com/nickjer/singularity-rstudio/blob/master/.travis.yml) and updated it to pull from the geospatial version of the versioned rocker stack instead of the repository based R.  This should make it easier to keep up to date.

## Errors

* Error "Could not acquire revocation list file lock" resolved with help from [here](https://www.gitmemory.com/issue/rocker-org/rocker-versioned/213/726807289)

## Local rocker updates

`docker run -d -p 8787:8787 -e PASSWORD=really_clever_password -v ~/Documents:~/Documents rocker/rstudio`

# Useful Links

A few links I found useful while developing this container

* https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
* https://hub.docker.com/r/rocker/geospatial
* https://singularity-hub.org/collections/4930
* https://pawseysc.github.io/singularity-containers/23-web-rstudio/index.html
* https://www.rocker-project.org/use/singularity/
* https://github.com/grst/rstudio-server-conda/issues/3
