#! /bin/bash

# Include the valet config file.
source $(dirname "$0")/wp-config.sh

if [ $# -ne 1 ]; then
    echo $0: usage: Installation name
    exit 1
fi

DEST=$1

# Delete the database.
echo "Deleting database..."
wp db drop --path=$SITE_PATH/$DEST/ --yes

# Delete site files
echo 'Deleting files...'
rm -rf $SITE_PATH/$DEST/

echo -e "\033[0;92mSuccess:\x1b[m \033[1m$DEST\033[0m install deleted."
