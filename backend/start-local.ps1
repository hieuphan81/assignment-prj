$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $PSScriptRoot '.env.local.ps1'
$mavenPath = Join-Path $repoRoot '.tools\apache-maven-3.10.0\bin\mvn.cmd'
$authDllDir = Join-Path $repoRoot '.tools\sql-auth'

if (-not (Test-Path -LiteralPath $configPath)) {
    throw 'Missing backend/.env.local.ps1. Create local database/bootstrap settings first.'
}
if (-not (Test-Path -LiteralPath $mavenPath)) {
    throw 'Maven is missing. See the backend setup instructions in README.md.'
}
. $configPath
$mavenRepo = Join-Path $repoRoot '.tools\m2-repository'
$env:MAVEN_OPTS = "-Dmaven.repo.local=`"$mavenRepo`""
$env:PATH = "$authDllDir;$env:PATH"
Push-Location $PSScriptRoot
try {
    & $mavenPath 'spring-boot:run' '-Dspring-boot.run.arguments=--server.address=127.0.0.1'
    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
