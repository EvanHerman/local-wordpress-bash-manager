#! /bin/bash

# Include the wp config file.
source $(dirname "$0")/wp-config.sh

# Check if the user forgot to specify a site name
# Return error and exit if no site name is specified.
#
# ${1} Site name.
function has_site_name() {
  if [[ ! -n "${1}" ]]; then
    echo -e "\x1b[31mError:\x1b[0m You forgot to specify a site name. eg: site-name"
    exit 1
  fi
}

# Check that a site directory exists.
# Return error and exit if specified site does not exist.
#
# ${1} Site name.
function site_exists() {
  if [[ ! -d ${SITE_PATH}/${1} ]]; then
    echo -e "\x1b[31mError:\x1b[0m site \"${1}\" was not found at ${SITE_PATH}/${1}."
    exit 1
  fi
}

# Check that the deploy cofig exists
#
# ${1} Site name.
function deploy_config_exists() {
  [[ ! -d ${SITE_PATH}/${1}/deploy-config.php ]]
}

# Prompt user for deploy-config.sh info
#
# ${1} Site name.
function setup_config() {
  echo -e "\033[0;32mLet's setup the deploy confiruation file for site: \"${1}\"\033[0m"
  echo -e "\033[0;32m--------Production Site--------\033[0m"
  echo -e "\033[0;32m1) Enter the prouction site URL:\033[0m"
  read prodHostname
  echo -e "\033[0;32m2) Enter the path to the WordPress root installation on the production server. (Note: Where wp-content directory is found):\033[0m"
  read prodWPRoot
  echo -e "\033[0;32m3) Enter the production hostname:\033[0m"
  read prodHostname
  echo -e "\033[0;32m3) Enter the production SSH/FTP user:\033[0m"
  read prodSSHUser
  echo -e "\033[0;32m3) Enter the production SSH/FTP port (default: 22):\033[0m"
  read prodPort
}
