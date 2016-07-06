#!/bin/sh
script=`readlink -f "$0"`
cd "`dirname \"$script\"`"

printf "Image name? "
read image_name
printf "Container name? "
read container_name
printf "Directory for permanent files? (default /srv/docker/openldap) "
read directory
if [ ! $directory ];then
    directory=/srv/docker/openldap
fi
if [ ! -d "$directory/data" ]; then
    sudo mkdir -p "$directory/data"
fi
printf 'Domain name? (e.g. example.com) '
read domain
echo $domain | fgrep '.' > /dev/null
while [ $? -eq 0 ]; do
  domain=`echo $domain | sed 's/^\([^\.]*\)\.\(.*\)$/dc=\1,dc=\2/'`
  echo $domain | fgrep '.' > /dev/null
done
organization=`echo $domain | sed 's/^dc=\([^,]*\).*$/\1/'`
printf 'LDAP root password? '
read -s root_pw
echo
pw_hash=`docker run --rm  $image_name slappasswd -h '{CRYPT}' -c '$6$%.12s' -s "$root_pw"`
if [ ! -f "$directory/slapd.conf" ]; then
    sed -e "s/dc=example,dc=com/$domain/g" -e "s~ROOTPWHASH~$pw_hash~" conf/slapd.conf | \
        sudo tee "$directory/slapd.conf" > /dev/null
    sudo chmod 640 "$directory/slapd.conf"
fi
docker run -d -p 127.0.0.1:389:389 --name $container_name -v "$directory/data":/var/lib/openldap/openldap-data \
    -v "$directory/slapd.conf":/etc/openldap/slapd.conf $image_name
sed -e "s/dc=example,dc=com/$domain/g" -e "s~example~$organization~" conf/start.ldif | \
    docker exec -i $container_name ldapadd -x -D "cn=root,$domain" -w "$root_pw"
docker exec $container_name apk del openldap-clients

printf "\nThe OpenLDAP container \"$container_name\" was configured successfully.
You should be able to access the LDAP service with the user \"cn=root,$domain\"
and the chosen password.\n"
