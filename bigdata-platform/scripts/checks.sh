#!/usr/bin/env bash
set -euo pipefail

echo "Running health checks..."

# 1) Docker services
echo "- Docker services:"
docker service ls --format "table {{.Name}}\t{{.Replicas}}\t{{.Image}}"

# 2) Check Traefik certs via ACME file
if [ -f traefik/acme/acme.json ]; then
  echo "- Traefik ACME file exists"
else
  echo "WARN: acme.json not found"
fi

# 3) Prometheus scraping
echo "- Prometheus scrape targets:"
curl -fsS http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, target: .labels.instance, health: .health}' || echo "Unable to query Prometheus"

# 4) Cassandra nodetool status (requires nodetool available)
for node in cassandra1 cassandra2 cassandra3; do
  echo "Checking Cassandra on $node"
  docker exec -it $(docker ps --filter "name=$node" -q | head -n1) nodetool status || echo "nodetool status failed for $node"
done

# 5) OpenSearch cluster health
echo "- OpenSearch cluster health:"
curl -fsS http://localhost:9200/_cluster/health | jq '{status: .status, number_of_nodes: .number_of_nodes, active_shards: .active_shards}'

# 6) Grafana datasources
echo "- Grafana datasources"
curl -fsS http://admin:$(cat ./secrets/grafana_admin_password.txt)@localhost:3000/api/datasources | jq '.[] | {name: .name, type: .type}'

# 7) Alertmanager routes
echo "- Alertmanager status"
curl -fsS http://localhost:9093/api/v2/status | jq

echo "Checks done."
