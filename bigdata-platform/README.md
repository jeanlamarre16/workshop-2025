# BigData Platform — Dockerized (Dev + Prod Swarm)

## Objectif
Fournir une plateforme Big Data prête à l'emploi en dev (docker compose) et production (docker swarm) comprenant GLPI, OpenSearch, Cassandra, monitoring (Prometheus/Grafana), logging (Loki), MinIO + restic backup, Traefik + CrowdSec, nftables.

## Prérequis
- Hôtes Linux (Ubuntu/CentOS)
- Docker Engine (20.10+) & Docker Compose v2 for dev
- Docker Swarm init on first manager
- Ports 80/443/2377/7946/4789 ouverts entre nœuds
- DNS entries for services (`glpi.${DOMAIN}`, `opensearch.${DOMAIN}`, etc.)
- Node labels for placement (see `stack.prod.yml`)
- `jq`, `curl`, `restic` (for local testing)
- Create `./secrets/*.txt` files (see `secrets.sample`) or create Docker secrets

## Fichiers clés
- `docker-compose.dev.yml` — dev
- `stack.prod.yml` — swarm
- `traefik/` — traefik config
- `prometheus/`, `alertmanager/` — monitoring
- `grafana/` — dashboards provisioning
- `backup/backup.sh` & `restore.sh`
- `scripts/` — swarm init, checks

## Déploiement local (dev)
1. Copier `.env.example` -> `.env` et ajuster.
2. Fournir secrets dans `./secrets/*.txt`.
3. `make dev-up`
4. Vérifier : 
   - `http://localhost:8080` Traefik dashboard
   - `http://localhost:3000` Grafana (admin password in secrets)
   - `http://localhost:5601` OpenSearch Dashboards

## Déploiement production (Swarm)
1. Préparer 3 managers, labels nodes (storage/app/db).
2. Sur manager1: `./scripts/deploy_swarm_init.sh`
3. Join nodes with printed tokens.
4. Create Docker secrets from `./secrets/*.txt` (if not already)
   - `docker secret create mariadb_root_password ./secrets/mariadb_root_password.txt`
   - ...
5. `make prod-deploy`
6. Vérifier services, dns, certs.

## Sauvegarde / Restauration
- `make backup` (calls restic scripts)
- `make restore` (example restore)

## Tests de santé
- `make check` runs `scripts/checks.sh`

## Comptes de demo
- Grafana: user `admin` / password in `secrets/grafana_admin_password.txt`.
- MinIO: `MINIO_ROOT_USER` and secret password.

## Sécurité
- TLS obligatoire (ACME auto).
- nftables rules in `nftables/nftables.rules`.
- Capabilities dropped and `no-new-privileges` recommended in compose/stack (set via deploy configs or Dockerfile).
- Secrets in Docker secrets.
- RBAC: enable on OpenSearch, Cassandra internal auth, and Grafana organization users.

## PRA
Voir `PRA.md` pour runbooks, RTO/RPO, tests DR et checklists.

