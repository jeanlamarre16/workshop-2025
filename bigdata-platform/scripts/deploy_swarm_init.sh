#!/usr/bin/env bash
set -euo pipefail

# Bootstrap Swarm managers and create secrets (idempotent)
# Run on first manager node.

# Init if not in swarm
if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q "active"; then
  docker swarm init --advertise-addr $(hostname -I | awk '{print $1}')
else
  echo "Already in a swarm."
fi

# Create manager replicas (instructions only — actual join tokens used on other nodes)
MANAGER_TOKEN=$(docker swarm join-token -q manager)
WORKER_TOKEN=$(docker swarm join-token -q worker)

echo "Manager token: ${MANAGER_TOKEN}"
echo "Worker token: ${WORKER_TOKEN}"

# Create secrets if not exist
for s in mariadb_root_password.txt glpi_db_password.txt grafana_admin_password.txt minio_root_password.txt restic_password.txt; do
  if [ -f "./secrets/$s" ]; then
    secret_name=${s%.txt}
    if ! docker secret ls --format '{{.Name}}' | grep -q "^$secret_name$$"; then
      docker secret create $secret_name ./secrets/$s
      echo "Created secret $secret_name"
    else
      echo "Secret $secret_name already exists"
    fi
  fi
done

# Create overlay networks
docker network create --driver overlay --attachable front || true
docker network create --driver overlay --attachable back || true
docker network create --driver overlay --attachable data || true

echo "Swarm init done. Please join other nodes using the tokens printed above."
