#!/usr/bin/env bash
set -euo pipefail

# usage: ./restore.sh <snapshot-id> <target-path>
SNAPSHOT=${1:-latest}
TARGET=${2:-/restore}

export RESTIC_PASSWORD_FILE=/run/secrets/restic_password
export RESTIC_REPOSITORY=${RESTIC_REPOSITORY}
export AWS_ACCESS_KEY_ID=${MINIO_ROOT_USER}
export AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/minio_root_password)
export AWS_ENDPOINT_URL=http://minio:9000

mkdir -p "${TARGET}"
restic -r "${RESTIC_REPOSITORY}" restore "${SNAPSHOT}" --target "${TARGET}"

echo "Restore completed to ${TARGET}"
