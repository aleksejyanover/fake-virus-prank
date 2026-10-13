# Пранк «Фейковый вирус» — лаунчер Windows (вызывается из .bat)
# Открывает index.html полноэкранно (kiosk). Если окно закрыли раньше конца
# сценария — открывает заново, максимум 3 запуска. Ничего настоящего не удаляет.

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$html = Join-Path $here "index.html"
if (-not (Test-Path $html)) {
  Add-Type -AssemblyName System.Windows.Forms
  [System.Windows.Forms.MessageBox]::Show("Не найден index.html рядом с лаунчером.", "Фейковый вирус") | Out-Null
  exit 1
}
$url = "file:///" + ($html -replace "\\", "/")

$candidates = @()
foreach ($base in @(${env:ProgramFiles(x86)}, $env:ProgramFiles)) {
  if ($base) {
    $candidates += Join-Path $base "Microsoft\Edge\Application\msedge.exe"
    $candidates += Join-Path $base "Google\Chrome\Application\chrome.exe"
  }
}
$exe = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if (-not $exe) {
  Start-Process $html   # запасной вариант: обычное окно браузера по умолчанию
  exit 0
}

$profile = Join-Path $env:TEMP "prank-kiosk-profile"
$scenarioSeconds = 110   # сценарий ~75 сек + запас на время до нажатия «Начать»
$maxRelaunches = 2       # итого максимум 3 запуска
$relaunches = 0

while ($true) {
  $start = Get-Date
  Start-Process -FilePath $exe -ArgumentList @(
    "--kiosk", "--no-first-run",
    "--user-data-dir=`"$profile`"",
    $url
  ) -Wait
  $elapsed = ((Get-Date) - $start).TotalSeconds
  if ($elapsed -lt $scenarioSeconds -and $relaunches -lt $maxRelaunches) {
    $relaunches++
    Start-Sleep -Seconds 2
  } else {
    break
  }
}
