$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    foreach ($service in @('user', 'restaurant', 'order', 'notification')) {
        Push-Location "$service-service"
        try {
            & .\gradlew.bat bootJar --no-daemon
            if ($LASTEXITCODE -ne 0) { throw "JAR build failed: $service" }
        } finally { Pop-Location }
    }
    docker compose build --parallel
    if ($LASTEXITCODE -ne 0) { throw 'Docker image build failed' }
    docker images --filter 'reference=quickbite-*-service:latest'
} finally { Pop-Location }
