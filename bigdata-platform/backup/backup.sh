#!/usr/bin/env bash
set -euo pipefail

# usage: ./backup.sh <snapshot-tag>
TAG=${1:-manual-$(date -u +"%Y%m%dT%H%M%SZ")}

export RESTIC_PASSWORD_FILE=/run/secrets/restic_password
export RESTIC_REPOSITORY=${RESTIC_REPOSITORY}
export AWS_ACCESS_KEY_ID=${MINIO_ROOT_USER}
export AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/minio_root_password)
export AWS_ENDPOINT_URL=http://minio:9000

# ensure restic is initialized
restic -r "${RESTIC_REPOSITORY}" snapshots >/dev/null 2>&1 || restic -r "${RESTIC_REPOSITORY}" init

# Backup Cassandra data (assuming data dir is mounted or accessible)
restic -r "${RESTIC_REPOSITORY}" backup /var/lib/cassandra --tag cassandra --host $(hostname) --cleanup-cache --prune --tag ${TAG}

# Backup OpenSearch snapshots: prefer use built-in snapshot to S3; here we backup /usr/share/opensearch/data if needed:
restic -r "${RESTIC_REPOSITORY}" backup /usr/share/opensearch/data --tag opensearch --host $(hostname) --tag ${TAG}

# Backup MariaDB dump
mysqldump -u root -p$(cat /run/secrets/mariadb_root_password) --all-databases > /tmp/all-databases.sql
restic -r "${RESTIC_REPOSITORY}" backup /tmp/all-databases.sql --tag mariadb --host $(hostname) --tag ${TAG}
rm /tmp/all-databases.sql

# Backup GLPI files
restic -r "${RESTIC_REPOSITORY}" backup /var/www/html --tag glpi --host $(hostname) --tag ${TAG}

# Prune according to GFS policy (daily/week/month/year) — here we use restic forget
restic -r "${RESTIC_REPOSITORY}" forget --prune \
  --keep-daily ${RESTIC_RETENTION_G} \
  --keep-weekly ${RESTIC_RETENTION_F} \
  --keep-monthly ${RESTIC_RETENTION_S} \
  --keep-yearly ${RESTIC_RETENTION_Y}

echo "Backup completed: ${TAG}"
