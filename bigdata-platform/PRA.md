# PRA — Plan de Reprise d'Activité

## Objectifs mesurables
- RTO (Recovery Time Objective): 2 heures pour services critiques (GLPI, OpenSearch), 6 heures pour reconstitution complète.
- RPO (Recovery Point Objective): 24 heures (sauvegardes quotidiennes + snapshots fréquents pour OpenSearch).

## Menaces couvertes
- panne nœud unique, perte disque, corruption DB, perte quorum Swarm, compromission credentials, expiration certificats, coupure réseau locale.

## Stratégie
- Sauvegardes chiffrées restic -> MinIO (GFS: daily/weekly/monthly/yearly).
- OpenSearch snapshots via repository S3 (MinIO).
- Cassandra backups: snapshot + SSTable copy to restic; test restore.
- MariaDB: daily mysqldump & binary logs.
- Replica Swarm: 3 managers, anti-affinity.

## Runbooks essentiels

### 1) Perte d’un manager Swarm
1. Vérifier état `docker node ls`.
2. If manager down and quorum lost:
   - Promote a worker to manager if safe: `docker node promote <node>`
   - Rejoin old manager using token
3. Verify `docker node ls` shows quorum.

### 2) Restaurer GLPI / MariaDB from restic
1. `make restore` -> restore SQL dump to `/restore`.
2. Stop GLPI & MariaDB: `docker compose down`
3. Restore files to volumes and import DB: `mysql -u root -p < /restore/all-databases.sql`
4. Start services.

### 3) Cassandra node loss / restore
1. Remove node from ring: `nodetool decommission` (if still reachable)
2. Replace node using same hostname/IP; restore data from restic snapshot to `/var/lib/cassandra`
3. Run `nodetool bootstrap` & `nodetool repair` to re-sync.

### 4) OpenSearch cluster yellow/red
1. Check disk usage and shard allocation.
2. If disk full: add node or free space, or set `cluster.routing.allocation.enable` to `primaries`/`none` carefully.
3. Restore from snapshot if corruption.

### 5) Certificat ACME expiring (<14d) — automated renewal
- Traefik ACME auto-renews. If renewal failed: inspect `traefik` logs, free ports 80/443, run `docker restart traefik`.

## Checklist jour J
- Communication (incident channel, on-call)
- Identify services impacted
- Select runbook & follow
- Log timeline
- Validate services after restore (healthchecks, metrics, user acceptance)

## Tests DR (exemple)
- Quarterly: perform partial restore of GLPI & OpenSearch on staging:
  1. Restore latest snapshot into staging cluster.
  2. Run application smoke tests (login, search).
  3. Document time to recovery, issues.

## Amélioration continue
- Quarterly review, update runbooks and automation scripts.
