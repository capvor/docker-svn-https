#!/bin/bash

set -xe

if [[ $TIME_ZONE != "" ]]; then
    time_zone=/usr/share/zoneinfo/$TIME_ZONE
    if [[ ! -e $time_zone ]]; then
        echo "invalid time zone"
        exit 1
    else
        ln -snf $time_zone /etc/localtime
        echo "$TIME_ZONE" > /etc/timezone
    fi
fi

if [ ! -f "/var/svn/svn-site.conf" ]; then
    a2ensite svn-site.conf
else
    ln -snf /var/svn/svn-site.conf /etc/apache2/sites-enabled/svn-site.conf
fi

exec apache2ctl -D FOREGROUND
