#!/bin/bash
TEMPLATE_DIR=template
APP_DIR=$1

# Check if new app name only consists of letters and numbers. The directory name will be used for automatic container name generation, but some characters like "_" are not accepted
if ! [[ $APP_DIR =~ ^[A-Za-z0-9]+$ ]]; then
  echo "Please use only letters and numbers. The directory name will be used for automatic container name generation, but some characters like \"_\" are not accepted"
  exit 1
fi

cp -R $TEMPLATE_DIR $APP_DIR
cd $APP_DIR
sudo docker-compose run web rails new . --force --database=postgresql --skip-bundle
sudo chown -R christian:christian .
sudo docker-compose build
sed -e "s/\DB_HOST/${APP_DIR}_db_1/" ../$TEMPLATE_DIR/config/database.yml > ./config/database.yml
sudo docker-compose up -d
sudo docker-compose run web rake db:create