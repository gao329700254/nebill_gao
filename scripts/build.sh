#!/bin/bash

if [ "$RAILS_ENV" = "" ]; then
  echo $$DEPLOYMENT_GROUP_NAME
  if [ "$DEPLOYMENT_GROUP_NAME" == "development" ]; then
    RAILS_ENV="staging"
  fi
fi
echo "RAILS_ENV: $RAILS_ENV"

INSTALL_DIR=/var/www/nebill
EXEC_USER=nebill

cd $INSTALL_DIR

RAILS_ENV=$RAILS_ENV bundle install --without test development -j4 --deployment --path vendor/bundle
RAILS_ENV=$RAILS_ENV bundle exec rake bower:install['--allow-root'] bower:clean['--allow-root']
RAILS_ENV=$RAILS_ENV bundle exec rake db:migrate
RAILS_ENV=$RAILS_ENV bundle exec rake assets:precompile
