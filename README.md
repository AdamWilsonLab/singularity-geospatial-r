# Singularity Status

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4930)

# Overview
This repository includes a definition file for a singularity container _and_ instructions for starting up an instance on CENTOS in a HPC environment.  

# Getting Started

## Setting up the Singularity Instance

1. SSH to the server
2. Run the following lines to create a new directory in the scratch drive and pull the desired container from the Singularity Hub (or other source):
```
mkdir -p /panasas/scratch/grp-adamw/singularity/$USER
cd /panasas/scratch/grp-adamw/singularity/$USER;
singularity pull -F shub://AdamWilsonLab/singularity-geospatial-r
```
Or if you are downloading from github, use something like this:
```
wget -O singularity-geospatial-r_latest.sif https://github.com/AdamWilsonLab/singularity-geospatial-r/releases/download/0.0.1/AdamWilsonLab-singularity-geospatial-r.latest.sif
```

3. Create symlinks to singularity folder in project storage to prevent disk space problems in the home directory.
```
mkdir -p /projects/academic/adamw/singularity/$USER/.singularity
ln -s /projects/academic/adamw/singularity/$USER/.singularity .singularity

# Symlinks for RStudio
mkdir -p /projects/academic/adamw/rstudio/$USER/rstudio
mv .local/share/rstudio /projects/academic/adamw/rstudio/$USER/

mkdir -p ~/.local/share
ln -s /projects/academic/adamw/rstudio/$USER/rstudio ~/.local/share/rstudio
```  
4. Run the [singularity_start.sh](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/singularity_start.sh) script to start up a singularity instance. You can just copy paste the code into the terminal.  This includes a few system specific settings for the Buffalo CCR.  This should only need to be done once (as long as the instance keeps running, server is not restarted, etc.).  If the instance stops for any reason, you'll need to rerun this script.  You can confirm it's running with `singularity instance list` or by checking `htop`.

## Connecting to RStudio

After running the steps above, you should be able to do just the following to begin working.  If the server restarts you will need to re-run step 4 above.

1. Connect to the instance via SSH with port Forwarding.  You will need to be on campus or connected via VPN.  See notes below for *nix and windows.
2. Open RStudio at localhost:8787 in your local browser and login with user/password from #4 above.

## Singularity Container: Geospatial R
This container builds upon the [rocker geospatial container](https://hub.docker.com/r/rocker/geospatial), which I ported to [Singularity here](https://singularity-hub.org/collections/4908).  This repository/collection then [adds additional packages in this file](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/Singularity.latest).  That's the file to modify if you want to add more linux packages, etc.

# Connecting via SSH

## *NIX systems (Mac and Linux)
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

# TODOs

1. Separate container from startup and monitor script
2. Switch to a docker image


# Development Notes

I started with [nickjer's very helpful example](https://github.com/nickjer/singularity-rstudio/blob/master/.travis.yml) and updated it to pull from the geospatial version of the versioned rocker stack instead of the repository based R.  This should make it easier to keep up to date.

## Errors

### Unable to connect to service

This error can appear in the web browser when connecting via localhost.  This can be caused by RStudio not being able to write session files in the right place.  Confirm that:

1. The directory `/projects/academic/adamw/rstudio/$USER/rstudio` exists
2. and is linked to `~/.local/share/rstudio`

### Could not acquire revocation list file lock

The error "Could not acquire revocation list file lock" resolved with help from [here](https://www.gitmemory.com/issue/rocker-org/rocker-versioned/213/726807289)

### database error 7
Starting in early 2021, something changed that resulted in the following error when starting a new instance:

```
ERROR database error 7 (sqlite3_statement_backend::loadOne: attempt to write a readonly database) [description: Could not delete expired revoked cookies from the database, description: Could not read revoked cookies from the database]; OCCURRED AT virtual rstudio::core::Error rstudio::core::database::Connection::execute(rstudio::core::database::Query&, bool*) src/cpp/core/Database.cpp:480; LOGGED FROM: int main(int, char* const*) src/cpp/server/ServerMain.cpp:729
```

I solved this by binding an address outside the container to `/var/lib/rstudio-server` when starting the instance as follows:
```
--bind $RSTUDIO_DB:/var/lib/rstudio-server
```
where `$RSTUDIO_DB` is just a path outside the container.  I got this idea from [this post](https://community.rstudio.com/t/permissions-related-to-upgrade-to-rstudio-server-open-source-1-4/94256/3).


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
