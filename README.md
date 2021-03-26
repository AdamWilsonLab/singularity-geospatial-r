# Singularity Status

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/4930)

# Overview
This repository includes a definition file for a singularity container _and_ instructions for starting up an instance on CENTOS in a HPC environment.  

Basic Steps:

1. SSH to the server and pull the container from the Singularity Hub (or other source) following [setup.sh](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/setup.sh).  This has already been done for horae.
2. Run the [singularity_start.sh](https://github.com/AdamWilsonLab/singularity-geospatial-r/blob/main/singularity_start.sh) script to start up a singularity instance. This includes a few system specific settings for the Buffalo CCR.  This should only need to be done once (as long as the instance keeps running, server is not restarted, etc.).
3. Connect to the instance via SSH with port Forwarding.  You will need to be on campus or connected via VPN.  See notes below for *nix and windows.
4. Open RStudio at localhost:8787 in your local browser and login with user/password from #2 above.

After running steps 1 and 2, you should be able to do just 3-4 to begin working.

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
