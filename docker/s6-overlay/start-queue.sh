#!/usr/bin/with-contenv sh
set -e;

# Start queue
/usr/bin/php7.3 /var/www/artisan queue:work
