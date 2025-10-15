# Architecture (diagrammes Mermaid)

## Réseau et flux haute-niveau

```mermaid
flowchart LR
  Internet -->|80/443| Traefik[Traefik v2 (HA)]
  Traefik -->|HTTP(s)| GLPI
  Traefik --> OpenSearchDash[OpenSearch Dashboards]
  Traefik --> Grafana
  subgraph FRONT ["front network"]
    Traefik
    Grafana
    OpenSearchDash
    GLPI
  end
  subgraph BACK ["back network"]
    Prometheus
    Alertmanager
    Loki
    Promtail
  end
  subgraph DATA ["data network"]
    CassandraCluster[Cassandra (3 nodes)]
    OpenSearchCluster[OpenSearch (3 nodes)]
    MinIO
    MariaDB
  end
  GLPI -->|SQL| MariaDB
  OpenSearchDash --> OpenSearchCluster
  Grafana --> Prometheus
  Prometheus -->|scrape| Exporters[node-exporter,cAdvisor,blackbox,cassandra-exporter,opensearch-exporter]
  Promtail --> Loki
  MinIO -->|Object Storage| restic
