#! /bin/bash

# Include the wp config file.
source $(dirname "$0")/wp-config.sh

ORIGINAL_SITE=$1
NEW_SITE=$2

if [ -z "$ORIGINAL_SITE" ]; then
  echo -e "\x1b[31mError:\x1b[0m You forgot to specify which site to clone."
  exit 1
fi

if [ -z "$NEW_SITE" ]; then
	echo -e "\x1b[31mError:\x1b[0m Please specify the name of the cloned site.\n\033[1mExample:\033[0m clone-wp.sh original-site new-site"
	exit 1
fi

if [ "$ORIGINAL_SITE" == "$NEW_SITE" ]; then
  echo -e "\x1b[31mError:\x1b[0m Your cloned site must use a different name than the original site."
  exit 1
fi

# Clone the original site directory.
echo "Cloning $ORIGINAL_SITE..."
cp -R $SITE_PATH/$ORIGINAL_SITE $SITE_PATH/$NEW_SITE
echo -e "\033[0;92mSuccess:\x1b[m $ORIGINAL_SITE cloned to $NEW_SITE."

# Export the database.
echo "Cloning $ORIGINAL_SITE database..."
wp db export $SITE_PATH/$NEW_SITE/$ORIGINAL_SITE-export.sql --path=$SITE_PATH/$ORIGINAL_SITE --quiet
echo -e "\033[0;92mSuccess:\x1b[m $ORIGINAL_SITE database successfully exported."

# Setup the database name. Convert hyphens to underscores.
DB_NAME=$(echo $NEW_SITE | sed -e 's/-/_/g')

# Regenerate the cloned site wp-config.php
rm -rf $SITE_PATH/$NEW_SITE/wp-config.php

wp core config --path=$SITE_PATH/$NEW_SITE --dbname=$DB_NAME --dbuser=$DB_USER --dbpass='' --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP

# Create the database.
echo "Creating database $DB_NAME..."
wp db create --path=$SITE_PATH/$NEW_SITE --quiet
echo -e "\033[1;92mSuccess:\x1b[m Database created."

# Import the sql export.
echo "Importing the database..."
wp db import $SITE_PATH/$NEW_SITE/${ORIGINAL_SITE}-export.sql --path=$SITE_PATH/$NEW_SITE --quiet
echo -e "\033[1;92mSuccess:\x1b[m Database imported."

# Update the URLs
echo "Updating the database..."
wp search-replace "http://$ORIGINAL_SITE$TLD" "http://$NEW_SITE$TLD" --path=$SITE_PATH/$NEW_SITE --quiet
echo -e "\033[1;92mSuccess:\x1b[m Database updated."

echo -e "\033[1;92mSuccess:\x1b[m Site cloned.\nURL: http://$NEW_SITE$TLD"

open http://$NEW_SITE$TLD
