# Local Dev Stack – PostgreSQL + Dragonfly + pgAdmin + RedisInsight

This repo provides a simple, reproducible local development stack:

- **PostgreSQL 18** – main relational database
- **Dragonfly** – Redis-compatible in-memory datastore
- **pgAdmin 4** – web UI for PostgreSQL
- **RedisInsight** – web UI for Dragonfly (Redis-compatible)

All services run in Docker with persistent volumes.

---

## Prerequisites

- Docker
- Docker Compose (or `docker compose` with recent Docker)

---

## Setup

1. Copy the example env file:

   ```bash
   cp .env.example .env
