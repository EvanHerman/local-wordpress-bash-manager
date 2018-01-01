#! /bin/bash

# Include the wp config file.
source $(dirname "$0")/wp-config.sh

# Include the wp helpers file.
source $(dirname "$0")/helpers-wp.sh

# Confirm user specified a site name.
has_site_name ${1}

# Confirm the site directory exists.
site_exists ${1}

# Check for deploy configuration file.
deploy_config_exists ${1}
if [ "${?}" -eq 1 ]; then

  # Prompt to setup the configuration file.
  echo -e "\x1b[31mError:\x1b[0m No configuration file was found for site \"${1}\" at ${SITE_PATH}/${1}/deploy-config.json."
  echo -n "Would you like to create a remote configuration file for ${1}? (y/n)? "
  read setup_deploy_config

  if echo "${setup_deploy_config}" | grep -iq "^y"; then
    # Setup deploy-config.json configuration file.
    setup_config ${1}
  fi

fi

# Abort if there is still no deploy-config.json file found.
if [ ! -f "${SITE_PATH}/${1}/deploy-config.json" ]; then
  echo -e "\x1b[31mError:\x1b[0m No configuration file was found for site \"${1}\" at ${SITE_PATH}/${1}/deploy-config.json. The deploy configuration file is required."
  exit 1
fi

setup_deploy_variables ${SITE_PATH}/${1}/deploy-config.json

# deploy-config.json values are now usable as variables
# example: echo ${URL}

echo -e "\033[0;33mStarting pulldown of ${URL} to ${1}...\x1b[m"

SITE_ROOT=${SITE_PATH}/${1}
DATE=`date +%Y-%m-%d.%H.%M.%S`

create_deploy_dirs ${SITE_ROOT}

# SSh into the remote server and export the database.
echo -e "\n\033[0;33mExporting remote database to ${WP_ROOT}/${1}-remote-${DATE}.sql...\x1b[m"
ssh ${SSH_USER}@${HOST} -p ${SSH_PORT} -o LogLevel=QUIET -t "wp db export ${WP_ROOT}/${1}-remote-${DATE}.sql --path=${WP_ROOT} ; exit ; bash"

# Download the remote site files to the local instance.
echo -e "\n\033[0;33mDownloading remote site files to ${SITE_ROOT}/${1}.\x1b[m"
rsync --exclude=wp-config.php --exclude=deploys -avz -e "ssh -p ${SSH_PORT}" ${SSH_USER}@${HOST}:${WP_ROOT}/* ${SITE_ROOT}
echo -e "\033[0;92mSuccess:\x1b[m Remote site files successfully downloaded."

# Delete the database export on the remote server
echo -e "\n\033[0;33mDeleting temporary database dump from remote server.\x1b[m"
ssh ${SSH_USER}@${HOST} -p ${SSH_PORT} -t "rm -rf ${WP_ROOT}/${1}-remote-${DATE}.sql ; exit ; bash"
echo -e "\033[0;92mSuccess:\x1b[m ${1}-remote-${DATE}.sql deleted from remote server."

# Export the local site database and store it in deploys/backup.
echo -e "\n\033[0;33mTaking a backup of ${1} and saving it to \"${SITE_ROOT}/deploys/${1}-${DATE}-backup.sql\".\x1b[m"
wp db export ${SITE_ROOT}/deploys/${1}-${DATE}-backup.sql --path=${SITE_ROOT}

# Reset the local database, prepare for import.
echo -e "\n\033[0;33mResetting the ${1} database.\x1b[m"
wp db reset --path=${SITE_ROOT} --yes

# Import the database and delete it from the local site directory.
echo -e "\n\033[0;33mImporting the remote database to ${1}.\x1b[m"
wp db import ${SITE_ROOT}/${1}-remote-${DATE}.sql --path=${SITE_ROOT}
echo -e "\n\033[0;33mDeleting the remote database dump from ${1}.\x1b[m"
rm -rf ${SITE_ROOT}/${1}-remote-${DATE}.sql
echo -e "\033[0;92mSuccess:\x1b[m ${SITE_ROOT}/${1}-remote-${DATE}.sql deleted."

# Replace old URLs with local instance URL.
echo -e "\n\033[0;33mUpdating all database instances of "${URL}" to "${1}${TLD}".\x1b[m"
wp search-replace "${URL}" "${1}${TLD}" --path=${SITE_ROOT} --quiet
echo -e "\033[0;92mSuccess:\x1b[m ${1} database values updated."

# Print success message
echo -e "\n\033[0;92mSuccess:\x1b[m ${URL} successfully cloned to $(wp option get home --path=${SITE_ROOT})."
