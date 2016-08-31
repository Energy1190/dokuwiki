FROM debian:jessie
MAINTAINER Dmitry  K "d.p.karpov@gmail.com"

#run docker run --rm --name dokuwiki-ng --cap-add=sys_admin --device=/dev/fuse:/dev/fuse dokuwiki:ng

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root

RUN sed -i 's/archive.ubuntu.com/ru.archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confold" upgrade && apt-get -y remove fuse && \
apt-get -y -o Dpkg::Options::="--force-confold" install wget \
	lighttpd \
	php5-cgi \
	php5-ldap \
	php5-gd \
	dokuwiki \
	build-essential libcurl4-openssl-dev libxml2-dev mime-support && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


##disable sshd
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN rm -rf /etc/service/cron

ADD ./dokuwiki.conf /etc/lighttpd/conf-enabled/50-dokuwiki.conf

RUN mkdir /var/run/lighttpd && chown www-data:www-data /var/run/lighttpd
RUN lighty-enable-mod fastcgi fastcgi-php accesslog dokuwiki || true

RUN mkdir /etc/service/lighttpd
ADD ./lighttpd.sh /etc/service/lighttpd/run
RUN chmod +x /etc/service/lighttpd/run

RUN rm /etc/dokuwiki/mime.conf
RUN ln -fs /var/lib/dokuwiki/conf/mime.conf /etc/dokuwiki/mime.conf

VOLUME /var/lib/dokuwiki

EXPOSE 80
CMD ["/sbin/my_init"]