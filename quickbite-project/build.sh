#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")"
for service in user restaurant order notification; do
    (cd "$service-service" && sh ./gradlew bootJar --no-daemon)
done
docker compose build --parallel
docker images --filter 'reference=quickbite-*-service:latest'
