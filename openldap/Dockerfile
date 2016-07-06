FROM alpine:latest
EXPOSE 389
MAINTAINER Fabian Heller "heller.fabian@gmail.com"
RUN apk update && \
    apk upgrade && \
    apk add openldap openldap-clients && \
    wget -O - http://www.postfix-buch.com/download/postfix-book.schema.gz | \
        gzip -d > /etc/openldap/schema/postfix-book.schema
ADD ["conf/slapd.conf", "/etc/openldap/"]
CMD ["/usr/sbin/slapd", "-f", "/etc/openldap/slapd.conf", "-d", "1"]
