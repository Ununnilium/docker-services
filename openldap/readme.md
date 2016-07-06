# Scripts to Run a Simple OpenLDAP Server with Docker #

With this scripts, a simple OpenLDAP server is created in a Docker image. For
simplicity, the old `slapd.conf` configuration is used.

## Usage ##
1. Create the Docker image with `build.sh`.
2. Create and run the OpenLDAP container with `run.sh`. The image name must be 
the one chosen in step 1.
