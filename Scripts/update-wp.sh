#! /bin/bash

# Include the valet config file.
source $(dirname "$0")/valet-wp-config.sh

for d in ${SITE_PATH}/*/ ;
do
  if [[ -e "${d}/wp-config.php" ]]
  then
    printf "\033[0;32mUpdating ${d}\e[m\n"
    wp plugin update --all --path=${d} && wp theme update --all --path=${d} && wp core update --path=${d}
  fi
done
