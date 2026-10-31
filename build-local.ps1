param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$toolchainRoot = Join-Path $projectRoot '.toolchain'

$localJdk = Join-Path $toolchainRoot 'zulu17.68.203-ca-jdk17.0.20.1-win_x64'
if (Test-Path (Join-Path $localJdk 'bin/java.exe')) { $env:JAVA_HOME = $localJdk }
if (-not $env:JAVA_HOME -or -not (Test-Path (Join-Path $env:JAVA_HOME 'bin/java.exe'))) {
    throw 'JDK 17 is required. Set JAVA_HOME.'
}
$localSdk = Join-Path $toolchainRoot 'android-sdk'
if (Test-Path (Join-Path $localSdk 'platforms/android-35/android.jar')) {
    $env:ANDROID_HOME = $localSdk
    $env:ANDROID_USER_HOME = Join-Path $toolchainRoot 'android-user'
}
if (-not $env:ANDROID_HOME) { throw 'Android SDK API 35 is required. Set ANDROID_HOME.' }

$python = if ($env:PYTHON -and (Test-Path -LiteralPath $env:PYTHON)) { $env:PYTHON }
    else { (Get-Command python -ErrorAction Stop).Source }
$labRuntime = Join-Path $projectRoot 'lab/src/main/assets/runtime.zip'
$sourceRuntime = Join-Path $projectRoot 'runtime/source-runtime.zip'
$labManifest = Get-Content (Join-Path $projectRoot 'lab/src/main/assets/runtime.json') -Raw | ConvertFrom-Json
$labRuntimeValid = (Test-Path -LiteralPath $labRuntime) -and
    ((Get-FileHash -LiteralPath $labRuntime -Algorithm SHA256).Hash.ToLowerInvariant() -eq $labManifest.asset_sha256)
if (-not $labRuntimeValid -and -not (Test-Path -LiteralPath $sourceRuntime)) {
    & (Join-Path $projectRoot 'tools/fetch-runtime.ps1')
}
& $python (Join-Path $projectRoot 'tools/rebase-lab-runtime.py')
if ($LASTEXITCODE -ne 0) { throw "Lab runtime verification failed: $LASTEXITCODE" }

$localGradle = Join-Path $toolchainRoot 'gradle-8.13/bin/gradle.bat'
if ($env:GRADLE_BIN -and (Test-Path -LiteralPath $env:GRADLE_BIN)) {
    $gradle = $env:GRADLE_BIN
} elseif (Test-Path -LiteralPath $localGradle) {
    $gradle = $localGradle
    $env:GRADLE_USER_HOME = Join-Path $toolchainRoot 'gradle-home'
} else {
    $gradle = Join-Path $projectRoot 'gradlew.bat'
}
Push-Location $projectRoot
try {
    & $gradle --no-daemon :lab:assembleDebug
    if ($LASTEXITCODE -ne 0) { throw "Gradle failed: $LASTEXITCODE" }
} finally { Pop-Location }

$apk = Join-Path $projectRoot 'lab/build/outputs/apk/debug/lab-debug.apk'
if (-not (Test-Path -LiteralPath $apk -PathType Leaf)) { throw "APK missing: $apk" }
$hash = (Get-FileHash -LiteralPath $apk -Algorithm SHA256).Hash.ToLowerInvariant()
Write-Output "Lab APK: $apk ($( (Get-Item -LiteralPath $apk).Length ) bytes) SHA-256 $hash"
