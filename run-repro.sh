#!/bin/bash
# Run a SQL file against a fresh database and capture the output.
# args: <sqlfile-basename> <dbname> <logfile>
set -uo pipefail
source /usr/local/cloudberry-db/cloudberry-env.sh
source "${SRC_DIR}/gpAux/gpdemo/gpdemo-env.sh"
sqlfile="$1"; db="$2"; log="$3"
dropdb --if-exists "$db"
createdb "$db"
psql -X -e -d "$db" -f "${TOOLS_DIR}/${sqlfile}" 2>&1 | tee "$log"