# Nomcebo Printers - mobile fixes (top bar, hamburger nav, quote form fit)
# Run from INSIDE the "public" folder:  powershell -ExecutionPolicy Bypass -File ..\patch-mobile.ps1
$ErrorActionPreference = 'Stop'
if (-not ((Test-Path 'index.html') -and (Test-Path 'style.css'))) {
  Write-Host 'Run this from inside the public folder (it must contain index.html and style.css).' -ForegroundColor Red
  exit 1
}
$utf8 = New-Object System.Text.UTF8Encoding($false)

$phone = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>'
$mail  = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>'
$topbar = '<div class="topbar"><div class="wrap tb"><span class="tb-info">41A Joubert Street, Lydenburg 1120 &nbsp;|&nbsp; ISO 9001:2015</span><span class="tb-contact"><a href="tel:0131103167">' + $phone + '013 110 3167</a><a class="tb-m" href="tel:0719779164">Cell 071 977 9164</a><a href="mailto:quotes@nomceboprinters.co.za">' + $mail + 'quotes@nomceboprinters.co.za</a></span></div><div class="tb-line"></div></div>'

$oldLabel = '<label for="mt" class="menu-btn" role="button">Menu</label>'
$newLabel = '<label for="mt" class="menu-btn" role="button" aria-label="Menu"><svg viewBox="0 0 24 24" width="30" height="30" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" aria-hidden="true"><path d="M4 7h16M4 12h16M4 17h16"/></svg></label>'
$newBtn = 'Contact Us</a><a class="btn navbtn" href="contact.html#quote">Request a Quote</a></div><a class="btn navbtn-d" href="contact.html#quote">Request a Quote</a>'
$oldBand = '<div style="background:#8A0F1A;border-radius:28px;padding:48px;'
$newBand = '<div class="qband" style="background:#8A0F1A;border-radius:28px;padding:48px;'

foreach ($f in Get-ChildItem -Filter *.html) {
  $s = [IO.File]::ReadAllText($f.FullName, $utf8)
  if ($s.Contains('navbtn-d')) { Write-Host ('Already patched: ' + $f.Name); continue }
  $s = [regex]::Replace($s, '(?s)<div style="background:#8A0F1A;color:#fff;font-size:13px;font-weight:500">.*?<div style="height:3px;background:#C9A24B"></div>\s*</div>', $topbar)
  $s = [regex]::Replace($s, 'Contact Us</a></div>\s*<a class="btn" href="contact.html#quote">Request a Quote</a>', $newBtn)
  foreach ($pair in @(@($oldLabel,$newLabel), @($oldBand,$newBand))) {
    if ($s.Contains($pair[0])) { $s = $s.Replace($pair[0], $pair[1]) }
  }
  [IO.File]::WriteAllText($f.FullName, $s, $utf8)
  Write-Host ('Patched: ' + $f.Name)
}

$css = @'

/* ---- mobile fixes ---- */
.topbar{background:#8A0F1A;color:#fff;font-size:13px;font-weight:500}
.topbar a,.topbar a:hover{color:#fff;text-decoration:none}
.topbar a:hover{text-decoration:underline}
.tb{display:flex;flex-wrap:wrap;gap:6px 28px;justify-content:space-between;align-items:center;min-height:42px;padding:6px 24px}
.tb-contact{display:flex;flex-wrap:wrap;gap:6px 22px;align-items:center}
.tb svg{width:15px;height:15px;fill:currentColor;vertical-align:-3px;margin-right:6px}
.tb-line{height:3px;background:#C9A24B}
.menu-btn{padding:0;width:48px;min-height:48px;justify-content:center;border:0;color:#8A0F1A}
.navbtn{display:none}
.grid{grid-template-columns:repeat(auto-fit,minmax(min(300px,100%),1fr))}
.grid > form{min-width:0!important}
@media(max-width:1000px){
.nav .g > .navbtn-d{display:none}
.nav .links .navbtn{display:inline-flex;width:100%;box-sizing:border-box}
.tb-info,.tb-m{display:none}
.tb{justify-content:center;padding:6px 10px;font-size:12.5px}
.tb-contact{justify-content:center;gap:6px 14px}
}
@media(max-width:700px){
.qband{flex-direction:column;align-items:stretch!important;padding:24px!important;gap:24px!important}
.qband > *{flex:none!important;width:100%;min-width:0!important;box-sizing:border-box}
}
'@
$existing = [IO.File]::ReadAllText('style.css', $utf8)
if (-not $existing.Contains('mobile fixes')) { [IO.File]::AppendAllText('style.css', $css, $utf8); Write-Host 'Patched: style.css' } else { Write-Host 'Already patched: style.css' }
Write-Host 'Done. Refresh with Ctrl+F5.' -ForegroundColor Green