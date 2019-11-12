<#
    .MOTIVATION
        Ich hab noch nie ein Programm derart in Powershell gefunden, also dachte Ich mir machste es selber.
    .DATEN
        Name: HyperV-Manager.ps1
        Version: B.E.T.A. 1.9.11
        Author: Minerswin
        Creation-Date: 09-04-2019
        Last-Update: 02.07.2019
        Mail: hyperv-manager@minerswin.de
    .CHANGELOG
        B.E.T.A. 1.9.0  - MinersWin - 10.04.2019 - Nun mit GUI + Auswahl des Hosts + Auswahl der VM
        B.E.T.A. 1.9.1  - MinersWin - 11.04.2019 - Erstellung einer TextBox um dauerhaft den Aktuellen Status anzeigen zu lassen + Erstellung eigener VMs (Ohne Funktion)
        B.E.T.A. 1.9.2  - MinersWin - 12.04.2019 - Einbringung einiger Funktionen: Snapshots, ISOS, und Start/Stop
        B.E.T.A. 1.9.3  - MinersWin - 15.04.2019 - Möglichkeit der Erstellung Virtueller Switches, Bearbeiten der VMs, ERstellung von Startskripten, Installation der Verwaltungstools + Rechtevergabe
        B.E.T.A. 1.9.4  - MinersWin - 16.04.2019 - Automatische erkennung der VMs, übersichtlichere Formatierung, Einbindung der Thumbnailfunktion + ISO Wechsel + Feedback Form
        B.E.T.A. 1.9.5  - MinersWin - 17.04.2019 - Erstellung einer Config.txt, Automatisches Erstellen einer temporären log-Datei, Einbau der Funktion, die Log + Computerinfos bei Problemen an den Entwickler zu senden
        B.E.T.A. 1.9.6  - MinersWin - 18.04.2019 - Möglichkeit zur Speicherung der Log Datei, Automatisch überprüfung der Version
        B.E.T.A. 1.9.7  - MinersWin - 29.04.2019 - Möglichkeit der Erstellung von VMs, einfügen einer Feedback Funktion
        B.E.T.A. 1.9.8  - MinersWin - 30.04.2019 - Möglichkeit des An/Ausschaltens von VMs + Möglichkeit zur Festlegung von Prozessorkernen, RAM und ISO Datei bei der Erstellung
        B.E.T.A. 1.9.9  - MinersWin - 20.05.2019 - Möglichkeit zur erstellung von Virtuellen Switches und verbesserung der LOG Datei
        B.E.T.A. 1.9.10 - MinersWin - 21.05.2019 - Fertigstellung der VM Edit Funktion + Autosenden des Feedbacks an den Creator.
        B.E.T.A. 1.9.11 - MinersWin - 02.07.2019 - Entfernen des MailServers + Configupdate
        B.E.T.A. 1.9.12 - MinersWin - 04.07.2019 - Integration von BallonTips, 
        B.E.T.A. 1.9.13 - MinersWin - 10.07.2019 - Möglichkeit zur änderung des Namens in der Config Datei sowie eintragen eigener Mail Server, Automatische erstellung der Config Datei, Erstellung einer Start.bat, überarbeitung der Readme, Update auf GitHub
    .BEISPIEL
        .\HyperV-Manager.ps1 
    .IN_ZUKUNFT_GEPLANT
      - Automatische Erstellung von Connect-Skripts
      - Automatische Rechtezuweisung für die Einzelen Personen
      - Wenn Template Vorhanden soll das Benutzt werden (spart Installation)
      - Erstellung eines Clients für die Azubis, mit welchem sie VMs beantragen können.
      - Automatische Installation der Verwaltungsdienste auf den Azubi-Computern
      - Möglichkeit RAM,CPU,NETZWERK,FESTPLATTENGRößE usw. zu ändern
      - Start-Animation
      - ...
    .LIZENZ
      Es ist Verboten diese Dateien Weiterzuverkaufen, als Eigenwerk auszugeben oder zu Lizenzieren.
      Es ist Erlaubt Teile des Codes bzw. Dateien für eigene Projekte zu übernehmen, diese Projekte dürfen jedoch keinen Kommerziellen Nutzen haben, müssen unter gleichen Bedingungen weitergegeben werden und Minerswin muss als Urheber mitgenannt werden.
      Das Projekt unterliegt der Creative Commons Lizenz 4.0 mit "by", "nc" und "sa" Modulen, d.h. Der Name des Urhebers muss genannt werden, Kommerzielle Nutzung ist Verboten, die Weitergabe muss unter den Selben bedingungen geschehen. 
    .PROBLEMBEHANDLUNG
      - Sollte es zu diesem Fehler kommen, "Die Datei .\HyperV-Manager.ps1 kann nicht geladen werden, da die Ausführung von Skripts auf diesem System deaktiviert ist." lässt sich dieses durch das Ausführn des Folgenden Befehls beheben: "Set-ExecutionPolicy Unrestricted -Scope Process"
      - Sollte es zu diesem Fehler kommen, "Get-ADComputer : Es wurde kein Standardserver gefunden, auf dem die Active Directory-Webdienste ausgeführt werden." Kann es sein, dass sich der Computer in keiner Domäne befindet, oder dass die Active Directory Dienste nicht Installiert bzw. Aktiviert sind.#
      - Sollte es zu diesem Fehler kommen, "Get-VM : Sie besitzen nicht die erforderliche Berechtigung für diese Aufgabe. Wenden Sie sich an den Administrator der Autorisierungsrichtlinie für Computer {Hostname}." Kann es sein, dass entweder die Hyper-V Plattform nicht auf dem ZielServer Installiert ist oder dem Nutzer die Rechte der Remotedesktopverwaltung fehlen.
      - Sollte es zu diesem Fehler kommen, "Get-VM : Von Hyper-V wurde kein virtueller Computer mit dem Namen {Name} gefunden." dann ist entweder der Name der VM falsch eingegeben worden oder eine ungültige VM ausgewählt worden.
    .FAQ
      - Ich habe einen Fehler gefunden, wo kann ich ihn Melden? - Dazu kann man einfach im Reiter Aktion auf Feedback gehen und im Feld das Feedback eingeben. Alternativ einfach eine E-Mail an "HyperV-Manager@MinersWin.de" schreiben.
      - Werden irgenwelche Daten gesammelt? - Die Log-Dateien werden mit dem Beenden des Programms gelöscht, sofern sie nicht über den Button Informationen Senden an den Ersteller Gesendet wurden.
#>

#___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________#
#Setzt $MyDir zum Pfad, in welchem das Skript ausgeführt wird.
$MyDir = Split-Path $script:MyInvocation.MyCommand.Path
Set-Location $MyDir

#
#__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
.\Script\CreateNewConfig.ps1

#___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________#
#Einlesen der Einstellungen aus der Config Datei
$Config = Import-LocalizedData -BaseDirectory $MyDir\Config -FileName Config.psd1
#Version Info
$ConfigName = $Config.Name
$ConfigDirectoryName = $Config.DirectoryName
$ConfigVersion = $Config.VersionInfo.ProductVersion
$ConfigBuild = $Config.VersionInfo.Build
$ConfigLastUpdate = $Config.VersionInfo.LastUpdate
$ConfigLastUpdateSearch = $Config.VersionInfo.LastUpdateSearch
$ConfigAuthor = $Config.VersionInfo.Author
$ConfigCompanyName = $Config.VersionInfo.CompanyName
$ConfigDescription = $Config.VersionInfo.Description
#Updates
$ConfigCheckForUpdates = $Config.Update.CheckforUpdates -eq "YES"
$ConfigNewestVersion = $Config.Update.NewestVersion
$ConfigUpdateWarn = $Config.Update.Warn -eq "YES"
$ConfigUpdateDownload = $Config.Update.AutoDownload -eq "YES"
$ConfigUpdateScript = $Config.Update.UpdateScript
$ConfigUpdateReplaceOldVersion = $Config.Update.ReplaceOldVersion -eq "YES"
$ConfigUpdateSaveOldVersion = $Config.Update.SaveOldVersion -eq "YES"
$ConfigUpdateNewLanguages = $Config.Update.DownloadNewLanguages -eq "YES"
#Language
$ConfigLanguage = $Config.Language.Language
#Websites
$ConfigDonate1 = $Config.Websites.Donate1
$ConfigDonate2 = $Config.Websites.Donate2
$ConfigAboutSite = $Config.Websites.AboutSite
#Mail
$ConfigMailSendTo = $Config.Mail.SendFeedbackTo
#SMTP
$ConfigSMTPUsername = $Config.Mail.Username
$ConfigSMTPPassword = $Config.Mail.Password
$ConfigSMTPServer = $Config.Mail.SmtpServer
$ConfigSMTPPort = $Config.Mail.SmtpPort
#Path
$ConfigPathSaveInTemp = $Config.Update.SaveInTemp -eq "YES"
$ConfigPathThumbnailPath = $Config.Path.ThumbnailPath
$configPathLogPath = $Config.Path.LogPath

Write-Host $ConfigName $ConfigDirectoryName $ConfigVersion $ConfigBuild $ConfigLastUpdate $ConfigLastUpdateSearch $ConfigAuthor $ConfigCompanyName $ConfigDescription $ConfigCheckForUpdates $ConfigNewestVersion $ConfigUpdateWarn $ConfigUpdateDownload $ConfigUpdateScript $ConfigUpdateReplaceOldVersion $ConfigUpdateSaveOldVersion $ConfigUpdateNewLanguages $ConfigLanguage $ConfigDonate1 $ConfigDonate2 $ConfigAboutSite $ConfigMailSendTo $ConfigSMTPUsername $ConfigSMTPPassword $ConfigSMTPServer $ConfigSMTPPort $ConfigPathSaveInTemp $ConfigPathThumbnailPath $configPathLogPath

#__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
#Erstellung der Funktion Invoke-BalloonTip

Function Invoke-BalloonTip {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True,HelpMessage="The message text to display. Keep it short and simple.")]
        [string]$Message,
        [Parameter(HelpMessage="The message title")]
         [string]$Title="Attention $env:username",
        [Parameter(HelpMessage="The message type: Info,Error,Warning,None")]
        [System.Windows.Forms.ToolTipIcon]$MessageType="Info",
        [Parameter(HelpMessage="The path to a file to use its icon in the system tray")]
        [string]$SysTrayIconPath='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe',     
        [Parameter(HelpMessage="The number of milliseconds to display the message.")]
        [int]$Duration=1000
    )
    If (-NOT $global:balloon) {
        $global:balloon = New-Object System.Windows.Forms.NotifyIcon
        [void](Register-ObjectEvent -InputObject $balloon -EventName MouseDoubleClick -SourceIdentifier IconClicked -Action {
            Write-Verbose 'Disposing of balloon'
            $global:balloon.dispose()
            Unregister-Event -SourceIdentifier IconClicked
            Remove-Job -Name IconClicked
            Remove-Variable -Name balloon -Scope Global
        })
    }
    $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($SysTrayIconPath)
    $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]$MessageType
    $balloon.BalloonTipText  = $Message
    $balloon.BalloonTipTitle = $Title
    $balloon.Visible = $true
    $balloon.ShowBalloonTip($Duration)
    Write-Verbose "Ending function"
}
#___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________#
#Erstellung der GUI
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Hyper-V.designer.ps1')

#Hinzufügen der Funktionen zu den Buttons
$Button1.Add_Click({ Set-VM })
$Button5.Add_Click({ Show-Snapshot })
$Button4.Add_Click({ Create-Snapshot })
$Button8.Add_Click({ VM-Start })
$Button9.Add_Click({ VM-Stop })
$Button12.Add_Click({ Set-ISO })
$Button10.Add_Click({ Get-BootISOFileName })
$Button11.Add_Click({ Iso-Clear })
$Button14.Add_Click({ Set-Host })
$Button24.Add_Click({ Connect-VM })
$Button25.Add_Click({ Open-Manager })
$Button26.Add_Click({ Get-Thumbnail })
$Button28.Add_Click({ Send-Information })
$Button27.Add_Click({ Save-Log })
$Button13.Add_Click({ Reload-Hosts })
$Button18.Add_Click({ Set-Edit })
$DonateToolStripMenuItem.Add_Click({ Go-Donate })
$FeedbackToolStripMenuItem.Add_Click({ Send-Feedback })
$AboutToolStripMenuItem.Add_Click({ About })
$Button6.Add_Click{( Erstelle-VM )}
$button2.Add_Click{( Get-BootISOFileName_2 )}
$PictureBox1.Add_Click{( Connect-VM )}
$Label38.Add_Click{( Invoke-Expression "$($MyDir)\Thumbnails\" <#Öffnet Ordner beim Klick#> )}
$Button20.Add_Click{( Grant-Permission )}

#Panel unsichtbar machen
$Panel10.Enabled = $false #Rechte Vergeben
$Panel11.Enabled = $False #Startskript erstellen
$Panel7.Enabled = $False #VM Bearbeiten
$Panel3.Enabled = $False #Snapshot erstellen
$Panel4.Enabled = $False #Start/Stop
$Panel5.Enabled = $False #ISO Einlegen
$Panel9.Enabled = $False #Virtuellen Switch erstellen
$Panel1.Enabled = $False #VM Erstellen
$Panel8.Enabled = $False #Info
$Panel17.Enabled = $False
$Panel16.Enabled = $False


#Knöpfe Unsichtbar machen
$Button24.Enabled = $false
$Button26.Enabled = $false

#Auswahl unsichtbar machen
$ComboBox1.Enabled = $false

$RichTextBox1.Enabled = $false
$RadioButton1.Checked = $true

#
#______________________________________________________________________________________________________________________________________________________________________________________________
#Home Infos
$Label65.Text = $ConfigName
$Label67.Text = $ConfigDirectoryName
$Label69.Text = $ConfigVersion
$Label71.Text = $ConfigBuild
$Label73.Text = $ConfigLastUpdate
$Label75.Text = $ConfigCompanyName
$Label77.Text = $ConfigLanguage
$Label79.Text = "$Env:USERNAME"
$Label81.Text = "$($env:UserDomain)"
$Label83.Text = "$Env:LOGONSERVER"

#
#_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
#Funktion für BaloonTips
Add-Type -AssemblyName  System.Windows.Forms 
$global:balloon = New-Object System.Windows.Forms.NotifyIcon 
Get-Member -InputObject  $Global:balloon 
[void](Register-ObjectEvent  -InputObject $balloon  -EventName MouseDoubleClick  -SourceIdentifier IconClicked  -Action {
    $global:balloon.dispose()
    Unregister-Event  -SourceIdentifier IconClicked
    Remove-Job -Name IconClicked
    Remove-Variable  -Name balloon  -Scope Global
  }) 
  $path = (Get-Process -id $pid).Path
  $balloon.Icon  = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
  $balloon.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Warning
#___________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________#
#Einlesen der Einstellungen aus der Config Datei
if (Test-Path $MyDir\Log\Latest.log){
    $OldLog = Get-Content "$($MyDir)\Log\Latest.log"
    $OldLog[0]
    $NewName = $OldLog[0]
    $NewName = "$($NewName)-LOG"
    $NewName
    "$($MyDir)\Log\$($NewName).txt"
    Write-Output $OldLog >> "$($MyDir)\Log\$($NewName).txt"
    rm $MyDir\Log\Latest.log
} else {
    Write-Output ChickenHung
}

#Log schreiben bei Start Log mit Datum Speichern, welches in der ersten Zeile stehen wird und danach gelöscht und neu Befüllt wird Mfg Hullos

Write-Output (("{0:yyyy-MM-dd-HH-mm-ss}" -f (get-date)).ToString()) >> $MyDir\Log\Latest.log
Write-Output "" >> $MyDir\Log\Latest.log
Write-Output "" >> $MyDir\Log\Latest.log
Write-Output "                   _______  _______  _______                 " >> $MyDir\Log\Latest.log
Write-Output "|\     /||\     /||  ____ ||  ____ \|  ____ |       |\     /|" >> $MyDir\Log\Latest.log
Write-Output "| |   | || \   / || |    ||| |    \/| |    ||       | |   | |" >> $MyDir\Log\Latest.log
Write-Output "| |___| | \ \_/ / | |____||| |__    | |____|| _____ | |   | |" >> $MyDir\Log\Latest.log
Write-Output "|  ___  |  \   /  |  _____||  __|   |    ___||_____|| |   | |" >> $MyDir\Log\Latest.log
Write-Output "| |   | |   | |   | |      | |      | |\ \           \ \_/ / " >> $MyDir\Log\Latest.log
Write-Output "| |   | |   | |   | |      | |____/\| | \ \_          \   /   " >> $MyDir\Log\Latest.log
Write-Output "|/     \|   |_|   |/       |_______/|/   \__|          \_/   " >> $MyDir\Log\Latest.log
Write-Output "                                                             " >> $MyDir\Log\Latest.log
Write-Output " _________  _______  _        _______  _______  _______  _______ " >> $MyDir\Log\Latest.log
Write-Output "|  _   _  ||  ___  || \    /||  ___  ||  ____ \|  ____ \|  ____ |" >> $MyDir\Log\Latest.log
Write-Output "| | | | | || |   | ||  \  | || |   | || |    \/| |    \/| |    ||" >> $MyDir\Log\Latest.log
Write-Output "| | | | | || |___| ||   \ | || |___| || |      | |__    | |____||" >> $MyDir\Log\Latest.log
Write-Output "| | |_| | ||  ___  || |\ \| ||  ___  || | ____ |  __|   |     __|" >> $MyDir\Log\Latest.log
Write-Output "| |     | || |   | || | \   || |   | || | \_  || |      | |\  |  " >> $MyDir\Log\Latest.log
Write-Output "| |     | || |   | || |  \  || |   | || |___| || |____/\| | \ \__" >> $MyDir\Log\Latest.log
Write-Output "|/       \||/     \||/    |_||/     \||_______||_______/|/   \__/" >> $MyDir\Log\Latest.log
Write-Output "" >> $MyDir\Log\Latest.log
Write-Host "                   _______  _______  _______                 "
Write-Host "|\     /||\     /||  ____ ||  ____ \|  ____ |       |\     /|"
Write-Host "| |   | || \   / || |    ||| |    \/| |    ||       | |   | |"
Write-Host "| |___| | \ \_/ / | |____||| |__    | |____|| _____ | |   | |"
Write-Host "|  ___  |  \   /  |  _____||  __|   |    ___||_____|| |   | |"
Write-Host "| |   | |   | |   | |      | |      | |\ \           \ \_/ / "
Write-Host "| |   | |   | |   | |      | |____/\| | \ \_          \   /  "
Write-Host "|/     \|   |_|   |/       |_______/|/   \__|          \_/   "
Write-Host "                                                             "
Write-Host " _________  _______  _        _______  _______  _______  _______ "
Write-Host "|  _   _  ||  ___  || \    /||  ___  ||  ____ \|  ____ \|  ____ |"
Write-Host "| | | | | || |   | ||  \  | || |   | || |    \/| |    \/| |    ||"
Write-Host "| | | | | || |___| ||   \ | || |___| || |      | |__    | |____||"
Write-Host "| | |_| | ||  ___  || |\ \| ||  ___  || | ____ |  __|   |     __|"
Write-Host "| |     | || |   | || | \   || |   | || | \_  || |      | |\  |  "
Write-Host "| |     | || |   | || |  \  || |   | || |___| || |____/\| | \ \__"
Write-Host "|/       \||/     \||/    |_||/     \||_______||_______/|/   \__/"
  $balloon.BalloonTipText  = 'Starte Hyper-V Manager V.2'
  $balloon.BalloonTipTitle  = "Achtung  $Env:USERNAME" 
  $balloon.Visible  = $true 
  $balloon.ShowBalloonTip(20) 

Write-Host "Look behind this Window!"
$FormOverview.text = $ConfigName

if ($ConfigLanguage -eq 'de-DE'){
    .\Script\UpdateGerman.ps1
} elseif ($ConfigLanguage -eq 'en-EN') {
    .\Script\UpdateEnglisch.ps1
} else {
    [System.Windows.Forms.MessageBox]::Show("Ungültige Sprache.....","Hyper-V Manager V.2 by MinersWin",1)
    break
}

#Fügt Domain\Name in die Rechtevergabe ein
$TextBox13.Text = "$($env:UserDomain)\$($env:UserName)"
Write-Host "$($env:UserDomain)\$($env:UserName)"

#Überprüft die Version
function Test-Version{
    #Lädt den Inhalt der Pastebin Seite mit der neusten Version
    $Update = Invoke-WebRequest https://pastebin.com/raw/zBUriG1D

    $Update.Content
    if ($Update.Content -gt "1.9.12"){
        #Wenn Version älter ist, als die aktuellte Gib Meldung aus
        Write-Host "Update Erforderlich: https://pastebin.com/TvfCY9KQ"
        Write-Output "$(Get-Date) Es ist ein Update erforderlich." >> $MyDir\Log\Latest.log
    [System.Windows.Forms.MessageBox]::Show("Update ist Erforderlich, Bitte Update das Skript um die neusten Funktionen und Support zu erhalten. Alte Versionen werden nicht mehr Supportet. Aktuellste Version: https://pastebin.com/TvfCY9KQ","MinersWin Hyper-V Manager V.2",1)
    } elseif ($Update.Content -lt "1.9.12") {
        #Wenn Version neuer ist als aktuellste Gib Fehler aus
        Write-Output "$(Get-Date) Fehler bei der Updateüberprüfung, Aktuelle Version ist älter als die Online zur verfügung stehende." >> $MyDir\Log\Latest.log
        Write-Host "Fehler"
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Abruf der aktuellsten Version","MinersWin Hyper-V Manager V.2",1)
    } else {
        #Wenn Version die Aktuellste ist Gib Hinweis aus und fahre fort
        Write-Host "Alles in Ordnung"
        Write-Host "Aktuellste Version Installiert"
    }
}
#Gib Version und Build im log aus
Write-Output "$(Get-Date) Version 1.9.17 wird ausgeführt. Build: 30.09.2019" >> $MyDir\Log\Latest.log
$balloon.BalloonTipText  = 'Version 1.9.17 wird genutzt. Build: 30.09.2019'
$balloon.BalloonTipTitle  = "Achtung  $Env:USERNAME" 
$balloon.Visible  = $true 
$balloon.ShowBalloonTip(20) 
#Führe Versionstest aus
Test-Version


<#
#Prüfe auf Adminrechte
function Test-IsAdmin {
    try {
        Write-Output "$(Get-Date) Suche nach Adminrechten" >> $MyDir\Log\Latest.log
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
    } catch {
        Write-Output "$(Get-Date) Fehler beim überprüfen der Adminrechten" >> $MyDir\Log\Latest.log
        throw "Fehler beim erstellen der Benutzerrechte. Error: '{0}'." -f $_
    }
  }
 #
  #Überprüft Admin rechte
if (-not(Test-IsAdmin)) {
    Write-Output "$(Get-Date) Programm wurde ohne Adminrechte gestartet" >> $MyDir\Log\Latest.log
    $LabelOverview.text = "Keine Adminrechte!"
    $RichTextBox1.Text = "Bitte starte das Programm mit Admintrechten neu!"
    [System.Windows.Forms.MessageBox]::Show("Bitte Starte das Programm mit Adminrechten neu!","MinersWin Hyperv Manager",1)
    #exit
}
else {$LabelOverview.Text = $Hostname.ToString()
    Write-Output "$(Get-Date) Programm wurde mit Adminrechten gestartet" >> $MyDir\Log\Latest.log
}
#>


function Load-ComboBox-VMs{ #VM Auswahl
            Write-Output "" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) [Lade VMs]" >> $MyDir\Log\Latest.log
            $ComboBox1.Items.Clear()
            Write-Output "$(Get-Date) Lösche VMs aus der Liste" >> $MyDir\Log\Latest.log
    $MgrArray = Get-VM -ComputerName $Hostname |
    Select-Object Name
            Write-Output "$(Get-Date) Lade alle Virtuellen Maschinen $($MgrArray)" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) Fülle ComboBox1 mit VMNamen" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) _" >> $MyDir\Log\Latest.log
    ForEach ($item in $MgrArray) {
        $ComboBox1.Items.Add($item.Name)
        Write-Output "$(Get-Date) |$($item.Name)" >> $MyDir\Log\Latest.log}
    Write-Output "$(Get-Date) Fertig" >> $MyDir\Log\Latest.log
    }

function Load-ComboBox-Hosts{
            Write-Output "" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) [Lade Hosts]" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) Lade Server mit dem Betriebsystem Windows Server in der Active Diretory" >> $MyDir\Log\Latest.log
    $ComboBox4.Items.Clear()
            Write-Output "$(Get-Date) Lösche Host Liste" >> $MyDir\Log\Latest.log
    $ComboBox4.Items.Add("localhost")
            Write-Output "$(Get-Date) Füge localhost zur Hostliste hinzu" >> $MyDir\Log\Latest.log
    $HostArray = Get-ADComputer -Filter "OperatingSystem -like '*Server*'" | Select-Object Name
            Write-Output "$(Get-Date) Lade alle Hyper-V Hosts $($HostArray)" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) _" >> $MyDir\Log\Latest.log
    foreach ($item in $HostArray){
        $ComboBox4.Items.Add($item.Name)
        Write-Output "$(Get-Date) |$($item.Name)" >> $MyDir\Log\Latest.log}
        Write-Output "$(Get-Date) Fertig" >> $MyDir\Log\Latest.log
}

$RichTextBox1.Text = "Bitte einen Host auswählen"
            Write-Output "$(Get-Date) Gebe aus: Bitte einen Host auswählen" >> $MyDir\Log\Latest.log


#Setzt die gewählte VM als VM und listet Infos auf
function Set-VM{
            Write-Output "" >> $MyDir\Log\Latest.log
            Write-Output "$(Get-Date) [Set-VM]" >> $MyDir\Log\Latest.log
    switch ($ComboBox1.Text){
        VM {[System.Windows.Forms.MessageBox]::Show("Bitte eine VM auswählen","MinersWin HyperV Manager",1)
            Write-Output "$(Get-Date) Keine VM Ausgewählt" >> $MyDir\Log\Latest.log}
        default {
            $VMName = $ComboBox1.Text
            $Hostname = $ComboBox4.Text
            rm $env:APPDATA\..\Local\Temp\$($VMName).jpg
                    Write-Output "$(Get-Date) Setze Host auf $($Hostname) und VM auf $($VMName)" >> $MyDir\Log\Latest.log
            $VMInfo = Get-VM -ComputerName $Hostname -Name $VMName | select VMName, State, CPUUsage, MemoryAssigned, Uptime, MemoryStartup, ProcessorCount | Format-Table | Out-String
                    Write-Output "$(Get-Date) Gib VMInfo aus `n $($VMInfo)" >> $MyDir\Log\Latest.log
            $RichTextBox1.Text = $VMInfo
            Write-host $VMName
                    Write-Output "$(Get-Date) Fertig" >> $MyDir\Log\Latest.log
            
        }
        
    }
    $ComboBox1.Enabled = $false
    $Panel10.Enabled = $true
    $Panel11.Enabled = $true
    $Panel7.Enabled = $true
    $Panel3.Enabled = $true
    $Panel4.Enabled = $true
    $Panel5.Enabled = $true
    $Button24.Enabled = $true
    $Button26.Enabled = $true
    $Panel17.Enabled = $true
    $Panel16.Enabled = $true
        Write-Output "$(Get-Date) Fertig" >> $MyDir\Log\Latest.log
    Get-Online
    Fill-Edit
    Get-Thumbnail
}

function Set-Host{
    Write-Output "" >> $MyDir\Log\Latest.log
    Write-Output "$(Get-Date) [Set-Host]" >> $MyDir\Log\Latest.log
    switch ($ComboBox4.Text){
        Host {[System.Windows.Forms.MessageBox]::Show("Bitte einen Host auswählen","MinersWin HyperV Manager",1)}
        localhost {$Hostname = "localhost"
                $VMs = Get-VM -ComputerName $Hostname -Name * | select VMName | Out-String
                $RichTextBox1.Text = $VMs
                Write-Host $Hostname
                Write-Host $VMs
                $LabelOverview.text = $Hostname.ToString()}
                
        default {
            $Hostname = $ComboBox4.Text
            $VMs = Get-VM -ComputerName $Hostname -Name * | select VMName | Out-String
            $RichTextBox1.Text = $VMs
            Write-Host $Hostname
            Write-Host $VMs
            $LabelOverview.text = $Hostname.ToString()
            
        }
    }
    $TextBox5.Text = "C:\Program Files\Hyper-V\"
    $ComboBox1.Enabled = $true
    $ComboBox4.Enabled = $false
    $Panel9.Enabled = $true
    $Panel1.Enabled = $true
    $Panel8.Enabled = $true
    $Button24.Enabled = $false
    $Button26.Enabled = $false
    $Panel17.Enabled = $false
    $Panel16.Enabled = $false
    Get-Switch
    Load-ComboBox-VMs
        "Bitte eine VM auswählen"
}
#Snapshots erstellen
function Show-Snapshot{
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    $AlleSnapshots = Get-VMSnapshot -ComputerName $Hostname $VMName | Format-table VMName, Name, SnapshotType, CreationTime, ParentSnapshotName -AutoSize | Out-String
    $RichTextBox1.text = $AlleSnapshots
}

function Create-Snapshot{
    $snapshotName = $TextBox6.text
    if ($snapshotName -eq "Name des Snapshots"){
        [System.Windows.Forms.MessageBox]::Show("Bitte einen Snapshotnamen eingeben","MinersWin HyperV Manager",1)
        Show-Snapshot
        $balloon.BalloonTipText  = "Bitte Snapshotnamen eingeben"
        $balloon.Visible  = $true 
        $balloon.ShowBalloonTip(20)
    } else {
        $VMName = $ComboBox1.Text
        $Hostname = $ComboBox4.Text
        Get-VM -ComputerName $Hostname -Name $VMName | Checkpoint-VM -SnapshotName $snapshotName -asJob
        Show-Snapshot
        $balloon.BalloonTipText  = "Snapshot der VM $($VMName) auf dem Host $($Hostname) wurde erstellt!"
        $balloon.Visible  = $true 
        $balloon.ShowBalloonTip(20)
    }

}

#Start
function VM-Start{
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    Write-Host "VMNAME"
    Write-Host $VMName
    Write-Host "Hostname"
    Write-Host $Hostname
    Get-VM $VMName -ComputerName $Hostname | Start-VM
    $balloon.BalloonTipText  = "Die VM $($VMName) auf dem Host $($Hostname) wurde gestartet!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
    Set-VM
}

function VM-Stop{
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    $Result = [System.Windows.Forms.MessageBox]::Show("Achtung $([System.Environment]::NewLine)Sie sind im Begriff die VM Herunterzufahren.$([System.Environment]::NewLine)" +
    "Soll die VM durch das Gatbetriebsystem heruntergefahren werden?","MinersWin HyperV Manager",3,[System.Windows.Forms.MessageBoxIcon]::Exclamation)

    If($Result -eq "Yes"){
        Stop-VM -ComputerName $Hostname -Name $VMName -Force
    } elseif ($Result -eq "No"){
        Stop-VM -ComputerName $Hostname -Name $VMName -TurnOff
    } else {
        
    }
    $balloon.BalloonTipText  = "Die VM $($VMName) auf dem Host $($Hostname) wurde gestoppt!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
    Set-VM

}


$ComboBox3
function ISOS{
    $ComboBox3.Items.Add("ISO Liste")
    $ComboBox3.SelectedItem = "ISO Liste"
    $ISOS = @("Windows 10 Pro", "Windows 8.1", "Windows 8", "Windows 7 Pro", "Windows Server 2012 R2", "HyperV-Core 2016", "Rasbian", "Debian 9.4.0", "Ubuntu 18.04.1.0 Live Server", "ProxMox", "ReactOS", "VMWare VMvisor", "XenServer")
    $ComboBox3.Items.AddRange($ISOS)
}


function Set-ISO{
    $ISOgewählt = $ComboBox3.SelectedItem
    $eigeneiso = $TextBox8.Text.ToString()
    if ($ISOgewählt -eq "ISO Liste" -and $eigeneiso -eq ""){
        [System.Windows.Forms.MessageBox]::Show("Bitte eine ISO auswählen","MinersWin HyperV Manager",1)
    } elseif ($ISOgewählt -ne "ISO Liste" -and $eigeneiso -ne ""){
        $isopfad = $eigeneiso
    } elseif ($ISOgewählt -ne "ISO Liste"){
        switch ($ISOgewählt){
            "Windows 10 Pro" {$isopfad = "\\its-hyperv\E\Windows 10.iso"}
            "Windows 8.1" {$isopfad = "\\its-hyperv\E\Windows 8.1.iso"}
            "Windows 8" {$isopfad = "\\its-hyperv\E\Windows 8 Pro.iso"}
            "Windows 7 Pro" {$isopfad = "\\its-hyperv\E\Windows 7 Pro.iso"}
            "Windows Server 2012 R2" {$isopfad = "\\its-hyperv\E\Windows Server 2012 R2.iso"}
            "HyperV-Core 2016" {$isopfad = "\\its-hyperv\E\HyperV-Core 2016.ISO"}
            "Rasbian" {$isopfad = "\\its-hyperv\E\Rasbian.iso"}
            "Debian 9.4.0" {$isopfad = "\\its-hyperv\E\Debian.ISO"}
            "Ubuntu 18.04.1.0 Live Server" {$isopfad = "\\its-hyperv\E\Ubuntu 18.04.1.0 Live Server.ISO"}
            "ProxMox" {$isopfad = "\\its-hyperv\E\ProxMox.ISO"}
            "ReactOS" {$isopfad = "\\its-hyperv\E\ReactOS.ISO"}
            "VMWare VMvisor" {$isopfad = "\\its-hyperv\E\VMWare VMvisor.ISO"}
            "XenServer" {$isopfad = "\\its-hyperv\E\XenServer.ISO"}
            default {[System.Windows.Forms.MessageBox]::Show("Ein Problem ist aufgetreten! Bitte per Mail an hypervmanager@minerswin.de wenden.","Fehler - MinersWin HyperV Manager",1)}
        }
    } elseif ($eigeneiso -ne ""){
        $isopfad = $eigeneiso
    } else {
        [System.Windows.Forms.MessageBox]::Show("Ein Problem ist aufgetreten! Bitte per Mail an hypervmanager@minerswin.de wenden.","Fehler - MinersWin HyperV Manager",1)
    }
    Write-host $isopfad
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    Set-VMDvdDrive -ComputerName $Hostname -VMName $VMName -Path $isopfad
    $balloon.BalloonTipText  = "Die ISO $($isopfad) wurde in die VM $($VMName) auf dem Host $($Hostname) eingebunden!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
     

}


function Get-BootISOFileName
{
   $TextBox8.Text = Get-FileName -initialDirectory $TextBox8.Text
}

function Get-BootISOFileName_2
{
   $TextBox4.Text = Get-FileName -initialDirectory $TextBox4.Text
}

Function Get-FileName($initialDirectory)
{   
    $Hostname = $ComboBox4.Text
  [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
  Out-Null

  $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $OpenFileDialog.initialDirectory = "\\"+$Hostname+"\c$"
  $OpenFileDialog.filter = "ISO (*.ISO)| *.ISO"
  $OpenFileDialog.ShowDialog() | Out-Null
  $OpenFileDialog.filename
} 


function Iso-Clear{
    $TextBox8.Text = ""
    $ComboBox3.SelectedItem = "ISO Liste"
}

function Get-Online{
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    $Running = Get-VM -ComputerName $Hostname -Name $VMName
    if ($Running.State -eq "Running"){
        $Label12.Text = "Online"
        $Button8.Enabled = $false
        $Button9.Enabled = $true
        $Label12.ForeColor = "Green"
        $balloon.BalloonTipText  = "Die VM $($VMName) auf dem Host $($Hostname) ist Eingeschaltet"
        $balloon.Visible  = $true 
        $balloon.ShowBalloonTip(20)
    } else {
        $Label12.Text = "Offline"
        $Label12.ForeColor = "Red"
        $Button9.Enabled = $false
        $Button8.Enabled = $true
        $PictureBox1.Enabled = $false
        $balloon.BalloonTipText  = "Die VM $($VMName) auf dem Host $($Hostname) ist Offline!"
        $balloon.Visible  = $true 
        $balloon.ShowBalloonTip(20)
    }
}

function Get-Switch{
    $ComboBox6.Items.Clear()
    $ComboBox2.Items.Clear()
    $SwitchArray = Get-VMSwitch -ComputerName $Hostname -SwitchType External | Select Name
    ForEach ($item in $SwitchArray) {
        $ComboBox6.Items.Add($item.Name)
        $ComboBox2.Items.Add($item.Name)}
    }

function Fill-Edit{
    Write-Output "[Fill-Edit]" >> $MyDir\Log\Latest.log
        $Datum = Get-Date
        Write-Output "$Datum Fülle Textfelder aus" >> $MyDir\Log\Latest.log
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
    $CPU = Get-VM -ComputerName $Hostname -Name $VMName | Select ProcessorCount
    $CPU = $CPU.ProcessorCount
    Write-Host $CPU
    $RAM = Get-VM -ComputerName $Hostname -Name $VMName | Select MemoryStartup
    $Memory = $RAM.MemoryStartup
    $Memory = $Memory/1073741824
    Write-Host $RAM
    Write-Host $Memory
    $VSwitch = Get-VMNetworkAdapter -ComputerName $Hostname $VMName | Select SwitchName
    $FirstBootDevice = 
    Write-Host $VSwitch.SwitchName
    $ComboBox6.SelectedItem = $VSwitch.SwitchName

    $TextBox10.Clear()
    $TextBox10.Text = $CPU
    $TextBox11.Clear()
    $TextBox11.Text = $Memory
    $TextBox12.Text = $VMName
        $Datum = Get-Date
        Write-Output "$Datum Lösche Textfelder und überprüfe Werte" >> $MyDir\Log\Latest.log

    $Generation = Get-VM -ComputerName $Hostname $VMName | Select Generation
    if ($Generation.Generation -eq "2"){
        $Label31.Visible = $true
        $Label32.Visible = $true
        $CheckBox2.Visible = $true
        $CheckBox3.Visible = $true
        $CheckBox4.Visible = $true
        $CheckBox5.Visible = $true
            $Datum = Get-Date
            Write-Output "$Datum Erzeuge SecureBoot Feld + Auswahl des Bootmediums, da es sich um eine Gen2 VM handelt" >> $MyDir\Log\Latest.log
        $Firmware = Get-VMFirmware -ComputerName $Hostname $VMName | Select SecureBoot, BootOrder
        if ($Firmware.SecureBoot -eq "On"){
            $CheckBox2.Checked = $true
        } else {
            $checkBox2.Checked = $false
        }
        
    } else {
                $Datum = Get-Date
                Write-Output "$Datum Verstecke SecureBoot Feld + Auswahl des Bootmediums, da es sich um eine Gen1 VM handelt" >> $MyDir\Log\Latest.log
        $Label31.Visible = $false
        $Label32.Visible = $false
        $CheckBox2.Visible = $false
        $CheckBox3.Visible = $false
        $CheckBox4.Visible = $false
        $CheckBox5.Visible = $false

    }

    Write-Host $Generarion
    Write-Host $Firmware.BootOrder
            $Datum = Get-Date
            Write-Output "$Datum Fertig" >> $MyDir\Log\Latest.log
}

function Set-Edit {
    #Speichern der Variablen in den Variablen
    $Hostname = $ComboBox4.Text
    $VMName = $ComboBox1.Text

    $CPUCount = $TextBox10.Text
    $Memory = $TextBox11.Text
    $RAM = $Memory*1073741824
    $VirtuellerSwitch = $ComboBox6.Text
    $NeuerNameDerVM = $TextBox12.Text

    #Setzen der neuen Einstellungen     

    #CPU Count setzen
    Set-VMProcessor -ComputerName $Hostname $VMName -Count $CPUCount

    #Memory setzen
    Set-VMMemory -ComputerName $Hostname $VMName -StartupBytes $RAM

    #Virtuellen Switch setzen
    Set-VMSwitch -ComputerName $Hostname $VMName -NetAdapterName $VirtuellerSwitch
    
    #VMNamen setzen
    Rename-VM -ComputerName $Hostname $VMName $NeuerNameDerVM

    ##VM Bearbeiten
    ##FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME
    ##VM Bearbeiten
    #Kai ist kuhl denn er geht zu scool
    



    $balloon.BalloonTipText  = "Die VM $($VMName) auf dem Host $($Hostname) wurde Bearbeitet!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function Get-Thumbnail{
    
            $Datum = Get-Date
            Write-Output "[Get-Thumbnail]" >> $MyDir\Log\Latest.log
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    $VMManagementService = $Null
    $VM = $Null
    $VMSettingData = $Null
    $RawImageData = $Null
    $VMThumbnail = $Null
    $rectangle = $Null    

    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text

    $HyperVParent = $Hostname
    $HyperVGuest = $VMName
    $ImagePath = "$($MyDir)\Thumbnails\"
    $PictureBox1.Image = $Null
    Remove-Item "$ImagePath\$HyperVGuest.jpg" -Force
    $xRes = 640
    $yRes = 480
            $Datum = Get-Date
            Write-Output "$Datum Erzeuge ein Screenshot der gewählten VM und speicher ihn ab" >> $MyDir\Log\Latest.log

    $VMManagementService = Get-WmiObject -class "Msvm_VirtualSystemManagementService" -namespace "root\virtualization\V2" -ComputerName $HyperVParent
    $Vm = Get-WmiObject -Namespace "root\virtualization\V2" -ComputerName $HyperVParent -Query "Select * From Msvm_ComputerSystem Where ElementName='$HyperVGuest'"
    $VMSettingData = Get-WmiObject -Namespace "root\virtualization\V2" -Query "Associators of {$Vm} Where ResultClass=Msvm_VirtualSystemSettingData AssocClass=Msvm_SettingsDefineState" -ComputerName $HyperVParent
    $RawImageData = $VMManagementService.GetVirtualSystemThumbnailImage($VMSettingData, "$xRes", "$yRes") #| ProcessWMIJob $VMManagementService.PSBase.ClassPath "GetVirtualSystemThumbnailImage"
    
    $VMThumbnail = new-object System.Drawing.Bitmap($xRes, $yRes, [System.Drawing.Imaging.PixelFormat]::Format16bppRgb565)
    
    $rectangle = new-object System.Drawing.Rectangle(0,0,$xRes,$yRes)
    [System.Drawing.Imaging.BitmapData] $VMThumbnailBitmapData = $VMThumbnail.LockBits($rectangle, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, [System.Drawing.Imaging.PixelFormat]::Format16bppRgb565)
    [System.Runtime.InteropServices.marshal]::Copy($RawImageData.ImageData, 0, $VMThumbnailBitmapData.Scan0, $xRes*$yRes*2)
    $VMThumbnail.UnlockBits($VMThumbnailBitmapData);
    
            $Datum = Get-Date
            Write-Output "$Datum Setze den Screenshot als Bild in PictureBox1" >> $MyDir\Log\Latest.log
    $VMThumbnail
    $VMThumbnail.Save("$ImagePath\$HyperVGuest.jpg")  
    $file = (get-item "$ImagePath\$HyperVGuest.jpg")
    $img = [System.Drawing.Image]::Fromfile($file);
    $pictureBox1.Image = $img;
    $Label38.Text = "$ImagePath\$HyperVGuest.jpg"
        $Datum = Get-Date
        Write-Output "$Datum Setze Dateipfad als Label" >> $MyDir\Log\Latest.log
        $Datum = Get-Date
        Write-Output "$Datum Fertig" >> $MyDir\Log\Latest.log

}

function Connect-VM{
            Write-Output "[Connect-VM]" >> $MyDir\Log\Latest.log
    $VMName = $ComboBox1.Text
    $Hostname = $ComboBox4.Text
            $Datum = Get-Date
            Write-Output "$Datum Stelle Verbindung mit VM her und öffne VMConnect.exe" >> $MyDir\Log\Latest.log
    vmconnect.exe $Hostname $VMName /edit
            $Datum = Get-Date
            Write-Output "$Datum Fertig" >> $MyDir\Log\Latest.log
            $balloon.BalloonTipText  = "Du wurdest mit der VM $($VMName) auf dem Host $($Hostname) verbunden!"
            $balloon.Visible  = $true 
            $balloon.ShowBalloonTip(20)
}

function Open-Manager{
        Write-Output "[Open-Manager]" >> $MyDir\Log\Latest.log
            $Datum = Get-Date
            Write-Output "$Datum Öffne den Hyper-V Manager" >> $MyDir\Log\Latest.log
    virtmgmt.msc
            $Datum = Get-Date
            Write-Output "$Datum Fertig" >> $MyDir\Log\Latest.log
            $balloon.BalloonTipText  = "Der Hyper-V Manager wurde geöffnet!"
            $balloon.Visible  = $true 
            $balloon.ShowBalloonTip(20)
}

function Save-File([string] $initialDirectory ){
    [System.Windows.Forms.MessageBox]::Show("Bitte als Dateiname den Dateinamen mitsamt Dateiendung angeben (Bsp: Log.log oder Log.txt)", "Hyper-V Manager V.2",1)
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Text (*.txt)|*.txt|Log (*.log)|*.log)|All files (*.*)| *.*"
    $OpenFileDialog.ShowDialog() |  Out-Null
    return $OpenFileDialog.filename
} 

function Save-Log{
    $File=Save-File
    cp $MyDir\Log\Latest.log $File
    $balloon.BalloonTipText  = "Der Log wurde gespeichert!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function Send-Information{
    $MailFrom = $ConfigSMTPUsername
    $MailTo = $ConfigMailSendTo
    $Username = $ConfigSMTPUsername
    $Password = $ConfigSMTPPassword
    $SmtpServer = $ConfigSMTPServer
    $SmtpPort = $ConfigSMTPPort
    $MessageSubject = "Hyper-V Manager Report von $($env:CLIENTNAME)"
    $Message = New-Object System.Net.Mail.MailMessage $MailFrom,$MailTo
    $Message.Subject = $MessageSubject

    $datei = Get-content $MyDir\Log\Latest.log | Out-String

    $Message.Body = "$($datei)"
    $Smtp = New-Object Net.Mail.SmtpClient($SmtpServer,$SmtpPort)
    $Smtp.EnableSsl = $true
    $Smtp.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
    $Smtp.Send($Message)
    $balloon.BalloonTipText  = "Der Log wurde versand!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function Reload-Hosts{
    $Panel10.Enabled = $false
    $Panel11.Enabled = $false
    $Panel7.Enabled = $false
    $Panel3.Enabled = $false
    $Panel4.Enabled = $false
    $Panel5.Enabled = $false
    $Panel9.Enabled = $false
    $Panel1.Enabled = $false
    $Panel8.Enabled = $false
    $RichTextBox1.Clear()
    $TextBox10.Clear()
    $TextBox11.Clear()
    $TextBox12.Clear()
    $CheckBox2.Checked = $false
    $CheckBox3.Checked = $false
    $CheckBox4.Checked = $false
    $CheckBox5.Checked = $false
    $PictureBox1.Clear
    $Label38.text = ""
    $Button24.Enabled = $false
    $Button26.Enabled = $false
    $ComboBox4.Enabled = $true
    $TextBox13.Text = "$($env:UserDomain)\$($env:UserName)"
    $RadioButton1.Checked = $true
    Load-ComboBox-Hosts
    ISO
    $balloon.BalloonTipText  = "Reload!!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function Go-Donate{
    Start "https://paypal.me/minerswin"
    Start "https://patreon.com/minerswin"
}

function Erstelle-VM{
    $Hostname = $ComboBox4.Text
    $Name_Der_VM = $TextBox1.Text
    $Ram_in_GB = $TextBox2.Text
    $Prozessorkerne = $TextBox3.Text
    $ISO_der_VM = $TextBox4.Text
    $VM_Root_Path = $TextBox5.Text
    $VHDGB = $TextBox7.Text
    $Switchname = $ComboBox2.SelectedItem

    if ($RadioButton1.Checked -eq $True) {$VMGeneration = 1}
    if ($RadioButton2.Checked -eq $True) {$VMGeneration = 2}

    try    {
        New-VM -ComputerName $Hostname -Name $Name_Der_VM -MemoryStartupBytes ([int]$Ram_in_GB*1073741824) -SwitchName $Switchname -Generation $VMGeneration -ErrorAction Stop
    } catch {
        write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
        [System.Windows.MessageBox]::Show($_.Exception.Message)
        $VMCrateFailed=$True
        $LastResultLabel.text = "VM " + $VMNameTextBox.Text + " Failed to Create :("
    }
    Get-VM -ComputerName $Hostname $Name_Der_VM | Set-VMProcessor -Count $Prozessorkerne

    #Setze Neue Boot Reinfolge
    if ($VMGeneration -eq "2")
    {
        $old_boot_order = Get-VMFirmware -ComputerName $Hostname -VMName $Name_Der_VM | Select-Object -ExpandProperty BootOrder
        $new_boot_order = $old_boot_order | Where-Object { $_.BootType -ne "Network" }
        Set-VMFirmware -VMName $Name_Der_VM -ComputerName $HostName -BootOrder $new_boot_order
    }


    #  Füge DVD Drive hinzu und binde es ein
    if ($ISO_der_VM -ne "") {Get-VM -ComputerName $Hostname $Name_Der_VM | Add-VMDvdDrive -Path $ISO_der_VM}

    $CDriveVHDPath=$VM_Root_Path+"\"+$Name_Der_VM+"\"+$Name_Der_VM+"-C.vhdx"
    New-VHD -ComputerName $Hostname -Path $CDriveVHDPath -SizeBytes (Invoke-Expression ($VHDGB+"GB")) -Dynamic
    Add-VMHardDiskDrive -ComputerName $Hostname -VMName $Name_Der_VM -Path $CDriveVHDPath -ControllerType SCSI -ControllerNumber 0












    $balloon.BalloonTipText  = "Die VM $($Name_Der_VM) auf dem Host $($Hostname) wurde Erstellt!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function About{
    Start "https://mobatilo.de"
}

function Grant-Permission{
    $Hostname = $ComboBox4.Text
    $VMName = $ComboBox1.Text

    $Nutzer = $TextBox13.Text
    $TextBox13.Clear()
    Grant-VMConnectAccess -ComputerName $Hostname -VMName $VMName -UserName $Nutzer
    $balloon.BalloonTipText  = "Der Nutzer $($Nutzer) hat auf die VM $($VMName) auf dem Host $($Hostname) Rechte bekommen!"
    $balloon.Visible  = $true 
    $balloon.ShowBalloonTip(20)
}

function Einstellungen{
    $TextBox28.Text = $ConfigPathThumbnailPath
    $TextBox29.Text = $configPathLogPath
    $TextBox22.Text = $ConfigUpdateScript
    $TextBox30.Text = $ConfigDirectoryName

    if ($ConfigCheckForUpdates){$CheckBox16.Checked = $true}else{$CheckBox16.Checked = $false}
    if ($ConfigUpdateWarn){$CheckBox17.Checked = $true}else{$CheckBox17.Checked = $false}
    if ($ConfigUpdateDownload){$CheckBox18.Checked = $true}else{$CheckBox18.Checked = $false}
    if ($ConfigUpdateReplaceOldVersion){$CheckBox19.Checked = $true}else{$CheckBox19.Checked = $false}
    if ($ConfigUpdateSaveOldVersion){$CheckBox20.Checked = $true}else{$CheckBox20.Checked = $false}
    if ($ConfigUpdateNewLanguages){$CheckBox21.Checked = $true}else{$CheckBox21.Checked = $false}

    $TextBox23.Text = $ConfigMailSendTo
    $TextBox24.Text = $ConfigSMTPUsername
    $TextBox25.Text = $ConfigSMTPPassword
    $TextBox25.UseSystemPasswordChar = $true
    $TextBox26.Text = $ConfigSMTPServer
    $TextBox27.Text = $ConfigSMTPPort

    $TextBox19.Text = $ConfigName
    $TextBox20.Text = $ConfigVersion
    $TextBox21.Text = $ConfigBuild
    $TextBox31.Text = $ConfigLastUpdate
    $TextBox32.Text = $ConfigLastUpdateSearch
    $TextBox33.Text = $ConfigCompanyName
    $TextBox34.Text = $ConfigDescription
}

Einstellungen

$Button33.Add_Click{Update-German}
function Update-German{
    .\Script\UpdateGerman.ps1
    $global:ConfigLanguage = 'de-DE'
}

$Button34.Add_Click{Update-Eng}
function Update-Eng{
    .\Script\UpdateEnglisch.ps1
    $global:ConfigLanguage = 'en-EN'
}

$Button35.Add_Click{Save-Config}
function Save-config{
    $ConfigPathThumbnailPath = $TextBox28.Text
    $configPathLogPath = $TextBox29.Text
    $ConfigUpdateScript = $TextBox22.Text
    if ($CheckBox16.Checked){$ConfigCheckForUpdates = 'YES'}else{$ConfigCheckForUpdates = 'NO'}
    if ($CheckBox17.Checked){$ConfigUpdateWarn = 'YES'}else{$ConfigUpdateWarn = 'NO'}
    if ($CheckBox18.Checked){$ConfigUpdateDownload = 'YES'}else{$ConfigUpdateDownload = 'NO'}
    if ($CheckBox19.Checked){$ConfigUpdateReplaceOldVersion = 'Yes'}else{$ConfigUpdateReplaceOldVersion = 'NO'}
    if ($CheckBox20.Checked){$ConfigUpdateSaveOldVersion = 'YES'}else{$ConfigUpdateSaveOldVersion = 'NO'}
    if ($CheckBox21.Checked){$ConfigUpdateNewLanguages = 'YES'}else{$ConfigUpdateNewLanguages = 'NO'}

    $ConfigMailSendTo = $TextBox23.Text
    $ConfigSMTPUsername = $TextBox24.Text
    $ConfigSMTPPassword = $TextBox25.Text
    $ConfigSMTPServer = $TextBox26.Text
    $ConfigSMTPPort = $TextBox27.Text

    $ConfigName = $TextBox19.Text
    $ConfigVersion = $TextBox20.Text
    $ConfigBuild = $TextBox21.Text
    $ConfigLastUpdate = $TextBox31.Text
    $ConfigLastUpdateSearch = $TextBox32.Text
    $ConfigCompanyName = $TextBox33.Text
    $ConfigDescription = $TextBox34.Text

    rm .\config\Config.psd1
    @"
@{
    Name = '$($ConfigName)'
    Length = 4532304
    DirectoryName = '$MyDir\'

    VersionInfo = @{
      ProductVersion = '$($ConfigVersion)' 
      Build = '$($ConfigBuild)'
      LastUpdate = '$($ConfigLastUpdate)'
      LastUpdateSearch = '$(Get-Date)'
      Author = 'Moritz Mantel'
      CompanyName = '$($ConfigCompanyName)'
      Description = '$($ConfigDescription)'
    }
    Update = @{
      CheckForUpdates = '$($ConfigCheckForUpdates)'
      NewestVersion = 'https://pastebin.com/raw/zBUriG1D'
      Warn = '$($ConfigUpdateWarn)'
      AutoDownload = '$($ConfigUpdateDownload)'
      UpdateScript = '$($ConfigUpdateScript)'
      ReplaceOldVersion = '$($ConfigUpdateReplaceOldVersion)'
      SaveOldVersion = '$($ConfigUpdateSaveOldVersion)'
      DownloadNewLanguages = '$($ConfigUpdateNewLanguages)'
    }
    Language = @{
      #Avaiable Languages: de-DE en-EN
      Language = '$($ConfigLanguage)'
    }
    Websites = @{
      Donate1 = 'https://www.paypal.me/minerswin'
      Donate2 = 'https://www.patreon.com/minerswin'
      AboutSite = 'https://www.Hyper-V-Manager.de/About/'
    }
    Mail = @{
      SendFeedbackTo = '$($ConfigMailSendTo)'
      
      #SMTP Server
      Username = '$($ConfigSMTPUsername)'
      Password = '$($ConfigSMTPPassword)'
      SmtpServer = '$($ConfigSMTPServer)'
      SmtpPort = '$($ConfigSMTPPort)'
    }
    Path = @{
      SaveInTemp = 'YES'
      ThumbnailPath = '$($ConfigPathThumbnailPath)'
      LogPath = '$($configPathLogPath)'
    }
}
"@ | Out-File -FilePath $MyDir\Config\Config.psd1
}























function Send-Feedback{

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $FormMail                        = New-Object system.Windows.Forms.Form
    $FormMail.ClientSize             = '400,400'
    $FormMail.text                   = "Feedback Senden"
    $FormMail.TopMost                = $false

    $TextBoxSender                   = New-Object system.Windows.Forms.TextBox
    $TextBoxSender.multiline         = $false
    $TextBoxSender.width             = 294
    $TextBoxSender.height            = 20
    $TextBoxSender.location          = New-Object System.Drawing.Point(61,77)
    $TextBoxSender.Font              = 'Microsoft Sans Serif,10'

    $LabelSender                     = New-Object system.Windows.Forms.Label
    $LabelSender.text                = "Mail:"
    $LabelSender.AutoSize            = $true
    $LabelSender.width               = 25
    $LabelSender.height              = 10
    $LabelSender.location            = New-Object System.Drawing.Point(21,80)
    $LabelSender.Font                = 'Comic Sans MS,10'

    $LabelTitle                      = New-Object system.Windows.Forms.Label
    $LabelTitle.text                 = "Hier kannst du dein Feedback und Verbesserungsvorschläge"
    $LabelTitle.AutoSize             = $true
    $LabelTitle.width                = 25
    $LabelTitle.height               = 10
    $LabelTitle.location             = New-Object System.Drawing.Point(19,31)
    $LabelTitle.Font                 = 'Microsoft Sans Serif,10'

    $LabelTitle2                     = New-Object system.Windows.Forms.Label
    $LabelTitle2.text                = "Absenden."
    $LabelTitle2.AutoSize            = $true
    $LabelTitle2.width               = 25
    $LabelTitle2.height              = 10
    $LabelTitle2.location            = New-Object System.Drawing.Point(20,51)
    $LabelTitle2.Font                = 'Microsoft Sans Serif,10'

    $LabelBetreff                    = New-Object system.Windows.Forms.Label
    $LabelBetreff.text               = "Betreff:"
    $LabelBetreff.AutoSize           = $true
    $LabelBetreff.width              = 25
    $LabelBetreff.height             = 10
    $LabelBetreff.location           = New-Object System.Drawing.Point(19,108)
    $LabelBetreff.Font               = 'Comic Sans MS,10'

    $TextBoxBetreff                  = New-Object system.Windows.Forms.TextBox
    $TextBoxBetreff.multiline        = $false
    $TextBoxBetreff.width            = 275
    $TextBoxBetreff.height           = 20
    $TextBoxBetreff.location         = New-Object System.Drawing.Point(80,104)
    $TextBoxBetreff.Font             = 'Microsoft Sans Serif,10'

    $LabelText                       = New-Object system.Windows.Forms.Label
    $LabelText.text                  = "Text:"
    $LabelText.AutoSize              = $true
    $LabelText.width                 = 25
    $LabelText.height                = 10
    $LabelText.location              = New-Object System.Drawing.Point(18,134)
    $LabelText.Font                  = 'Comic Sans MS,10'

    $TextBoxText                     = New-Object system.Windows.Forms.TextBox
    $TextBoxText.multiline           = $true
    $TextBoxText.width               = 381
    $TextBoxText.height              = 210
    $TextBoxText.location            = New-Object System.Drawing.Point(5,148)
    $TextBoxText.Font                = 'Microsoft Sans Serif,10'
    $TextBoxText.ForeColor           = "#4a90e2"

    $ButtonSend                      = New-Object system.Windows.Forms.Button
    $ButtonSend.text                 = "Senden"
    $ButtonSend.width                = 60
    $ButtonSend.height               = 30
    $ButtonSend.location             = New-Object System.Drawing.Point(326,366)
    $ButtonSend.Font                 = 'Microsoft Sans Serif,10'

    $ButtonCancel                    = New-Object system.Windows.Forms.Button
    $ButtonCancel.text               = "Abbrechen"
    $ButtonCancel.width              = 80
    $ButtonCancel.height             = 30
    $ButtonCancel.location           = New-Object System.Drawing.Point(236,366)
    $ButtonCancel.Font               = 'Microsoft Sans Serif,10'

    $FormMail.controls.AddRange(@($TextBoxSender,$LabelSender,$LabelTitle,$LabelTitle2,$LabelBetreff,$TextBoxBetreff,$LabelText,$TextBoxText,$ButtonSend,$ButtonCancel))
    $ButtonSend.Add_Click{( Feedback-Senden )}
    $ButtonCancel.Add_Click{( break )}

    function Feedback-Senden{
        $MailSender = $TextBoxSender.Text
        $MailBetreff = $TextBoxBetreff.Text
        $MailText = $TextBoxText.Text

        $MailFrom = $ConfigSMTPUsername
        $MailTo = $ConfigMailSendTo
        $Username = $ConfigSMTPUsername
        $Password = $ConfigSMTPPassword
        $SmtpServer = $ConfigSMTPServer
        $SmtpPort = $ConfigSMTPPort
        $MessageSubject = "Feedback von $($MailSender)"
        $Message = New-Object System.Net.Mail.MailMessage $MailFrom,$MailTo
        $Message.Subject = $MessageSubject
        $Message.Body = "Betreff: $($MailBetreff) `nText: $($MailText)"
        $Smtp = New-Object Net.Mail.SmtpClient($SmtpServer,$SmtpPort)
        $Smtp.EnableSsl = $true
        $Smtp.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
        $Smtp.Send($Message)
    }

    $FormMail.ShowDialog()
}

ISOS
Load-ComboBox-Hosts
$FormOverview.ShowDialog()