# ================================================
#  NETTOYER.PS1
#  Supprime les injections Cloudflare des fichiers HTML
#  A lancer apres chaque telechargement depuis Claude
# ================================================

$dossier = Split-Path -Parent $MyInvocation.MyCommand.Path
$fichiers = Get-ChildItem -Path $dossier -Filter "*.html"

$pattern1 = '<script[^>]*cloudflare[^>]*></script>'
$pattern2 = '<script[^>]*cfasync[^>]*></script>'
$pattern3 = 'src="/cdn-cgi/[^"]*"'

foreach ($fichier in $fichiers) {
    $contenu = Get-Content -Path $fichier.FullName -Raw -Encoding UTF8
    $original = $contenu

    $contenu = [regex]::Replace($contenu, $pattern1, '')
    $contenu = [regex]::Replace($contenu, $pattern2, '')

    if ($contenu -ne $original) {
        Set-Content -Path $fichier.FullName -Value $contenu -Encoding UTF8 -NoNewline
        Write-Host "Nettoye : $($fichier.Name)" -ForegroundColor Green
    } else {
        Write-Host "Propre  : $($fichier.Name)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Termine. Tu peux faire git add / commit / push." -ForegroundColor Cyan
