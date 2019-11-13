Add-Type -AssemblyName System.Windows.Forms
$Config = Import-LocalizedData -BaseDirectory $MyDir\Config -FileName Config.psd1
$ConfigVersion = $Config.VersionInfo.ProductVersion
$ConfigCheckForUpdates = $Config.Update.CheckforUpdates -eq "YES"
$ConfigUpdateDownload = $Config.Update.AutoDownload -eq "YES"
$ConfigUpdateReplaceOldVersion = $Config.Update.ReplaceOldVersion -eq "YES"
#Überprüft die Version
function Test-Version{
    #Lädt den Inhalt der Pastebin Seite mit der neusten Version
    $Update = Invoke-WebRequest http://download.hyperv-manager.de/HyperV-Manager/New_Version.html
    $Update.Content
    $ConfigVersion
    $ConfigUpdateDownload
    if ($ConfigVersion -ne $Update.Content){
        [System.Windows.Forms.MessageBox]::Show("New Update is Available","Hyper-V Manager V.2",1)
        if ($ConfigUpdateDownload){
            wget https://github.com/MinersWin/HyperV-Manager/archive/master.zip -OutFile "$($env:APPDATA)\..\Local\Temp\$($Update.Content)_Update.zip"
            [System.Windows.Forms.MessageBox]::Show("Update Downloaded")
            if ($ConfigUpdateReplaceOldVersion){
                copy .\Update.ps1 $env:APPDATA\..\Local\Temp\Update.ps1
                copy .\Config\Config.psd1 $env:APPDATA\..\Local\Temp\Config.psd1
                start powershell.exe "Set-Location $env:APPDATA\..\Local\Temp\; .\Update.ps1; Read-Host"
            }
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Nix Update","Hyper-V Manager V.2",1)
    }












    #if ($Update.Content -gt "1.9.12"){
        #######Wenn Version älter ist, als die aktuellte Gib Meldung aus
    #    Write-Host "Update Erforderlich: https://pastebin.com/TvfCY9KQ"
    #    Write-Output "$(Get-Date) Es ist ein Update erforderlich." >> $MyDir\Log\Latest.log
    #[System.Windows.Forms.MessageBox]::Show("Update ist Erforderlich, Bitte Update das Skript um die neusten Funktionen und Support zu erhalten. Alte Versionen werden nicht mehr Supportet. Aktuellste Version: https://pastebin.com/TvfCY9KQ","MinersWin Hyper-V Manager V.2",1)
    #} elseif ($Update.Content -lt "1.9.12") {
    #    #Wenn Version neuer ist als aktuellste Gib Fehler aus
    #    Write-Output "$(Get-Date) Fehler bei der Updateüberprüfung, Aktuelle Version ist älter als die Online zur verfügung stehende." >> $MyDir\Log\Latest.log
    #    Write-Host "Fehler"
    #[System.Windows.Forms.MessageBox]::Show("Fehler beim Abruf der aktuellsten Version","MinersWin Hyper-V Manager V.2",1)
    #} else {
    #    #Wenn Version die Aktuellste ist Gib Hinweis aus und fahre fort
    #    Write-Host "Alles in Ordnung"
    #    Write-Host "Aktuellste Version Installiert"
    #}
}
#Gib Version und Build im log aus
#Führe Versionstest aus
if ($ConfigCheckForUpdates){
    Test-Version
}

Write-Output "$(Get-Date) Version $($ConfigVersion) wird ausgeführt. Build: 30.09.2019" >> $MyDir\Log\Latest.log
$balloon.BalloonTipText  = "Version $($ConfigVersion) wird genutzt. Build: 30.09.2019"
$balloon.BalloonTipTitle  = "Achtung  $Env:USERNAME" 
$balloon.Visible  = $true 
$balloon.ShowBalloonTip(20) 