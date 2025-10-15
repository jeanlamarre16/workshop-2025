CREATE KEYSPACE IF NOT EXISTS telemetry
WITH replication = {'class': 'NetworkTopologyStrategy', 'dc1': 3}
AND durable_writes = true;

CREATE TABLE IF NOT EXISTS telemetry.events (
  id uuid PRIMARY KEY,
  ts timestamp,
  service text,
  severity int,
  message text
);
