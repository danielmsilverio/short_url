#!/bin/bash

echo "# - Testing Postgres: {$PGHOST} {$PGPORT} ${PGUSER}"
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Start dabase if it doesn't exist
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  mix setup
  echo "Database $PGDATABASE created."
fi

exec mix phx.server