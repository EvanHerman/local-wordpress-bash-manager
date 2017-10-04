#! /bin/bash

# Include the valet config file.
source $(dirname "$0")/valet-wp-config.sh

if [ $# -ne 1 ]; then
  echo -e "\x1b[31mError:\x1b[0m You forgot to specify a site name. eg: site-name"
  exit 1
fi

DEST=$1

# Setup the database name. Convert hyphens to underscores.
DB_NAME=$(echo $DEST | sed -e 's/-/_/g')

# Download WP Core.
wp core download --path=$SITE_PATH/$DEST

# Generate the wp-config.php file
wp core config --path=$SITE_PATH/$DEST --dbname=$DB_NAME --dbuser=$DB_USER --dbpass='' --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP

# Create the database.
echo "Creating database $DB_NAME..."
wp db create --path=$SITE_PATH/$DEST

# Install WordPress core.
wp core install --path=$SITE_PATH/$DEST --url="http://$DEST$TLD" --title=$DEST --admin_user=$ADMIN_USERNAME --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL

echo -e "\033[0;92mSuccess:\x1b[m Site created.\nhttp://$DEST$TLD"
