#!/bin/sh
script=`readlink -f "$0"`
cd "`dirname \"$script\"`"
printf 'Docker image name? '
read image_name
docker build -t $image_name:latest .
echo "The OpenLDAP image \"$image_name\" was build successfully."
