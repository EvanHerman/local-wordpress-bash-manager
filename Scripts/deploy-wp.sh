#! /bin/bash

# Include the wp config file.
source $(dirname "$0")/valet-wp-config.sh

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

ENVIRONMENT=$(get_environment_name "${SITE_PATH}/${1}/deploy-config.json" ${2})

# Confirm deploy-config.json environment exists
is_valid_environment "${SITE_PATH}/${1}/deploy-config.json" ${ENVIRONMENT}

# Setup the variables from deploy-config.json
# example: echo ${URL}
setup_deploy_variables ${SITE_PATH}/${1}/deploy-config.json ${ENVIRONMENT}

echo -e "\033[0;33mStarting deploy of ${1} to ${URL}...\x1b[m"

SITE_ROOT=${SITE_PATH}/${1}
LOCAL_URL=$(wp option get home --path=${SITE_ROOT})
DATE=`date +%Y-%m-%d.%H.%M.%S`

create_deploy_dirs ${SITE_ROOT}

# Export the local database.
echo -e "\n\033[0;33mExporting local database to ${SITE_ROOT}/${1}-local-${DATE}.sql...\x1b[m"
wp db export ${SITE_ROOT}/${1}-local-${DATE}.sql --path=${SITE_ROOT}

# Upload the local files to the remote server.
echo -e "\n\033[0;33mUploading local site files (${SITE_ROOT}/${1}) to remote server ${WP_ROOT}.\x1b[m"
rsync --exclude=wp-config.php --exclude=deploys --exclude=node_modules/ --delete -avz -e "ssh -p ${SSH_PORT}" ${SITE_ROOT}/* ${SSH_USER}@${HOST}:${WP_ROOT}
echo -e "\033[0;92mSuccess:\x1b[m Local site files successfully uploaded to remote server."

# Delete the local database export
echo -e "\n\033[0;33mDeleting temporary local database dump.\x1b[m"
rm -rf ${SITE_ROOT}/${1}-local-${DATE}.sql
echo -e "\033[0;92mSuccess:\x1b[m ${SITE_ROOT}/${1}-local-${DATE}.sql deleted."

# Export the remote site database and store it in deploys/backup.
echo -e "\n\033[0;33mTaking a database backup of ${URL} and saving it to \"${WP_ROOT}/deploys/${URL}-remote-${DATE}-backup.sql\".\x1b[m"
ssh ${SSH_USER}@${HOST} -p ${SSH_PORT} -o LogLevel=QUIET -t "wp db export ${WP_ROOT}/deploys/${URL}-remote-${DATE}-backup.sql --path=${WP_ROOT} ; exit ; bash"

# Reset the remote database, prepare for import.
# Import the local export file.
# Delete the local export file from the remote server.
echo -e "\n\033[0;33mResetting the remote database, importing the ${1} database export.\x1b[m"
ssh ${SSH_USER}@${HOST} -p ${SSH_PORT} -o LogLevel=QUIET -t "wp db reset --path=${WP_ROOT} --yes ; wp db import ${WP_ROOT}/${1}-local-${DATE}.sql --path=${WP_ROOT} ; rm -rf  ${WP_ROOT}/${1}-local-${DATE}.sql ; exit ; bash"
echo -e "\033[0;92mSuccess:\x1b[m Deleted ${WP_ROOT}/${1}-local-${DATE}.sql."

# Replace old URLs with local instance URL.
echo -e "\n\033[0;33mUpdating all database instances of "${LOCAL_URL}" to "${URL}".\x1b[m"
ssh ${SSH_USER}@${HOST} -p ${SSH_PORT} -o LogLevel=QUIET -t "wp search-replace "${LOCAL_URL}" "${URL}" --path=${WP_ROOT} --quiet ; exit ; bash"
echo -e "\033[0;92mSuccess:\x1b[m ${URL} database values updated."

# Print success message
echo -e "\n\033[0;92mSuccess:\x1b[m ${SITE_ROOT} successfully cloned to ${URL}."
