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

# deploy-config values are now usable as variables
# example: echo ${URL}

echo -e "\033[0;33mStarting deploy of ${1}...\x1b[m"
