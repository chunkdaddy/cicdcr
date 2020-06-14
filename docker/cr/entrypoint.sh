#!/bin/bash
set -e

# Load environment variables without overriding existing ones
source <(grep -v '^#' .env | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

if [ $PROCESS_SECRETS="False" ]; then
  service nginx start "$@"
else
  /bin/berglas exec -- service nginx start "$@"
fi

php-fpm

exec "$@"
