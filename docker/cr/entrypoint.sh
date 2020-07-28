#!/bin/bash
set -e

# Load environment variables without overriding existing ones
source <(grep -v '^#' .env | sed -E 's|^(.+)=(.*)$|: ${\1=\2}; export \1|g')

if [ "$PROCESS_SECRETS" = "False" ]; then
  echo "Secret Processing: Disabled"
  /usr/bin/supervisord
else
  echo "Secret Processing: Enabled"
  /bin/berglas exec -- /usr/bin/supervisord
fi

exec "$@"
