#!/bin/bash
set -e

# Restore the database if it does not already exist.
if [ -f /gotosocial/storage/sqlite.db ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists"
	litestream restore -v -if-replica-exists -o /gotosocial/storage/sqlite.db "${REPLICA_URL}"
fi

# Run litestream with your app as the subprocess.
exec litestream replicate -exec "/gotosocial/gotosocial --config-path=config.yaml server start"
