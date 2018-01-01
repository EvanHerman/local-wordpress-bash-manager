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

# Return the first environment name in deploy-config.json
# Note: Converts the specified environment to capital letters to
#       match deploy-config.json format
#
# ${1} Path to deploy-config.json for the site.
# ${2} Environment name.
function get_environment_name() {
  # User did not specify an environment.
  # Retreive the first one in deploy-config.json
  if [[ ! -n "${2}" ]]; then
    echo $(jq -r 'keys_unsorted[0]' ${1})
  else
    echo ${2} | awk '{print toupper($0)}'
  fi
}

# Confirm the specified enviroment exists inside of deploy-config.json
#
# ${1} Path to the deploy-config.json file for this site.
# ${2} Environment name. Empty if user did not specify one.
function is_valid_environment() {
  ENV_VARS=$(jq '.'${2//\"/}'' ${1})
  # Environment variables are null in deploy-config.json
  if [[ -z "${ENV_VARS}" ]] || [ 'null' == "${ENV_VARS}" ]; then
    echo -e "\x1b[31mError:\x1b[0m No environment variables set in \"${1}\" for environment \"${2}\"."
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
# Note: In bash, 1 = false, 0 = true.
#
# ${1} Site name.
function deploy_config_exists() {
  [ -f "${SITE_PATH}/${1}/deploy-config.json" ]
}

# Prompt user for deploy-config.sh info
#
# ${1} Site name.
function setup_config() {
  echo -e "\033[0;32mLet's setup the deploy configuration file for site: \"${1}\"\033[0m"
  echo -e "\033[0;32m--------Production Site--------\033[0m"
  echo -e "\033[0;32m1) What is the name of this environment?:\033[0m"
  read envName
  echo -e "\033[0;32m2) Enter the prouction site URL:\033[0m"
  read prodURL
  echo -e "\033[0;32m3) Enter the path to the WordPress root installation on the production server. (Note: Where wp-content directory is found):\033[0m"
  read prodWPRoot
  echo -e "\033[0;32m4) Enter the production hostname:\033[0m"
  read prodHostname
  echo -e "\033[0;32m5) Enter the production SSH/FTP user:\033[0m"
  read prodSSHUser
  echo -e "\033[0;32m6) Enter the production SSH/FTP password (leave blank to use SSH keys):\033[0m"
  read prodSSHPass
  echo -e "\033[0;32m7) Enter the production SSH/FTP port (default: 22):\033[0m"
  read prodPort
  echo -e "\033[0;32m8) Enter the path to the uploads directory (default: ${prodWPRoot}/wp-content/uploads/):\033[0m"
  read uploadDir
  echo -e "\033[0;32m9) Enter the path to the plugins directory (default: ${prodWPRoot}/wp-content/plugins/):\033[0m"
  read pluginDir
  echo -e "\033[0;32m10) Enter the path to the themes directory (default: ${prodWPRoot}/wp-content/themes/):\033[0m"
  read themeDir
  echo -e "\033[0;32m11) Enter the production database host (default: localhost):\033[0m"
  read dbHost
  echo -e "\033[0;32m12) Enter the production database name:\033[0m"
  read dbName
  echo -e "\033[0;32m13) Enter the production database user:\033[0m"
  read dbUser
  echo -e "\033[0;32m14) Enter the production database password:\033[0m"
  read dbPassword
  echo -e "\033[0;32m15) Enter the post hook to run after deployment has completed. (eg: echo \"Deployment Complete!\"):\033[0m"
  read postHook
  # Create the config file data array.
  CONFIG_DATA=( ${envName} ${prodURL} ${prodWPRoot} ${prodHostname} ${prodSSHUser} ${prodSSHPass} ${prodPort} ${uploadDir} ${pluginDir} ${themeDir} ${dbHost} ${dbName} ${dbUser} ${dbPassword} ${postHook} )
  create_config ${1} "${CONFIG_DATA[@]}"
}

# Create the deploy configuration file
#
# ${1} Site name.
# ${2} Configuration file data array.
function create_config() {
  echo -e "\033[0;37mCreating deploy configuration for \"${1}\"...\033[0m"
  sleep 2

	SITE_NAME=${1}

  # Create the configuration file.
  touch ${SITE_PATH}/${SITE_NAME}/deploy-config.json
  chmod 755 ${SITE_PATH}/${SITE_NAME}/deploy-config.json

  shift
  count=1

  set -- "${@}"
  # Capitalize environment name
  ENVIRONMENT=$(echo ${1} | awk '{print toupper($0)}')
  shift

  echo -e '{"'${ENVIRONMENT}'": {}}' >> "${SITE_PATH}/${SITE_NAME}/deploy-config.json"

  # Loop & define the constants.
  for i in "${@}";
    do
      # Setup new existing deploy-config.json contents.
      new_contents=$(cat ${SITE_PATH}/${SITE_NAME}/deploy-config.json | jq '.'${ENVIRONMENT}' += {"'$(get_constant ${count})'": "'${i}'"}')
      # Empty existing deploy-config.json contents.
      > ${SITE_PATH}/${SITE_NAME}/deploy-config.json
      # Add contents to existing deploy-config.json and format it.
      echo ${new_contents} | jq '.' >> ${SITE_PATH}/${SITE_NAME}/deploy-config.json
      (( count++ ))
    done

  echo -e "\033[0;32mDeploy configuration created successfully.\033[0m"
  sleep 2
}

# Get the constant based on the loop iteration.
#
# ${1} The iteration in the loop
function get_constant() {
  if [ ${1} -eq 1 ]
  then
    echo "URL"
  elif [ ${1} -eq 2 ]
  then
    echo "WP_ROOT"
  elif [ ${1} -eq 3 ]
  then
    echo "HOST"
  elif [ ${1} -eq 4 ]
  then
    echo "SSH_USER"
  elif [ ${1} -eq 5 ]
  then
    echo "SSH_PASSWORD"
  elif [ ${1} -eq 6 ]
  then
    echo "SSH_PORT"
  elif [ ${1} -eq 7 ]
  then
    echo "UPLOAD_DIR"
  elif [ ${1} -eq 8 ]
  then
    echo "PLUGIN_DIR"
  elif [ ${1} -eq 9 ]
  then
    echo "THEME_DIR"
  elif [ ${1} -eq 10 ]
  then
    echo "DB_HOST"
  elif [ ${1} -eq 11 ]
  then
    echo "DB_NAME"
  elif [ ${1} -eq 12 ]
  then
    echo "DB_USER"
  elif [ ${1} -eq 13 ]
  then
    echo "DB_PASS"
  elif [ ${1} -eq 14 ]
  then
    echo "POST_HOOK"
  fi
}

# Setup the variables for the deploy/pull scripts.
# Note: Loop over each item in deploy-config.json and make it an environment
#       variable so we can use it in our scripts.
#
# ${1} Path to deploy-config.json for the site.
# ${2} Environment name to use. (eg: production)
function setup_deploy_variables() {
  constants=$(cat ${1} | jq '.'${2}'' | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")
  # Loop and eval the variables.
  for key in ${constants}; do
    eval ${key}
  done
}

# Create the deploy directories in the site root.
#
# ${1} Site root.
function create_deploy_dirs() {
  # Deploys
  if [[ ! -d ${1}/deploys ]]; then
    mkdir ${1}/deploys
    echo -e "\n\033[0;92mSuccess:\x1b[m Deploy directory created at \"${1}/deploys/\"."
  fi
}
