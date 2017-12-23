#! /bin/bash

# Loop through all WordPress installs in the localhost install
# and update all plugins, themes and core.
#
# Examples:
# update.sh                   - Update all sites.
# update.sh site1             - Update site1
# update.sh site1,site3,site5 - Update site1, site3 and site5

# Include the valet config file.
source $(dirname "$0")/valet-wp-config.sh

if [[ $# -ne 1 && -z "${ALFRED}" ]]; then
  echo -e "\x1b[31mError:\x1b[0m You did specify a site."
  read -p "Would you like to update all sites? (yes|no) " -n 1 -r
  if [[ $REPLY =~ ^[Nn]$ ]]
  then
    exit 0
  fi
fi

# Directory Name
SITE=$1

# If SITE is set
if [[ ! -z "${SITE}" ]]; then
  # Split comma delimited string.
  # eg: updatesite.sh site1,site2,site3
  if [[ ${SITE} == *","* ]]; then
    SITE=("$(echo "${SITE}" | tr ',' ' ')")
    SITE=(${SITE})
  else
    SITE=(${SITE})
  fi
else
  # Update all sites.
  # Loop through directories and confirm a wp-config.php file exists before
  # continuing with core, theme and plugin updates.
  for d in ${SITE_PATH}/*/ ;
  do
    if [[ -e "${d}/wp-config.php" ]]
    then
      SITE+="$(basename ${d}) "
    fi
  done
  SITE=(${SITE})
fi

for i in "${SITE[@]}"
do

  # Confirm the site directory exists.
  if [[ ! -d ${SITE_PATH}/${i} ]]; then
    echo -e "\x1b[31mError:\x1b[0m site "${i}" was not found at ${SITE_PATH}/${i}."
    continue
  fi

  # Confirm wp-config file exists in directory.
  if [[ ! -e "${SITE_PATH}/${i}/wp-config.php" ]]; then
    echo -e "\x1b[31mError:\x1b[0m "${SITE_PATH}/${i}" does not appear to be a WordPerss install."
    continue
  fi

  echo -e "\033[0;32mUpdating ${i}\033[0m"
  wp plugin update --all --path=${SITE_PATH}/${i} && wp theme update --all --path=${SITE_PATH}/${i} && wp core update --path=${SITE_PATH}/${i}

done
