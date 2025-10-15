.PHONY: help dev-up dev-down prod-init prod-deploy swarm-init backup restore logs grafana-import check

include .env

help:
	@echo "Make targets: dev-up dev-down prod-init prod-deploy swarm-init backup restore logs grafana-import check"

dev-up:
	docker compose -f docker-compose.dev.yml up -d --remove-orphans

dev-down:
	docker compose -f docker-compose.dev.yml down --volumes --remove-orphans

swarm-init:
	@./scripts/deploy_swarm_init.sh

prod-deploy:
	docker stack deploy -c stack.prod.yml bigdata

backup:
	docker run --rm \
	--env-file .env \
	--name restic-backup \
	-v /var/lib/cassandra:/var/lib/cassandra:ro \
	-v /usr/share/opensearch/data:/usr/share/opensearch/data:ro \
	-v ./backup:/backup \
	-v ./secrets:/run/secrets:ro \
	restic/restic:0.17.0 \
	/bin/sh -c "/backup/backup.sh"

restore:
	docker run --rm \
	--env-file .env \
	--name restic-restore \
	-v ./backup:/backup \
	-v ./secrets:/run/secrets:ro \
	restic/restic:0.17.0 \
	/bin/sh -c "/backup/restore.sh"

logs:
	docker service logs -f --since 10m bigdata_traefik || true

grafana-import:
	# uses provisioned dashboards; force reload:
	curl -sS http://admin:$(cat ./secrets/grafana_admin_password.txt)@localhost:3000/api/dashboards/db -X POST -H "Content-Type: application/json" -d @grafana/provisioning/dashboards/infra-overview.json || true

check:
	./scripts/checks.sh
