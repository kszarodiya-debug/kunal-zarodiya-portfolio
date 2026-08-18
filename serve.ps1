param([int]$Port = 4173)

$root = (Get-Location).Path
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $Port)
$listener.Start()
Write-Host "Serving $root at http://localhost:$Port/"
Write-Host "Press Ctrl+C to stop."

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $reader = [IO.StreamReader]::new($stream)
    $requestLine = $reader.ReadLine()
    while ($reader.ReadLine() -ne '') { }
    $path = if ($requestLine -match '^GET\s+([^\s]+)') { $matches[1] } else { '/' }
    $relative = $path.TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($relative)) { $relative = 'index.html' }
    $file = Join-Path $root ($relative -replace '/', '\\')
    if (Test-Path -LiteralPath $file -PathType Leaf) {
      $bytes = [IO.File]::ReadAllBytes($file)
      $extension = [IO.Path]::GetExtension($file).ToLowerInvariant()
      $type = switch ($extension) { '.html' { 'text/html; charset=utf-8' } '.css' { 'text/css; charset=utf-8' } '.js' { 'text/javascript; charset=utf-8' } '.svg' { 'image/svg+xml' } default { 'application/octet-stream' } }
      $header = "HTTP/1.1 200 OK`r`nContent-Type: $type`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
    } else {
      $bytes = [Text.Encoding]::UTF8.GetBytes('Not found')
      $header = "HTTP/1.1 404 Not Found`r`nContent-Type: text/plain`r`nContent-Length: $($bytes.Length)`r`nConnection: close`r`n`r`n"
    }
    $headerBytes = [Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Close()
    $client.Close()
  }
} finally { $listener.Stop() }
