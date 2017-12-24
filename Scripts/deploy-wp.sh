#! /bin/bash
#!/usr/bin/expect -f

# Include the valet config file.
source $(dirname "$0")/wp-config.sh

ORIGINAL_SITE=$1
DEPLOYMENT_SERVER=$2
DEPLOYMENT_PATH=$3

if [ -z "$ORIGINAL_SITE" ]; then
  echo -e "\x1b[31mError:\x1b[0m Please specify which site to deploy."
  exit 1
fi

if [ -z "$DEPLOYMENT_SERVER" ]; then
	echo -e "\x1b[31mError:\x1b[0m Please specify a valid hostname for the server on which to deploy your site.\n\033[1mExample:\033[0m deploy-wp.sh original-site hostname-of-deployment-server"
	exit 1
fi

if [ "$ORIGINAL_SITE" == "$DEPLOYMENT_SERVER" ]; then
  echo -e "\x1b[31mError:\x1b[0m The original site and deployment server hostname are the same.  Please specify a new server to deploy your site to."
  exit 1
fi

# check if deployment server has wp cli?


# Export the database.
echo "Cloning $ORIGINAL_SITE database..."
wp db export $SITE_PATH/$ORIGINAL_SITE-export.sql --path=$SITE_PATH/$ORIGINAL_SITE --quiet
echo -e "\033[0;92mSuccess:\x1b[m $ORIGINAL_SITE database successfully exported."

# Get the ssh password
echo -p "Please enter the password of the root user for the deployment server to start an ssh session."
read -s PW

# Start the ssh session
spawn ssh root@{$DEPLOYMENT_SERVER}
expect "assword:"
send "${PW}"
interact

# Copy the files from the original site directory onto the deployment server.
echo "Deploying $ORIGINAL_SITE..."
# scp or something?
echo -e "\033[0;92mSuccess:\x1b[m $ORIGINAL_SITE copied to $DEPLOYMENT_SERVER at $DEPLOYMENT_PATH"

# # Create the database.
echo "Creating database $ORIGINAL_SITE-deployment"
wp db create --path=$SITE_PATH/$NEW_SITE --quiet
echo -e "\033[1;92mSuccess:\x1b[m Database '$ORIGINAL_SITE-deployment created."

# Import the database from the old site to the MySQL databases of the deployment server

# Edit the WP-Config file for the new site

# Regenerate the cloned site wp-config.php
rm -rf $DEPLOYMENT_PATH/wp-config.php

wp core config --path=$SITE_PATH/$NEW_SITE --dbname=$ORIGINAL_SITE-deployment --dbuser='' --dbpass='' --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('WP_MEMORY_LIMIT', '256M');
PHP

open $DEPLOYMENT_PATH
