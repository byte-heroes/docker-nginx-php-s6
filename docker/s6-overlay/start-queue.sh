#!/usr/bin/with-contenv sh
set -e;

# Start queue
/usr/bin/php7.2 /var/www/artisan queue:work
