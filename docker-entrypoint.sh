#!/bin/bash

set -xe


sed -i "s~AuthName.*~AuthName $AUTH_NAME~" /etc/apache2/sites-available/svn-site.conf

sed -i "s~SSLCertificateFile.*~SSLCertificateFile $HTTPS_CERT~" /etc/apache2/sites-available/svn-site.conf
sed -i "s~SSLCertificateKeyFile.*~SSLCertificateKeyFile $HTTPS_KEY~" /etc/apache2/sites-available/svn-site.conf


exec apache2ctl -D FOREGROUND
