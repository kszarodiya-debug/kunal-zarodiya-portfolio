$required = @('index.html', 'styles.css', 'script.js', 'favicon.svg', 'serve.ps1', 'build.ps1')
$missing = $required | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) }
if ($missing) { Write-Error "Missing required files: $($missing -join ', ')"; exit 1 }

$html = Get-Content -Raw 'index.html'
$checks = @(
  @{ Name = 'hero'; Pattern = 'id="home"' },
  @{ Name = 'about'; Pattern = 'id="about"' },
  @{ Name = 'skills'; Pattern = 'id="skills"' },
  @{ Name = 'projects'; Pattern = 'id="projects"' },
  @{ Name = 'achievement'; Pattern = 'id="achievement"' },
  @{ Name = 'certifications'; Pattern = 'id="credentials"' },
  @{ Name = 'experience'; Pattern = 'id="experience"' },
  @{ Name = 'contact'; Pattern = 'id="contact"' },
  @{ Name = 'instagram'; Pattern = 'id="instagram"' }
)
foreach ($check in $checks) {
  if ($html -notmatch [regex]::Escape($check.Pattern)) { Write-Error "Missing $($check.Name) section"; exit 1 }
}
if ($html -notmatch 'PLACEHOLDER') { Write-Error 'Placeholder fields are not marked'; exit 1 }
$contentChecks = @('Kunal S. Zarodiya', 'PhishZero', 'CyberDragon', '@kunal_zarodiya', 'C Programming', 'Java', 'Government Polytechnic Murtizapur', 'Kali Linux', 'Wireshark')
foreach ($content in $contentChecks) {
  if ($html -notmatch [regex]::Escape($content)) { Write-Error "Missing supplied content: $content"; exit 1 }
}
$interactionChecks = @('href="#home"', 'href="#about"', 'href="#skills"', 'href="#projects"', 'href="#contact"', 'href="#instagram"', 'https://www.instagram.com/kunal_zarodiya/', 'target="_blank" rel="noopener noreferrer"', 'data-placeholder-action="Resume file"', 'data-placeholder-action="PhishZero GitHub repository"', 'data-placeholder-action="PhishZero live demo"', 'id="contact-form"', 'id="form-status"', 'aria-live="polite"')
foreach ($interaction in $interactionChecks) {
  if ($html -notmatch [regex]::Escape($interaction)) { Write-Error "Missing interaction wiring: $interaction"; exit 1 }
}
if ((Select-String -Path 'script.js' -Pattern 'placeholder-action' -SimpleMatch).Count -lt 1) { Write-Error 'Placeholder action handler is missing'; exit 1 }
if ((Select-String -Path 'script.js' -Pattern 'contactForm' -SimpleMatch).Count -lt 1) { Write-Error 'Contact form handler is missing'; exit 1 }
$css = Get-Content -Raw 'styles.css'
if ($css -notmatch ':focus-visible') { Write-Error 'Keyboard focus styling is missing'; exit 1 }
if ($html -notmatch 'aria-label=' -or $html -notmatch 'aria-controls=') { Write-Error 'Accessibility labels or menu controls are missing'; exit 1 }
$seoChecks = @('meta name="description"', 'meta name="author"', 'meta name="robots"', 'meta property="og:title"', 'meta name="twitter:card"', 'rel="icon" href="favicon.svg"')
foreach ($seoCheck in $seoChecks) {
  if ($html -notmatch [regex]::Escape($seoCheck)) { Write-Error "Missing SEO or favicon metadata: $seoCheck"; exit 1 }
}
if ($css -notmatch 'overflow-x: hidden') { Write-Error 'Responsive overflow guard is missing'; exit 1 }
Write-Host "Smoke checks passed: $($checks.Count) required sections, supplied portfolio content, interaction wiring, placeholder labels, and core files present."
