#!/bin/sh

ln -fs /var/lib/dokuwiki/conf/users.auth.php /etc/dokuwiki/users.auth.php
ln -fs /var/lib/dokuwiki/conf/acl.auth.php /etc/dokuwiki/acl.auth.php
ln -fs /var/lib/dokuwiki/conf/local.php /etc/dokuwiki/local.php


/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf