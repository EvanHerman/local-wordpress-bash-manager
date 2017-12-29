#! /bin/bash

# Include the wp config file.
source $(dirname "$0")/wp-config.sh

# Include the wp helpers file.
source $(dirname "$0")/helpers-wp.sh

# Confirm user specified a site name.
has_site_name ${1}

# Confirm the site directory exists.
site_exists ${1}

# Confirm the remote config exists.
deploy_config_exists ${1}
if [ "$?" -eq 0 ]; then

  # Prompt to setup the configuration file.
  echo -e "\x1b[31mError:\x1b[0m No configuration file was found for site \"${1}\" at ${SITE_PATH}/${1}."
  echo -n "Would you like to create a remote configuration file for ${1}? (y/n)? "
  read setup_deploy_config

  if echo "${setup_deploy_config}" | grep -iq "^y"; then
    # Setup deploy-config.php configuration file.
    setup_config ${1}
  else
    exit 1
  fi
    exit 1
  fi

fi
