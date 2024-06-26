#!/bin/bash

echo "MYSQL_PASSWORD=${MYSQL_PASSWORD}"
echo "MYSQL_HOST=${MYSQL_HOST}"
echo "NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN_USER}"
echo "NEXTCLOUD_ADMIN_PASSWORD=${NEXTCLOUD_ADMIN_PASSWORD}"
echo "NEXTCLOUD_TRUSTED_DOMAINS=${NEXTCLOUD_TRUSTED_DOMAINS}"

# Start the original Nextcloud entrypoint in the background
/entrypoint.sh apache2-foreground &

echo "Wait 30 seconds for Apache to start..."
sleep 30

# Wait for the Nextcloud installation to finish by monitoring the existence of config.php
while [ ! -f /var/www/html/config/config.php ]; do
  echo "Waiting for Nextcloud to initialize..."
  sleep 5
done

# Configure Apache to suppress the ServerName warning
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Run the update_ip.sh script
/usr/local/bin/update_ip.sh

echo "update_ip.sh script finished."

# Continue with the main process
wait
