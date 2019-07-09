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
        B.E.T.A. 1.9.0 - MinersWin - 10.04.2019 - Nun mit GUI + Auswahl des Hosts + Auswahl der VM
        B.E.T.A. 1.9.1 - MinersWin - 11.04.2019 - Erstellung einer TextBox um dauerhaft den Aktuellen Status anzeigen zu lassen + Erstellung eigener VMs (Ohne Funktion)
        B.E.T.A. 1.9.2 - MinersWin - 12.04.2019 - Einbringung einiger Funktionen: Snapshots, ISOS, und Start/Stop
        B.E.T.A. 1.9.3 - MinersWin - 15.04.2019 - Möglichkeit der Erstellung Virtueller Switches, Bearbeiten der VMs, ERstellung von Startskripten, Installation der Verwaltungstools + Rechtevergabe
        B.E.T.A. 1.9.4 - MinersWin - 16.04.2019 - Automatische erkennung der VMs, übersichtlichere Formatierung, Einbindung der Thumbnailfunktion + ISO Wechsel + Feedback Form
        B.E.T.A. 1.9.5 - MinersWin - 17.04.2019 - Erstellung einer Config.txt, Automatisches Erstellen einer temporären log-Datei, Einbau der Funktion, die Log + Computerinfos bei Problemen an den Entwickler zu senden
        B.E.T.A. 1.9.6 - MinersWin - 18.04.2019 - Möglichkeit zur Speicherung der Log Datei, Automatisch überprüfung der Version
        B.E.T.A. 1.9.7 - MinersWin - 29.04.2019 - Möglichkeit der Erstellung von VMs, einfügen einer Feedback Funktion
        B.E.T.A. 1.9.8 - MinersWin - 30.04.2019 - Möglichkeit des An/Ausschaltens von VMs + Möglichkeit zur Festlegung von Prozessorkernen, RAM und ISO Datei bei der Erstellung
        B.E.T.A. 1.9.9 - MinersWin - 20.05.2019 - Möglichkeit zur erstellung von Virtuellen Switches und verbesserung der LOG Datei
        B.E.T.A. 1.9.10 - MinersWin - 21.05.2019 - Fertigstellung der VM Edit Funktion + Autosenden des Feedbacks an den Creator.
        B.E.T.A. 1.9.11 - MinersWin - 02.07.2019 - Entfernen des MailServers + Configupdate
        B.E.T.A. 1.9.12 - MinersWin - 04.07.2019 - Integration von BallonTips

    .BEISPIEL
        .\HyperV-Manager.ps1 
    .IN_ZUKUNFT_GEPLANT
      - Automatische Erstellung von Connect-Skripts
      - Automatische Rechtezuweisung für die Einzelen Personen
      - Wenn Template Vorhanden soll das Benutzt werden (spart Installation)
      - Erstellung eines Clients für die Azubis, mit welchem sie VMs beantragen können.
      - Automatische Installation der Verwaltungsdienste auf den Azubi-Computern
      - Möglichkeit RAM,CPU,NETZWERK,FESTPLATTENGRÖSSE usw. zu ändern
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
$ConfigUpdateScript = $Config.Update.UpdateScript -eq "YES"
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
    Add-Type -AssemblyName System.Windows.Forms
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
$FormOverview = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Button]$Button23 = $null
[System.Windows.Forms.Label]$Label28 = $null
[System.Windows.Forms.Label]$Label29 = $null
[System.Windows.Forms.Label]$Label26 = $null
[System.Windows.Forms.Button]$Button7 = $null
[System.Windows.Forms.Label]$Label24 = $null
[System.Windows.Forms.Label]$Label25 = $null
[System.Windows.Forms.LinkLabel]$LinkLabel1 = $null
[System.Windows.Forms.Label]$Label23 = $null
[System.Windows.Forms.Label]$Label20 = $null
[System.Windows.Forms.Label]$Label21 = $null
[System.Windows.Forms.Button]$Button16 = $null
[System.Windows.Forms.Label]$Label8 = $null
[System.Windows.Forms.Label]$Label9 = $null
[System.Windows.Forms.Label]$Label4 = $null
[System.Windows.Forms.Label]$Label5 = $null
[System.Windows.Forms.Button]$Button3 = $null
[System.Windows.Forms.Label]$Label7 = $null
[System.Windows.Forms.Label]$Label2 = $null
[System.Windows.Forms.Button]$Button1 = $null
[System.Windows.Forms.Button]$Button2 = $null
[System.Windows.Forms.Label]$Label3 = $null
[System.Windows.Forms.Label]$Label19 = $null
[System.Windows.Forms.Label]$Label18 = $null
[System.Windows.Forms.FolderBrowserDialog]$FolderBrowserDialog1 = $null
[System.Windows.Forms.Label]$Label15 = $null
[System.Windows.Forms.Label]$Label14 = $null
[System.Windows.Forms.Label]$Label17 = $null
[System.Windows.Forms.Label]$Label16 = $null
[System.Windows.Forms.ToolStripMenuItem]$AboutToolStripMenuItem = $null
[System.Windows.Forms.Label]$Label10 = $null
[System.Windows.Forms.MenuStrip]$MenuStripOverview = $null
[System.Windows.Forms.ToolStripMenuItem]$DateiToolStripMenuItem2 = $null
[System.Windows.Forms.ToolStripMenuItem]$AktionToolStripMenuItem = $null
[System.Windows.Forms.ToolStripMenuItem]$MitAnderenHostVerbindenToolStripMenuItem = $null
[System.Windows.Forms.ToolStripMenuItem]$ExportToolStripMenuItem = $null
[System.Windows.Forms.ToolStripMenuItem]$DonateToolStripMenuItem = $null
[System.Windows.Forms.ToolStripMenuItem]$FeedbackToolStripMenuItem = $null
[System.Windows.Forms.Label]$Label12 = $null
[System.Windows.Forms.Label]$Label31 = $null
[System.Windows.Forms.ToolStripMenuItem]$BeendenToolStripMenuItem = $null
[System.Windows.Forms.RadioButton]$RadioButton1 = $null
[System.Windows.Forms.Label]$Label37 = $null
[System.Windows.Forms.RadioButton]$RadioButton2 = $null
[System.Windows.Forms.TextBox]$TextBox1 = $null
[System.Windows.Forms.ComboBox]$ComboBox5 = $null
[System.Windows.Forms.TextBox]$TextBox9 = $null
[System.Windows.Forms.Panel]$Panel10 = $null
[System.Windows.Forms.Button]$Button20 = $null
[System.Windows.Forms.TextBox]$TextBox13 = $null
[System.Windows.Forms.Label]$Label33 = $null
[System.Windows.Forms.Panel]$Panel8 = $null
[System.Windows.Forms.Button]$Button8 = $null
[System.Windows.Forms.Label]$Label22 = $null
[System.Windows.Forms.ToolStripMenuItem]$DateiToolStripMenuItem = $null
[System.Windows.Forms.ToolStripMenuItem]$MitAnderenServerVerbindenToolStripMenuItem = $null
[System.Windows.Forms.Button]$Button5 = $null
[System.Windows.Forms.Button]$Button10 = $null
[System.Windows.Forms.TextBox]$TextBox12 = $null
[System.Windows.Forms.ToolStripMenuItem]$DateiToolStripMenuItem1 = $null
[System.Windows.Forms.TextBox]$TextBox10 = $null
[System.Windows.Forms.TextBox]$TextBox15 = $null
[System.Windows.Forms.TextBox]$TextBox14 = $null
[System.Windows.Forms.Label]$Label38 = $null
[System.Windows.Forms.Button]$Button6 = $null
[System.Windows.Forms.Label]$Label36 = $null
[System.Windows.Forms.Label]$Label35 = $null
[System.Windows.Forms.Label]$Label34 = $null
[System.Windows.Forms.Button]$Button28 = $null
[System.Windows.Forms.Button]$Button29 = $null
[System.Windows.Forms.Button]$Button26 = $null
[System.Windows.Forms.Button]$Button27 = $null
[System.Windows.Forms.Button]$Button24 = $null
[System.Windows.Forms.Button]$Button25 = $null
[System.Windows.Forms.TextBox]$TextBox2 = $null
[System.Windows.Forms.TextBox]$TextBox3 = $null
[System.Windows.Forms.TextBox]$TextBox6 = $null
[System.Windows.Forms.TextBox]$TextBox7 = $null
[System.Windows.Forms.TextBox]$TextBox4 = $null
[System.Windows.Forms.TextBox]$TextBox5 = $null
[System.Windows.Forms.Label]$Label1 = $null
[System.ComponentModel.BackgroundWorker]$BackgroundWorker1 = $null
[System.Windows.Forms.TextBox]$TextBox8 = $null
[System.Windows.Forms.RichTextBox]$RichTextBox1 = $null
[System.Windows.Forms.ComboBox]$ComboBox2 = $null
[System.Windows.Forms.ComboBox]$ComboBox1 = $null
[System.Windows.Forms.ComboBox]$ComboBox7 = $null
[System.Windows.Forms.ComboBox]$ComboBox6 = $null
[System.Windows.Forms.Button]$Button22 = $null
[System.Windows.Forms.ComboBox]$ComboBox4 = $null
[System.Windows.Forms.Button]$Button19 = $null
[System.Windows.Forms.Button]$Button18 = $null
[System.Windows.Forms.Button]$Button4 = $null
[System.Windows.Forms.Button]$Button15 = $null
[System.Windows.Forms.Button]$Button14 = $null
[System.Windows.Forms.Button]$Button17 = $null
[System.Windows.Forms.Panel]$Panel11 = $null
[System.Windows.Forms.Button]$Button21 = $null
[System.Windows.Forms.Button]$Button11 = $null
[System.Windows.Forms.Panel]$Panel13 = $null
[System.Windows.Forms.PictureBox]$PictureBox1 = $null
[System.Windows.Forms.Panel]$Panel12 = $null
[System.Windows.Forms.Button]$Button12 = $null
[System.Windows.Forms.TextBox]$TextBox11 = $null
[System.Windows.Forms.Panel]$Panel9 = $null
[System.Windows.Forms.CheckBox]$CheckBox1 = $null
[System.Windows.Forms.OpenFileDialog]$OpenFileDialog1 = $null
[System.Windows.Forms.ComboBox]$ComboBox3 = $null
[System.Windows.Forms.Panel]$Panel4 = $null
[System.Windows.Forms.Button]$Button9 = $null
[System.Windows.Forms.Label]$Label11 = $null
[System.Windows.Forms.Panel]$Panel5 = $null
[System.Windows.Forms.Label]$Label13 = $null
[System.Windows.Forms.Panel]$Panel6 = $null
[System.Windows.Forms.Panel]$Panel7 = $null
[System.Windows.Forms.CheckBox]$CheckBox5 = $null
[System.Windows.Forms.CheckBox]$CheckBox4 = $null
[System.Windows.Forms.CheckBox]$CheckBox3 = $null
[System.Windows.Forms.Label]$Label32 = $null
[System.Windows.Forms.CheckBox]$CheckBox2 = $null
[System.Windows.Forms.Label]$Label30 = $null
[System.Windows.Forms.Label]$Label27 = $null
[System.Windows.Forms.Panel]$Panel1 = $null
[System.Windows.Forms.Panel]$Panel2 = $null
[System.Windows.Forms.Label]$Label6 = $null
[System.Windows.Forms.Panel]$Panel3 = $null
[System.Windows.Forms.Button]$Button13 = $null
[System.Windows.Forms.Label]$LabelOverview = $null
[System.Windows.Forms.ProgressBar]$ProgressBar1 = $null
function InitializeComponent
{
$Button23 = (New-Object -TypeName System.Windows.Forms.Button)
$Label28 = (New-Object -TypeName System.Windows.Forms.Label)
$Label29 = (New-Object -TypeName System.Windows.Forms.Label)
$Label26 = (New-Object -TypeName System.Windows.Forms.Label)
$Button7 = (New-Object -TypeName System.Windows.Forms.Button)
$Label24 = (New-Object -TypeName System.Windows.Forms.Label)
$Label25 = (New-Object -TypeName System.Windows.Forms.Label)
$LinkLabel1 = (New-Object -TypeName System.Windows.Forms.LinkLabel)
$Label23 = (New-Object -TypeName System.Windows.Forms.Label)
$Label20 = (New-Object -TypeName System.Windows.Forms.Label)
$Label21 = (New-Object -TypeName System.Windows.Forms.Label)
$Button16 = (New-Object -TypeName System.Windows.Forms.Button)
$Label8 = (New-Object -TypeName System.Windows.Forms.Label)
$Label9 = (New-Object -TypeName System.Windows.Forms.Label)
$Label4 = (New-Object -TypeName System.Windows.Forms.Label)
$Label5 = (New-Object -TypeName System.Windows.Forms.Label)
$Button3 = (New-Object -TypeName System.Windows.Forms.Button)
$Label7 = (New-Object -TypeName System.Windows.Forms.Label)
$Label2 = (New-Object -TypeName System.Windows.Forms.Label)
$Button1 = (New-Object -TypeName System.Windows.Forms.Button)
$Button2 = (New-Object -TypeName System.Windows.Forms.Button)
$Label3 = (New-Object -TypeName System.Windows.Forms.Label)
$Label19 = (New-Object -TypeName System.Windows.Forms.Label)
$Label18 = (New-Object -TypeName System.Windows.Forms.Label)
$FolderBrowserDialog1 = (New-Object -TypeName System.Windows.Forms.FolderBrowserDialog)
$Label15 = (New-Object -TypeName System.Windows.Forms.Label)
$Label14 = (New-Object -TypeName System.Windows.Forms.Label)
$Label17 = (New-Object -TypeName System.Windows.Forms.Label)
$Label16 = (New-Object -TypeName System.Windows.Forms.Label)
$AboutToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$Label10 = (New-Object -TypeName System.Windows.Forms.Label)
$MenuStripOverview = (New-Object -TypeName System.Windows.Forms.MenuStrip)
$Label12 = (New-Object -TypeName System.Windows.Forms.Label)
$Label31 = (New-Object -TypeName System.Windows.Forms.Label)
$BeendenToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$RadioButton1 = (New-Object -TypeName System.Windows.Forms.RadioButton)
$Label37 = (New-Object -TypeName System.Windows.Forms.Label)
$RadioButton2 = (New-Object -TypeName System.Windows.Forms.RadioButton)
$FeedbackToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$TextBox1 = (New-Object -TypeName System.Windows.Forms.TextBox)
$ComboBox5 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$TextBox9 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Panel10 = (New-Object -TypeName System.Windows.Forms.Panel)
$Label33 = (New-Object -TypeName System.Windows.Forms.Label)
$Panel8 = (New-Object -TypeName System.Windows.Forms.Panel)
$Button8 = (New-Object -TypeName System.Windows.Forms.Button)
$Label22 = (New-Object -TypeName System.Windows.Forms.Label)
$DateiToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$Button5 = (New-Object -TypeName System.Windows.Forms.Button)
$Button10 = (New-Object -TypeName System.Windows.Forms.Button)
$TextBox13 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox12 = (New-Object -TypeName System.Windows.Forms.TextBox)
$DateiToolStripMenuItem1 = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$TextBox10 = (New-Object -TypeName System.Windows.Forms.TextBox)
$DateiToolStripMenuItem2 = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$TextBox15 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox14 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Label38 = (New-Object -TypeName System.Windows.Forms.Label)
$Button6 = (New-Object -TypeName System.Windows.Forms.Button)
$Label36 = (New-Object -TypeName System.Windows.Forms.Label)
$Label35 = (New-Object -TypeName System.Windows.Forms.Label)
$Label34 = (New-Object -TypeName System.Windows.Forms.Label)
$Button28 = (New-Object -TypeName System.Windows.Forms.Button)
$Button29 = (New-Object -TypeName System.Windows.Forms.Button)
$Button26 = (New-Object -TypeName System.Windows.Forms.Button)
$Button27 = (New-Object -TypeName System.Windows.Forms.Button)
$Button24 = (New-Object -TypeName System.Windows.Forms.Button)
$Button25 = (New-Object -TypeName System.Windows.Forms.Button)
$TextBox2 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox3 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Button20 = (New-Object -TypeName System.Windows.Forms.Button)
$MitAnderenHostVerbindenToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$TextBox6 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox7 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox4 = (New-Object -TypeName System.Windows.Forms.TextBox)
$TextBox5 = (New-Object -TypeName System.Windows.Forms.TextBox)
$Label1 = (New-Object -TypeName System.Windows.Forms.Label)
$BackgroundWorker1 = (New-Object -TypeName System.ComponentModel.BackgroundWorker)
$TextBox8 = (New-Object -TypeName System.Windows.Forms.TextBox)
$RichTextBox1 = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$ComboBox2 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ComboBox1 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ComboBox7 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$ComboBox6 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$Button22 = (New-Object -TypeName System.Windows.Forms.Button)
$ComboBox4 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$Button19 = (New-Object -TypeName System.Windows.Forms.Button)
$Button18 = (New-Object -TypeName System.Windows.Forms.Button)
$Button4 = (New-Object -TypeName System.Windows.Forms.Button)
$Button15 = (New-Object -TypeName System.Windows.Forms.Button)
$Button14 = (New-Object -TypeName System.Windows.Forms.Button)
$Button17 = (New-Object -TypeName System.Windows.Forms.Button)
$Panel11 = (New-Object -TypeName System.Windows.Forms.Panel)
$Button11 = (New-Object -TypeName System.Windows.Forms.Button)
$Panel13 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel12 = (New-Object -TypeName System.Windows.Forms.Panel)
$Button12 = (New-Object -TypeName System.Windows.Forms.Button)
$TextBox11 = (New-Object -TypeName System.Windows.Forms.TextBox)
$DonateToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$Panel9 = (New-Object -TypeName System.Windows.Forms.Panel)
$OpenFileDialog1 = (New-Object -TypeName System.Windows.Forms.OpenFileDialog)
$ComboBox3 = (New-Object -TypeName System.Windows.Forms.ComboBox)
$Panel4 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel5 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel6 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel7 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel1 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel2 = (New-Object -TypeName System.Windows.Forms.Panel)
$Panel3 = (New-Object -TypeName System.Windows.Forms.Panel)
$Button21 = (New-Object -TypeName System.Windows.Forms.Button)
$Button13 = (New-Object -TypeName System.Windows.Forms.Button)
$Label27 = (New-Object -TypeName System.Windows.Forms.Label)
$CheckBox3 = (New-Object -TypeName System.Windows.Forms.CheckBox)
$LabelOverview = (New-Object -TypeName System.Windows.Forms.Label)
$ExportToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$Label32 = (New-Object -TypeName System.Windows.Forms.Label)
$Label11 = (New-Object -TypeName System.Windows.Forms.Label)
$MitAnderenServerVerbindenToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$Button9 = (New-Object -TypeName System.Windows.Forms.Button)
$Label30 = (New-Object -TypeName System.Windows.Forms.Label)
$ProgressBar1 = (New-Object -TypeName System.Windows.Forms.ProgressBar)
$CheckBox4 = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CheckBox1 = (New-Object -TypeName System.Windows.Forms.CheckBox)
$Label13 = (New-Object -TypeName System.Windows.Forms.Label)
$CheckBox2 = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CheckBox5 = (New-Object -TypeName System.Windows.Forms.CheckBox)
$Label6 = (New-Object -TypeName System.Windows.Forms.Label)
$AktionToolStripMenuItem = (New-Object -TypeName System.Windows.Forms.ToolStripMenuItem)
$PictureBox1 = (New-Object -TypeName System.Windows.Forms.PictureBox)
$MenuStripOverview.SuspendLayout()
$Panel10.SuspendLayout()
$Panel8.SuspendLayout()
$Panel11.SuspendLayout()
$Panel13.SuspendLayout()
$Panel12.SuspendLayout()
$Panel9.SuspendLayout()
$Panel4.SuspendLayout()
$Panel5.SuspendLayout()
$Panel6.SuspendLayout()
$Panel7.SuspendLayout()
$Panel1.SuspendLayout()
$Panel2.SuspendLayout()
$Panel3.SuspendLayout()
([System.ComponentModel.ISupportInitialize]$PictureBox1).BeginInit()
$FormOverview.SuspendLayout()
#
#Button23
#
$Button23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]397,[System.Int32]38))
$Button23.Name = [System.String]'Button23'
$Button23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]64,[System.Int32]23))
$Button23.TabIndex = [System.Int32]25
$Button23.Text = [System.String]'Weiter'
$Button23.UseCompatibleTextRendering = $true
$Button23.UseVisualStyleBackColor = $true
#
#Label28
#
$Label28.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]85,[System.Int32]28))
$Label28.Name = [System.String]'Label28'
$Label28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]76,[System.Int32]21))
$Label28.TabIndex = [System.Int32]24
$Label28.Text = [System.String]'RAM in GB'
$Label28.UseCompatibleTextRendering = $true
#
#Label29
#
$Label29.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label29.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]54))
$Label29.Name = [System.String]'Label29'
$Label29.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]114,[System.Int32]22))
$Label29.TabIndex = [System.Int32]26
$Label29.Text = [System.String]'Virtueller Switch'
$Label29.UseCompatibleTextRendering = $true
#
#Label26
#
$Label26.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$Label26.Name = [System.String]'Label26'
$Label26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]161,[System.Int32]30))
$Label26.TabIndex = [System.Int32]0
$Label26.Text = [System.String]'VM Bearbeiten'
$Label26.UseCompatibleTextRendering = $true
#
#Button7
#
$Button7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]217,[System.Int32]350))
$Button7.Name = [System.String]'Button7'
$Button7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button7.TabIndex = [System.Int32]19
$Button7.Text = [System.String]'Cancel'
$Button7.UseCompatibleTextRendering = $true
$Button7.UseVisualStyleBackColor = $true
#
#Label24
#
$Label24.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]86))
$Label24.Name = [System.String]'Label24'
$Label24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]146,[System.Int32]23))
$Label24.TabIndex = [System.Int32]7
$Label24.Text = [System.String]'Allow Management OS'
$Label24.UseCompatibleTextRendering = $true
#
#Label25
#
$Label25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1263,[System.Int32]15))
$Label25.Name = [System.String]'Label25'
$Label25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]49,[System.Int32]16))
$Label25.TabIndex = [System.Int32]22
$Label25.Text = [System.String]'werden.'
$Label25.UseCompatibleTextRendering = $true
#
#LinkLabel1
#
$LinkLabel1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1249,[System.Int32]38))
$LinkLabel1.Name = [System.String]'LinkLabel1'
$LinkLabel1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]112,[System.Int32]14))
$LinkLabel1.TabIndex = [System.Int32]12
$LinkLabel1.TabStop = $true
$LinkLabel1.Text = [System.String]'https://mobatilo.de'
$LinkLabel1.UseCompatibleTextRendering = $true
$LinkLabel1.add_LinkClicked($LinkLabel1_LinkClicked)
#
#Label23
#
$Label23.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label23.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]62))
$Label23.Name = [System.String]'Label23'
$Label23.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]59,[System.Int32]23))
$Label23.TabIndex = [System.Int32]5
$Label23.Text = [System.String]'Adapter'
$Label23.UseCompatibleTextRendering = $true
#
#Label20
#
$Label20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]579,[System.Int32]15))
$Label20.Name = [System.String]'Label20'
$Label20.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]733,[System.Int32]16))
$Label20.TabIndex = [System.Int32]22
$Label20.Text = [System.String]'Kommerziellen Nutzen haben, müssen unter gleichen Bedingungen weitergegeben werden und Minerswin muss als Urheber mitgenannt'
$Label20.UseCompatibleTextRendering = $true
#
#Label21
#
$Label21.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label21.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$Label21.Name = [System.String]'Label21'
$Label21.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]279,[System.Int32]28))
$Label21.TabIndex = [System.Int32]0
$Label21.Text = [System.String]'Virtueller Switch erstellen'
$Label21.UseCompatibleTextRendering = $true
$Label21.add_Click($Label21_Click)
#
#Button16
#
$Button16.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Button16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]309,[System.Int32]38))
$Button16.Name = [System.String]'Button16'
$Button16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]123,[System.Int32]23))
$Button16.TabIndex = [System.Int32]3
$Button16.Text = [System.String]'Liste V-Switches auf'
$Button16.UseCompatibleTextRendering = $true
$Button16.UseVisualStyleBackColor = $true
#
#Label8
#
$Label8.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]9))
$Label8.Name = [System.String]'Label8'
$Label8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]207,[System.Int32]30))
$Label8.TabIndex = [System.Int32]0
$Label8.Text = [System.String]'Snapshot erstellen'
$Label8.UseCompatibleTextRendering = $true
#
#Label9
#
$Label9.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]291))
$Label9.Name = [System.String]'Label9'
$Label9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]77,[System.Int32]23))
$Label9.TabIndex = [System.Int32]13
$Label9.Text = [System.String]'Generation'
$Label9.UseCompatibleTextRendering = $true
#
#Label4
#
$Label4.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]108))
$Label4.Name = [System.String]'Label4'
$Label4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]111,[System.Int32]23))
$Label4.TabIndex = [System.Int32]5
$Label4.Text = [System.String]'Prozessorkerne'
$Label4.UseCompatibleTextRendering = $true
#
#Label5
#
$Label5.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]10))
$Label5.Name = [System.String]'Label5'
$Label5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]140,[System.Int32]25))
$Label5.TabIndex = [System.Int32]8
$Label5.Text = [System.String]'ISO Einlegen'
$Label5.UseCompatibleTextRendering = $true
#
#Button3
#
$Button3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]317,[System.Int32]92))
$Button3.Name = [System.String]'Button3'
$Button3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button3.TabIndex = [System.Int32]12
$Button3.Text = [System.String]'Browse'
$Button3.UseCompatibleTextRendering = $true
$Button3.UseVisualStyleBackColor = $true
#
#Label7
#
$Label7.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]258))
$Label7.Name = [System.String]'Label7'
$Label7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]122,[System.Int32]23))
$Label7.TabIndex = [System.Int32]11
$Label7.Text = [System.String]'VHD in GB'
$Label7.UseCompatibleTextRendering = $true
#
#Label2
#
$Label2.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]42))
$Label2.Name = [System.String]'Label2'
$Label2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Label2.TabIndex = [System.Int32]2
$Label2.Text = [System.String]'Name der VM:'
$Label2.UseCompatibleTextRendering = $true
#
#Button1
#
$Button1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]395,[System.Int32]37))
$Button1.Name = [System.String]'Button1'
$Button1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button1.TabIndex = [System.Int32]5
$Button1.Text = [System.String]'Weiter'
$Button1.UseCompatibleTextRendering = $true
$Button1.UseVisualStyleBackColor = $true
#
#Button2
#
$Button2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]317,[System.Int32]36))
$Button2.Name = [System.String]'Button2'
$Button2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button2.TabIndex = [System.Int32]9
$Button2.Text = [System.String]'Browse'
$Button2.UseCompatibleTextRendering = $true
$Button2.UseVisualStyleBackColor = $true
#
#Label3
#
$Label3.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]75))
$Label3.Name = [System.String]'Label3'
$Label3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Label3.TabIndex = [System.Int32]3
$Label3.Text = [System.String]'RAM  in GB'
$Label3.UseCompatibleTextRendering = $true
#
#Label19
#
$Label19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-2,[System.Int32]15))
$Label19.Name = [System.String]'Label19'
$Label19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]594,[System.Int32]16))
$Label19.TabIndex = [System.Int32]21
$Label19.Text = [System.String]'Es ist Erlaubt Teile des Codes bzw. Dateien für eigene Projekte zu übernehmen, diese Projekte dürfen jedoch keinen'
$Label19.UseCompatibleTextRendering = $true
#
#Label18
#
$Label18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-2,[System.Int32]0))
$Label18.Name = [System.String]'Label18'
$Label18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]501,[System.Int32]15))
$Label18.TabIndex = [System.Int32]20
$Label18.Text = [System.String]'Es ist Verboten diese Dateien Weiterzuverkaufen, als Eigenwerk auszugeben oder zu Lizenzieren.'
$Label18.UseCompatibleTextRendering = $true
$Label18.add_Click($Label18_Click)
#
#Label15
#
$Label15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-2,[System.Int32]31))
$Label15.Name = [System.String]'Label15'
$Label15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]458,[System.Int32]14))
$Label15.TabIndex = [System.Int32]13
$Label15.Text = [System.String]'Das Projekt unterliegt der Creative Commons Lizenz 4.0 mit "by", "nc" und "sa" Modulen, '
$Label15.UseCompatibleTextRendering = $true
$Label15.add_Click($Label15_Click)
#
#Label14
#
$Label14.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]44))
$Label14.Name = [System.String]'Label14'
$Label14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Label14.TabIndex = [System.Int32]2
$Label14.Text = [System.String]'Eigene ISO'
$Label14.UseCompatibleTextRendering = $true
#
#Label17
#
$Label17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1247,[System.Int32]4))
$Label17.Name = [System.String]'Label17'
$Label17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]116,[System.Int32]19))
$Label17.TabIndex = [System.Int32]19
$Label17.Text = [System.String]'MinersWin 2019'
$Label17.UseCompatibleTextRendering = $true
#
#Label16
#
$Label16.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]447,[System.Int32]31))
$Label16.Name = [System.String]'Label16'
$Label16.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]781,[System.Int32]14))
$Label16.TabIndex = [System.Int32]14
$Label16.Text = [System.String]'d.h. Der Name des Urhebers muss genannt werden, Kommerzielle Nutzung ist Verboten, die Weitergabe muss unter den Selben bedingungen geschehen. '
$Label16.UseCompatibleTextRendering = $true
#
#AboutToolStripMenuItem
#
$AboutToolStripMenuItem.Name = [System.String]'AboutToolStripMenuItem'
$AboutToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]52,[System.Int32]20))
$AboutToolStripMenuItem.Text = [System.String]'About'
#
#Label10
#
$Label10.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]323))
$Label10.Name = [System.String]'Label10'
$Label10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]122,[System.Int32]23))
$Label10.TabIndex = [System.Int32]16
$Label10.Text = [System.String]'Virtueller Switch'
$Label10.UseCompatibleTextRendering = $true
#
#MenuStripOverview
#
$MenuStripOverview.Items.AddRange([System.Windows.Forms.ToolStripItem[]]@($DateiToolStripMenuItem2,$AktionToolStripMenuItem,$AboutToolStripMenuItem))
$MenuStripOverview.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$MenuStripOverview.Name = [System.String]'MenuStripOverview'
$MenuStripOverview.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]1363,[System.Int32]24))
$MenuStripOverview.TabIndex = [System.Int32]2
$MenuStripOverview.Text = [System.String]'MenuStripOverview'
$MenuStripOverview.add_ItemClicked($MenuStripOverview_ItemClicked)
#
#Label12
#
$Label12.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label12.ForeColor = [System.Drawing.Color]::Green
$Label12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]294,[System.Int32]16))
$Label12.Name = [System.String]'Label12'
$Label12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Label12.TabIndex = [System.Int32]1
$Label12.Text = [System.String]'Online'
$Label12.UseCompatibleTextRendering = $true
#
#Label31
#
$Label31.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label31.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]99))
$Label31.Name = [System.String]'Label31'
$Label31.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]133,[System.Int32]23))
$Label31.TabIndex = [System.Int32]30
$Label31.Text = [System.String]'Secure Boot (Gen 2)'
$Label31.UseCompatibleTextRendering = $true
#
#BeendenToolStripMenuItem
#
$BeendenToolStripMenuItem.Name = [System.String]'BeendenToolStripMenuItem'
$BeendenToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]229,[System.Int32]22))
$BeendenToolStripMenuItem.Text = [System.String]'Beenden'
#
#RadioButton1
#
$RadioButton1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]134,[System.Int32]290))
$RadioButton1.Name = [System.String]'RadioButton1'
$RadioButton1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]24))
$RadioButton1.TabIndex = [System.Int32]14
$RadioButton1.TabStop = $true
$RadioButton1.Text = [System.String]'1'
$RadioButton1.UseCompatibleTextRendering = $true
$RadioButton1.UseVisualStyleBackColor = $true
#
#Label37
#
$Label37.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label37.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1,[System.Int32]0))
$Label37.Name = [System.String]'Label37'
$Label37.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]306,[System.Int32]35))
$Label37.TabIndex = [System.Int32]0
$Label37.Text = [System.String]'Verwaltungstools Installieren'
$Label37.UseCompatibleTextRendering = $true
#
#RadioButton2
#
$RadioButton2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]181,[System.Int32]291))
$RadioButton2.Name = [System.String]'RadioButton2'
$RadioButton2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]24))
$RadioButton2.TabIndex = [System.Int32]15
$RadioButton2.TabStop = $true
$RadioButton2.Text = [System.String]'2'
$RadioButton2.UseCompatibleTextRendering = $true
$RadioButton2.UseVisualStyleBackColor = $true
#
#FeedbackToolStripMenuItem
#
$FeedbackToolStripMenuItem.Name = [System.String]'FeedbackToolStripMenuItem'
$FeedbackToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]222,[System.Int32]22))
$FeedbackToolStripMenuItem.Text = [System.String]'Feedback'
#
#TextBox1
#
$TextBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]109,[System.Int32]42))
$TextBox1.Name = [System.String]'TextBox1'
$TextBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]134,[System.Int32]21))
$TextBox1.TabIndex = [System.Int32]0
#
#ComboBox5
#
$ComboBox5.FormattingEnabled = $true
$ComboBox5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]68,[System.Int32]62))
$ComboBox5.Name = [System.String]'ComboBox5'
$ComboBox5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]198,[System.Int32]21))
$ComboBox5.TabIndex = [System.Int32]6
#
#TextBox9
#
$TextBox9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]52,[System.Int32]38))
$TextBox9.Name = [System.String]'TextBox9'
$TextBox9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]214,[System.Int32]21))
$TextBox9.TabIndex = [System.Int32]2
$TextBox9.Text = [System.String]'External VM Switch'
#
#Panel10
#
$Panel10.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel10.Controls.Add($Button20)
$Panel10.Controls.Add($TextBox13)
$Panel10.Controls.Add($Label33)
$Panel10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]11,[System.Int32]126))
$Panel10.Name = [System.String]'Panel10'
$Panel10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]471,[System.Int32]68))
$Panel10.TabIndex = [System.Int32]22
#
#Label33
#
$Label33.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label33.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1,[System.Int32]0))
$Label33.Name = [System.String]'Label33'
$Label33.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]186,[System.Int32]36))
$Label33.TabIndex = [System.Int32]0
$Label33.Text = [System.String]'Rechte vergeben'
$Label33.UseCompatibleTextRendering = $true
$Label33.add_Click($Label33_Click)
#
#Panel8
#
$Panel8.BackColor = [System.Drawing.SystemColors]::ActiveBorder
$Panel8.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel8.Controls.Add($Label25)
$Panel8.Controls.Add($Label20)
$Panel8.Controls.Add($Label18)
$Panel8.Controls.Add($Label19)
$Panel8.Controls.Add($Label16)
$Panel8.Controls.Add($Label15)
$Panel8.Controls.Add($LinkLabel1)
$Panel8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]739))
$Panel8.Name = [System.String]'Panel8'
$Panel8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]1363,[System.Int32]56))
$Panel8.TabIndex = [System.Int32]18
#
#Button8
#
$Button8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]132,[System.Int32]16))
$Button8.Name = [System.String]'Button8'
$Button8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button8.TabIndex = [System.Int32]2
$Button8.Text = [System.String]'VM Starten'
$Button8.UseCompatibleTextRendering = $true
$Button8.UseVisualStyleBackColor = $true
#
#Label22
#
$Label22.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]38))
$Label22.Name = [System.String]'Label22'
$Label22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]43,[System.Int32]23))
$Label22.TabIndex = [System.Int32]4
$Label22.Text = [System.String]'Name'
$Label22.UseCompatibleTextRendering = $true
#
#DateiToolStripMenuItem
#
$DateiToolStripMenuItem.DropDownItems.AddRange([System.Windows.Forms.ToolStripItem[]]@($MitAnderenServerVerbindenToolStripMenuItem,$BeendenToolStripMenuItem))
$DateiToolStripMenuItem.Name = [System.String]'DateiToolStripMenuItem'
$DateiToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]46,[System.Int32]20))
$DateiToolStripMenuItem.Text = [System.String]'Datei'
#
#Button5
#
$Button5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]336,[System.Int32]7))
$Button5.Name = [System.String]'Button5'
$Button5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Button5.TabIndex = [System.Int32]9
$Button5.Text = [System.String]'Zeige Snapshots'
$Button5.UseCompatibleTextRendering = $true
$Button5.UseVisualStyleBackColor = $true
#
#Button10
#
$Button10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]386,[System.Int32]44))
$Button10.Name = [System.String]'Button10'
$Button10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]50,[System.Int32]23))
$Button10.TabIndex = [System.Int32]4
$Button10.Text = [System.String]'Browse'
$Button10.UseCompatibleTextRendering = $true
$Button10.UseVisualStyleBackColor = $true
#
#TextBox13
#
$TextBox13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]39))
$TextBox13.Name = [System.String]'TextBox13'
$TextBox13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]376,[System.Int32]21))
$TextBox13.TabIndex = [System.Int32]1
$TextBox13.Text = [System.String]'DOMAIN\USER'
#
#TextBox12
#
$TextBox12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]76,[System.Int32]76))
$TextBox12.Name = [System.String]'TextBox12'
$TextBox12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]264,[System.Int32]21))
$TextBox12.TabIndex = [System.Int32]29
$TextBox12.Text = [System.String]'VM'
#
#DateiToolStripMenuItem1
#
$DateiToolStripMenuItem1.Name = [System.String]'DateiToolStripMenuItem1'
$DateiToolStripMenuItem1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]46,[System.Int32]20))
$DateiToolStripMenuItem1.Text = [System.String]'Datei'
#
#TextBox10
#
$TextBox10.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]47,[System.Int32]30))
$TextBox10.Name = [System.String]'TextBox10'
$TextBox10.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]32,[System.Int32]21))
$TextBox10.TabIndex = [System.Int32]23
$TextBox10.Text = [System.String]'2'
#
#DateiToolStripMenuItem2
#
$DateiToolStripMenuItem2.Name = [System.String]'DateiToolStripMenuItem2'
$DateiToolStripMenuItem2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]46,[System.Int32]20))
$DateiToolStripMenuItem2.Text = [System.String]'Datei'
#
#TextBox15
#
$TextBox15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]77,[System.Int32]52))
$TextBox15.Name = [System.String]'TextBox15'
$TextBox15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]306,[System.Int32]21))
$TextBox15.TabIndex = [System.Int32]7
#
#TextBox14
#
$TextBox14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]69,[System.Int32]28))
$TextBox14.Name = [System.String]'TextBox14'
$TextBox14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]314,[System.Int32]21))
$TextBox14.TabIndex = [System.Int32]5
#
#Label38
#
$Label38.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]170))
$Label38.Name = [System.String]'Label38'
$Label38.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]143,[System.Int32]23))
$Label38.TabIndex = [System.Int32]33
$Label38.Text = [System.String]'Imagepfad'
$Label38.UseCompatibleTextRendering = $true
#
#Button6
#
$Button6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]320,[System.Int32]350))
$Button6.Name = [System.String]'Button6'
$Button6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button6.TabIndex = [System.Int32]18
$Button6.Text = [System.String]'Create'
$Button6.UseCompatibleTextRendering = $true
$Button6.UseVisualStyleBackColor = $true
#
#Label36
#
$Label36.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label36.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]52))
$Label36.Name = [System.String]'Label36'
$Label36.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]73,[System.Int32]23))
$Label36.TabIndex = [System.Int32]8
$Label36.Text = [System.String]'Dateiname'
$Label36.UseCompatibleTextRendering = $true
#
#Label35
#
$Label35.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label35.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]28))
$Label35.Name = [System.String]'Label35'
$Label35.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]56,[System.Int32]23))
$Label35.TabIndex = [System.Int32]6
$Label35.Text = [System.String]'Ordner'
$Label35.UseCompatibleTextRendering = $true
#
#Label34
#
$Label34.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label34.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$Label34.Name = [System.String]'Label34'
$Label34.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]161,[System.Int32]28))
$Label34.TabIndex = [System.Int32]4
$Label34.Text = [System.String]'ConnectSkript'
$Label34.UseCompatibleTextRendering = $true
#
#Button28
#
$Button28.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]115))
$Button28.Name = [System.String]'Button28'
$Button28.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]23))
$Button28.TabIndex = [System.Int32]31
$Button28.Text = [System.String]'Sende Informationen'
$Button28.UseCompatibleTextRendering = $true
$Button28.UseVisualStyleBackColor = $true
#
#Button29
#
$Button29.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]144))
$Button29.Name = [System.String]'Button29'
$Button29.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]23))
$Button29.TabIndex = [System.Int32]32
$Button29.Text = [System.String]'Update'
$Button29.UseCompatibleTextRendering = $true
$Button29.UseVisualStyleBackColor = $true
#
#Button26
#
$Button26.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]61))
$Button26.Name = [System.String]'Button26'
$Button26.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]23))
$Button26.TabIndex = [System.Int32]29
$Button26.Text = [System.String]'Aktualisiere Vorschau'
$Button26.UseCompatibleTextRendering = $true
$Button26.UseVisualStyleBackColor = $true
#
#Button27
#
$Button27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]88))
$Button27.Name = [System.String]'Button27'
$Button27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]137,[System.Int32]23))
$Button27.TabIndex = [System.Int32]30
$Button27.Text = [System.String]'Log Speichern'
$Button27.UseCompatibleTextRendering = $true
$Button27.UseVisualStyleBackColor = $true
#
#Button24
#
$Button24.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]3))
$Button24.Name = [System.String]'Button24'
$Button24.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]137,[System.Int32]23))
$Button24.TabIndex = [System.Int32]27
$Button24.Text = [System.String]'Mit VM Verbinden'
$Button24.UseCompatibleTextRendering = $true
$Button24.UseVisualStyleBackColor = $true
#
#Button25
#
$Button25.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]32))
$Button25.Name = [System.String]'Button25'
$Button25.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]138,[System.Int32]23))
$Button25.TabIndex = [System.Int32]28
$Button25.Text = [System.String]'Öffne Hyper-V Manager'
$Button25.UseCompatibleTextRendering = $true
$Button25.UseVisualStyleBackColor = $true
#
#TextBox2
#
$TextBox2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]109,[System.Int32]75))
$TextBox2.Name = [System.String]'TextBox2'
$TextBox2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]21))
$TextBox2.TabIndex = [System.Int32]4
$TextBox2.Text = [System.String]'4'
#
#TextBox3
#
$TextBox3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]109,[System.Int32]108))
$TextBox3.Name = [System.String]'TextBox3'
$TextBox3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]19,[System.Int32]21))
$TextBox3.TabIndex = [System.Int32]6
$TextBox3.Text = [System.String]'2'
#
#Button20
#
$Button20.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]389,[System.Int32]37))
$Button20.Name = [System.String]'Button20'
$Button20.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button20.TabIndex = [System.Int32]2
$Button20.Text = [System.String]'OK'
$Button20.UseCompatibleTextRendering = $true
$Button20.UseVisualStyleBackColor = $true
#
#MitAnderenHostVerbindenToolStripMenuItem
#
$MitAnderenHostVerbindenToolStripMenuItem.Name = [System.String]'MitAnderenHostVerbindenToolStripMenuItem'
$MitAnderenHostVerbindenToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]222,[System.Int32]22))
$MitAnderenHostVerbindenToolStripMenuItem.Text = [System.String]'Mit anderen Host verbinden'
#
#TextBox6
#
$TextBox6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]42))
$TextBox6.Name = [System.String]'TextBox6'
$TextBox6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]352,[System.Int32]21))
$TextBox6.TabIndex = [System.Int32]1
$TextBox6.Text = [System.String]'Name des Snapshots'
#
#TextBox7
#
$TextBox7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]134,[System.Int32]254))
$TextBox7.Name = [System.String]'TextBox7'
$TextBox7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]41,[System.Int32]21))
$TextBox7.TabIndex = [System.Int32]12
$TextBox7.Text = [System.String]'50'
#
#TextBox4
#
$TextBox4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]38))
$TextBox4.Name = [System.String]'TextBox4'
$TextBox4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]308,[System.Int32]21))
$TextBox4.TabIndex = [System.Int32]7
#
#TextBox5
#
$TextBox5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]92))
$TextBox5.Name = [System.String]'TextBox5'
$TextBox5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]308,[System.Int32]21))
$TextBox5.TabIndex = [System.Int32]10
#
#Label1
#
$Label1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]14.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]9))
$Label1.Name = [System.String]'Label1'
$Label1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]125,[System.Int32]23))
$Label1.TabIndex = [System.Int32]1
$Label1.Text = [System.String]'VM Erstellen'
$Label1.UseCompatibleTextRendering = $true
#
#TextBox8
#
$TextBox8.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]44))
$TextBox8.Name = [System.String]'TextBox8'
$TextBox8.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]292,[System.Int32]21))
$TextBox8.TabIndex = [System.Int32]3
#
#RichTextBox1
#
$RichTextBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]491,[System.Int32]27))
$RichTextBox1.Name = [System.String]'RichTextBox1'
$RichTextBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]860,[System.Int32]315))
$RichTextBox1.TabIndex = [System.Int32]16
$RichTextBox1.Text = [System.String]''
#
#ComboBox2
#
$ComboBox2.FormattingEnabled = $true
$ComboBox2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]134,[System.Int32]323))
$ComboBox2.Name = [System.String]'ComboBox2'
$ComboBox2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]158,[System.Int32]21))
$ComboBox2.TabIndex = [System.Int32]17
#
#ComboBox1
#
$ComboBox1.FormattingEnabled = $true
$ComboBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]37))
$ComboBox1.Name = [System.String]'ComboBox1'
$ComboBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]386,[System.Int32]21))
$ComboBox1.TabIndex = [System.Int32]4
$ComboBox1.Text = [System.String]'VM'
#
#ComboBox7
#
$ComboBox7.FormattingEnabled = $true
$ComboBox7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]38))
$ComboBox7.Name = [System.String]'ComboBox7'
$ComboBox7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]390,[System.Int32]21))
$ComboBox7.TabIndex = [System.Int32]24
#
#ComboBox6
#
$ComboBox6.FormattingEnabled = $true
$ComboBox6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]123,[System.Int32]52))
$ComboBox6.Name = [System.String]'ComboBox6'
$ComboBox6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]149,[System.Int32]21))
$ComboBox6.TabIndex = [System.Int32]27
#
#Button22
#
$Button22.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]395,[System.Int32]50))
$Button22.Name = [System.String]'Button22'
$Button22.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]64,[System.Int32]23))
$Button22.TabIndex = [System.Int32]9
$Button22.Text = [System.String]'Weiter'
$Button22.UseCompatibleTextRendering = $true
$Button22.UseVisualStyleBackColor = $true
#
#ComboBox4
#
$ComboBox4.FormattingEnabled = $true
$ComboBox4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$ComboBox4.Name = [System.String]'ComboBox4'
$ComboBox4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]387,[System.Int32]21))
$ComboBox4.TabIndex = [System.Int32]6
$ComboBox4.Text = [System.String]'Host'
#
#Button19
#
$Button19.BackColor = [System.Drawing.Color]::Firebrick
$Button19.ForeColor = [System.Drawing.SystemColors]::ControlLight
$Button19.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]388,[System.Int32]91))
$Button19.Name = [System.String]'Button19'
$Button19.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button19.TabIndex = [System.Int32]37
$Button19.Text = [System.String]'Delete'
$Button19.UseCompatibleTextRendering = $true
$Button19.UseVisualStyleBackColor = $false
#
#Button18
#
$Button18.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]388,[System.Int32]120))
$Button18.Name = [System.String]'Button18'
$Button18.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button18.TabIndex = [System.Int32]36
$Button18.Text = [System.String]'Weiter'
$Button18.UseCompatibleTextRendering = $true
$Button18.UseVisualStyleBackColor = $true
#
#Button4
#
$Button4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]361,[System.Int32]40))
$Button4.Name = [System.String]'Button4'
$Button4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button4.TabIndex = [System.Int32]7
$Button4.Text = [System.String]'Erstellen'
$Button4.UseCompatibleTextRendering = $true
$Button4.UseVisualStyleBackColor = $true
#
#Button15
#
$Button15.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Button15.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]308,[System.Int32]9))
$Button15.Name = [System.String]'Button15'
$Button15.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]124,[System.Int32]23))
$Button15.TabIndex = [System.Int32]1
$Button15.Text = [System.String]'Liste Adapter auf'
$Button15.UseCompatibleTextRendering = $true
$Button15.UseVisualStyleBackColor = $true
#
#Button14
#
$Button14.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]395,[System.Int32]3))
$Button14.Name = [System.String]'Button14'
$Button14.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button14.TabIndex = [System.Int32]7
$Button14.Text = [System.String]'Confirm'
$Button14.UseCompatibleTextRendering = $true
$Button14.UseVisualStyleBackColor = $true
#
#Button17
#
$Button17.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]357,[System.Int32]114))
$Button17.Name = [System.String]'Button17'
$Button17.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button17.TabIndex = [System.Int32]9
$Button17.Text = [System.String]'Erstellen'
$Button17.UseCompatibleTextRendering = $true
$Button17.UseVisualStyleBackColor = $true
#
#Panel11
#
$Panel11.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel11.Controls.Add($Button22)
$Panel11.Controls.Add($Label36)
$Panel11.Controls.Add($TextBox15)
$Panel11.Controls.Add($Label35)
$Panel11.Controls.Add($TextBox14)
$Panel11.Controls.Add($Label34)
$Panel11.Controls.Add($Button21)
$Panel11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]11,[System.Int32]200))
$Panel11.Name = [System.String]'Panel11'
$Panel11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]466,[System.Int32]81))
$Panel11.TabIndex = [System.Int32]23
#
#Button11
#
$Button11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]70))
$Button11.Name = [System.String]'Button11'
$Button11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button11.TabIndex = [System.Int32]5
$Button11.Text = [System.String]'Clear'
$Button11.UseCompatibleTextRendering = $true
$Button11.UseVisualStyleBackColor = $true
#
#Panel13
#
$Panel13.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel13.Controls.Add($Label38)
$Panel13.Controls.Add($Button29)
$Panel13.Controls.Add($Button28)
$Panel13.Controls.Add($Button27)
$Panel13.Controls.Add($Button26)
$Panel13.Controls.Add($Button25)
$Panel13.Controls.Add($PictureBox1)
$Panel13.Controls.Add($Button24)
$Panel13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]11,[System.Int32]366))
$Panel13.Name = [System.String]'Panel13'
$Panel13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]471,[System.Int32]197))
$Panel13.TabIndex = [System.Int32]28
#
#Panel12
#
$Panel12.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel12.Controls.Add($Button23)
$Panel12.Controls.Add($Label37)
$Panel12.Controls.Add($ComboBox7)
$Panel12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]11,[System.Int32]287))
$Panel12.Name = [System.String]'Panel12'
$Panel12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]471,[System.Int32]69))
$Panel12.TabIndex = [System.Int32]25
#
#Button12
#
$Button12.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]88,[System.Int32]70))
$Button12.Name = [System.String]'Button12'
$Button12.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button12.TabIndex = [System.Int32]6
$Button12.Text = [System.String]'Weiter'
$Button12.UseCompatibleTextRendering = $true
$Button12.UseVisualStyleBackColor = $true
#
#TextBox11
#
$TextBox11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]167,[System.Int32]28))
$TextBox11.Name = [System.String]'TextBox11'
$TextBox11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]30,[System.Int32]21))
$TextBox11.TabIndex = [System.Int32]25
$TextBox11.Text = [System.String]'4'
#
#DonateToolStripMenuItem
#
$DonateToolStripMenuItem.Name = [System.String]'DonateToolStripMenuItem'
$DonateToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]222,[System.Int32]22))
$DonateToolStripMenuItem.Text = [System.String]'Donate'
#
#Panel9
#
$Panel9.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel9.Controls.Add($Button17)
$Panel9.Controls.Add($CheckBox1)
$Panel9.Controls.Add($Label24)
$Panel9.Controls.Add($ComboBox5)
$Panel9.Controls.Add($Label23)
$Panel9.Controls.Add($Label22)
$Panel9.Controls.Add($Button16)
$Panel9.Controls.Add($TextBox9)
$Panel9.Controls.Add($Button15)
$Panel9.Controls.Add($Label21)
$Panel9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]491,[System.Int32]584))
$Panel9.Name = [System.String]'Panel9'
$Panel9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]439,[System.Int32]144))
$Panel9.TabIndex = [System.Int32]21
#
#OpenFileDialog1
#
$OpenFileDialog1.FileName = [System.String]'OpenFileDialog1'
#
#ComboBox3
#
$ComboBox3.FormattingEnabled = $true
$ComboBox3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]145,[System.Int32]14))
$ComboBox3.Name = [System.String]'ComboBox3'
$ComboBox3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]291,[System.Int32]21))
$ComboBox3.TabIndex = [System.Int32]1
$ComboBox3.Text = [System.String]'Vorgeschlagen'
#
#Panel4
#
$Panel4.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel4.Controls.Add($Button9)
$Panel4.Controls.Add($Button8)
$Panel4.Controls.Add($Label12)
$Panel4.Controls.Add($Label11)
$Panel4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]491,[System.Int32]425))
$Panel4.Name = [System.String]'Panel4'
$Panel4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]442,[System.Int32]54))
$Panel4.TabIndex = [System.Int32]9
#
#Panel5
#
$Panel5.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel5.Controls.Add($Button12)
$Panel5.Controls.Add($Button11)
$Panel5.Controls.Add($Button10)
$Panel5.Controls.Add($TextBox8)
$Panel5.Controls.Add($Label14)
$Panel5.Controls.Add($ComboBox3)
$Panel5.Controls.Add($Label13)
$Panel5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]491,[System.Int32]483))
$Panel5.Name = [System.String]'Panel5'
$Panel5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]442,[System.Int32]100))
$Panel5.TabIndex = [System.Int32]10
#
#Panel6
#
$Panel6.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel6.Controls.Add($Button14)
$Panel6.Controls.Add($ComboBox4)
$Panel6.Controls.Add($ComboBox1)
$Panel6.Controls.Add($Button1)
$Panel6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]50))
$Panel6.Name = [System.String]'Panel6'
$Panel6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]70))
$Panel6.TabIndex = [System.Int32]14
#
#Panel7
#
$Panel7.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel7.Controls.Add($Button19)
$Panel7.Controls.Add($Button18)
$Panel7.Controls.Add($CheckBox5)
$Panel7.Controls.Add($CheckBox4)
$Panel7.Controls.Add($CheckBox3)
$Panel7.Controls.Add($Label32)
$Panel7.Controls.Add($CheckBox2)
$Panel7.Controls.Add($Label31)
$Panel7.Controls.Add($TextBox12)
$Panel7.Controls.Add($Label30)
$Panel7.Controls.Add($ComboBox6)
$Panel7.Controls.Add($Label29)
$Panel7.Controls.Add($TextBox11)
$Panel7.Controls.Add($Label28)
$Panel7.Controls.Add($TextBox10)
$Panel7.Controls.Add($Label27)
$Panel7.Controls.Add($Label26)
$Panel7.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]569))
$Panel7.Name = [System.String]'Panel7'
$Panel7.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]470,[System.Int32]154))
$Panel7.TabIndex = [System.Int32]17
#
#Panel1
#
$Panel1.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel1.Controls.Add($Button7)
$Panel1.Controls.Add($Button6)
$Panel1.Controls.Add($ComboBox2)
$Panel1.Controls.Add($Label10)
$Panel1.Controls.Add($RadioButton2)
$Panel1.Controls.Add($RadioButton1)
$Panel1.Controls.Add($Label9)
$Panel1.Controls.Add($TextBox7)
$Panel1.Controls.Add($Label7)
$Panel1.Controls.Add($Panel2)
$Panel1.Controls.Add($TextBox3)
$Panel1.Controls.Add($Label4)
$Panel1.Controls.Add($TextBox2)
$Panel1.Controls.Add($Label3)
$Panel1.Controls.Add($Label2)
$Panel1.Controls.Add($Label1)
$Panel1.Controls.Add($TextBox1)
$Panel1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]936,[System.Int32]348))
$Panel1.Name = [System.String]'Panel1'
$Panel1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]415,[System.Int32]385))
$Panel1.TabIndex = [System.Int32]6
#
#Panel2
#
$Panel2.Controls.Add($Button3)
$Panel2.Controls.Add($Label6)
$Panel2.Controls.Add($TextBox5)
$Panel2.Controls.Add($Label5)
$Panel2.Controls.Add($Button2)
$Panel2.Controls.Add($TextBox4)
$Panel2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]135))
$Panel2.Name = [System.String]'Panel2'
$Panel2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]402,[System.Int32]120))
$Panel2.TabIndex = [System.Int32]10
#
#Panel3
#
$Panel3.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Panel3.Controls.Add($Button5)
$Panel3.Controls.Add($TextBox6)
$Panel3.Controls.Add($Button4)
$Panel3.Controls.Add($Label8)
$Panel3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]491,[System.Int32]348))
$Panel3.Name = [System.String]'Panel3'
$Panel3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]439,[System.Int32]71))
$Panel3.TabIndex = [System.Int32]8
#
#Button21
#
$Button21.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]396,[System.Int32]28))
$Button21.Name = [System.String]'Button21'
$Button21.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]63,[System.Int32]23))
$Button21.TabIndex = [System.Int32]3
$Button21.Text = [System.String]'Browse'
$Button21.UseCompatibleTextRendering = $true
$Button21.UseVisualStyleBackColor = $true
#
#Button13
#
$Button13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]408,[System.Int32]22))
$Button13.Name = [System.String]'Button13'
$Button13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]77,[System.Int32]25))
$Button13.TabIndex = [System.Int32]11
$Button13.Text = [System.String]'Reset'
$Button13.UseCompatibleTextRendering = $true
$Button13.UseVisualStyleBackColor = $true
#
#Label27
#
$Label27.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label27.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]30))
$Label27.Name = [System.String]'Label27'
$Label27.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]23))
$Label27.TabIndex = [System.Int32]22
$Label27.Text = [System.String]'CPU'
$Label27.UseCompatibleTextRendering = $true
#
#CheckBox3
#
$CheckBox3.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]123,[System.Int32]122))
$CheckBox3.Name = [System.String]'CheckBox3'
$CheckBox3.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]24))
$CheckBox3.TabIndex = [System.Int32]33
$CheckBox3.Text = [System.String]'Netzwerk'
$CheckBox3.UseCompatibleTextRendering = $true
$CheckBox3.UseVisualStyleBackColor = $true
#
#LabelOverview
#
$LabelOverview.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Times New Roman',[System.Single]14.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LabelOverview.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]24))
$LabelOverview.Name = [System.String]'LabelOverview'
$LabelOverview.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]390,[System.Int32]23))
$LabelOverview.TabIndex = [System.Int32]0
$LabelOverview.Text = [System.String]'Hostname'
$LabelOverview.UseCompatibleTextRendering = $true
#
#ExportToolStripMenuItem
#
$ExportToolStripMenuItem.Name = [System.String]'ExportToolStripMenuItem'
$ExportToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]222,[System.Int32]22))
$ExportToolStripMenuItem.Text = [System.String]'Export'
#
#Label32
#
$Label32.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label32.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]122))
$Label32.Name = [System.String]'Label32'
$Label32.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]114,[System.Int32]23))
$Label32.TabIndex = [System.Int32]32
$Label32.Text = [System.String]'First Boot device'
$Label32.UseCompatibleTextRendering = $true
#
#Label11
#
$Label11.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label11.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]9))
$Label11.Name = [System.String]'Label11'
$Label11.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]128,[System.Int32]30))
$Label11.TabIndex = [System.Int32]0
$Label11.Text = [System.String]'Start/Stop'
$Label11.UseCompatibleTextRendering = $true
#
#MitAnderenServerVerbindenToolStripMenuItem
#
$MitAnderenServerVerbindenToolStripMenuItem.Name = [System.String]'MitAnderenServerVerbindenToolStripMenuItem'
$MitAnderenServerVerbindenToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]229,[System.Int32]22))
$MitAnderenServerVerbindenToolStripMenuItem.Text = [System.String]'Mit anderen Server verbinden'
#
#Button9
#
$Button9.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]213,[System.Int32]16))
$Button9.Name = [System.String]'Button9'
$Button9.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$Button9.TabIndex = [System.Int32]3
$Button9.Text = [System.String]'VM Stoppen'
$Button9.UseCompatibleTextRendering = $true
$Button9.UseVisualStyleBackColor = $true
#
#Label30
#
$Label30.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label30.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]76))
$Label30.Name = [System.String]'Label30'
$Label30.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]67,[System.Int32]23))
$Label30.TabIndex = [System.Int32]28
$Label30.Text = [System.String]'VM Name'
$Label30.UseCompatibleTextRendering = $true
#
#ProgressBar1
#
$ProgressBar1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]1087,[System.Int32]0))
$ProgressBar1.MarqueeAnimationSpeed = [System.Int32]10
$ProgressBar1.Name = [System.String]'ProgressBar1'
$ProgressBar1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]154,[System.Int32]23))
$ProgressBar1.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$ProgressBar1.TabIndex = [System.Int32]15
$ProgressBar1.Value = [System.Int32]45
#
#CheckBox4
#
$CheckBox4.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]192,[System.Int32]122))
$CheckBox4.Name = [System.String]'CheckBox4'
$CheckBox4.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]24))
$CheckBox4.TabIndex = [System.Int32]34
$CheckBox4.Text = [System.String]'HDD'
$CheckBox4.UseCompatibleTextRendering = $true
$CheckBox4.UseVisualStyleBackColor = $true
#
#CheckBox1
#
$CheckBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]155,[System.Int32]84))
$CheckBox1.Name = [System.String]'CheckBox1'
$CheckBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]16,[System.Int32]24))
$CheckBox1.TabIndex = [System.Int32]8
$CheckBox1.UseCompatibleTextRendering = $true
$CheckBox1.UseVisualStyleBackColor = $true
#
#Label13
#
$Label13.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label13.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]10))
$Label13.Name = [System.String]'Label13'
$Label13.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]148,[System.Int32]34))
$Label13.TabIndex = [System.Int32]0
$Label13.Text = [System.String]'ISO einlegen'
$Label13.UseCompatibleTextRendering = $true
#
#CheckBox2
#
$CheckBox2.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]142,[System.Int32]99))
$CheckBox2.Name = [System.String]'CheckBox2'
$CheckBox2.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]44,[System.Int32]24))
$CheckBox2.TabIndex = [System.Int32]31
$CheckBox2.Text = [System.String]'An'
$CheckBox2.UseCompatibleTextRendering = $true
$CheckBox2.UseVisualStyleBackColor = $true
#
#CheckBox5
#
$CheckBox5.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]245,[System.Int32]122))
$CheckBox5.Name = [System.String]'CheckBox5'
$CheckBox5.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]47,[System.Int32]24))
$CheckBox5.TabIndex = [System.Int32]35
$CheckBox5.Text = [System.String]'DVD'
$CheckBox5.UseCompatibleTextRendering = $true
$CheckBox5.UseVisualStyleBackColor = $true
#
#Label6
#
$Label6.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Comic Sans MS',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$Label6.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]66))
$Label6.Name = [System.String]'Label6'
$Label6.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]23))
$Label6.TabIndex = [System.Int32]11
$Label6.Text = [System.String]'VHD Root Pfad'
$Label6.UseCompatibleTextRendering = $true
#
#AktionToolStripMenuItem
#
$AktionToolStripMenuItem.DropDownItems.AddRange([System.Windows.Forms.ToolStripItem[]]@($MitAnderenHostVerbindenToolStripMenuItem,$ExportToolStripMenuItem,$DonateToolStripMenuItem,$FeedbackToolStripMenuItem))
$AktionToolStripMenuItem.Name = [System.String]'AktionToolStripMenuItem'
$AktionToolStripMenuItem.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]54,[System.Int32]20))
$AktionToolStripMenuItem.Text = [System.String]'Aktion'
#
#PictureBox1
#
$PictureBox1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]153,[System.Int32]3))
$PictureBox1.Name = [System.String]'PictureBox1'
$PictureBox1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]311,[System.Int32]192))
$PictureBox1.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$PictureBox1.TabIndex = [System.Int32]26
$PictureBox1.TabStop = $false
#
#FormOverview
#
$FormOverview.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]1363,[System.Int32]795))
$FormOverview.Controls.Add($Panel13)
$FormOverview.Controls.Add($Panel12)
$FormOverview.Controls.Add($Panel11)
$FormOverview.Controls.Add($Panel10)
$FormOverview.Controls.Add($Panel9)
$FormOverview.Controls.Add($Panel8)
$FormOverview.Controls.Add($Panel7)
$FormOverview.Controls.Add($Label17)
$FormOverview.Controls.Add($RichTextBox1)
$FormOverview.Controls.Add($ProgressBar1)
$FormOverview.Controls.Add($Panel6)
$FormOverview.Controls.Add($Button13)
$FormOverview.Controls.Add($Panel5)
$FormOverview.Controls.Add($Panel4)
$FormOverview.Controls.Add($Panel3)
$FormOverview.Controls.Add($Panel1)
$FormOverview.Controls.Add($LabelOverview)
$FormOverview.Controls.Add($MenuStripOverview)
$FormOverview.MainMenuStrip = $MenuStripOverview
$FormOverview.Text = [System.String]'MinersWin Hyper-V Manager'
$FormOverview.add_Load($FormOverview_Load)
$MenuStripOverview.ResumeLayout($false)
$MenuStripOverview.PerformLayout()
$Panel10.ResumeLayout($false)
$Panel10.PerformLayout()
$Panel8.ResumeLayout($false)
$Panel11.ResumeLayout($false)
$Panel11.PerformLayout()
$Panel13.ResumeLayout($false)
$Panel12.ResumeLayout($false)
$Panel9.ResumeLayout($false)
$Panel9.PerformLayout()
$Panel4.ResumeLayout($false)
$Panel5.ResumeLayout($false)
$Panel5.PerformLayout()
$Panel6.ResumeLayout($false)
$Panel7.ResumeLayout($false)
$Panel7.PerformLayout()
$Panel1.ResumeLayout($false)
$Panel1.PerformLayout()
$Panel2.ResumeLayout($false)
$Panel2.PerformLayout()
$Panel3.ResumeLayout($false)
$Panel3.PerformLayout()
([System.ComponentModel.ISupportInitialize]$PictureBox1).EndInit()
$FormOverview.ResumeLayout($false)
$FormOverview.PerformLayout()
Add-Member -InputObject $FormOverview -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button23 -Value $Button23 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label28 -Value $Label28 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label29 -Value $Label29 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label26 -Value $Label26 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button7 -Value $Button7 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label24 -Value $Label24 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label25 -Value $Label25 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name LinkLabel1 -Value $LinkLabel1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label23 -Value $Label23 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label20 -Value $Label20 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label21 -Value $Label21 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button16 -Value $Button16 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label8 -Value $Label8 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label9 -Value $Label9 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label4 -Value $Label4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label5 -Value $Label5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button3 -Value $Button3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label7 -Value $Label7 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label2 -Value $Label2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button1 -Value $Button1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button2 -Value $Button2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label3 -Value $Label3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label19 -Value $Label19 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label18 -Value $Label18 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name FolderBrowserDialog1 -Value $FolderBrowserDialog1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label15 -Value $Label15 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label14 -Value $Label14 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label17 -Value $Label17 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label16 -Value $Label16 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name AboutToolStripMenuItem -Value $AboutToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label10 -Value $Label10 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name MenuStripOverview -Value $MenuStripOverview -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name DateiToolStripMenuItem2 -Value $DateiToolStripMenuItem2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name AktionToolStripMenuItem -Value $AktionToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name MitAnderenHostVerbindenToolStripMenuItem -Value $MitAnderenHostVerbindenToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ExportToolStripMenuItem -Value $ExportToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name DonateToolStripMenuItem -Value $DonateToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name FeedbackToolStripMenuItem -Value $FeedbackToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label12 -Value $Label12 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label31 -Value $Label31 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name BeendenToolStripMenuItem -Value $BeendenToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name RadioButton1 -Value $RadioButton1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label37 -Value $Label37 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name RadioButton2 -Value $RadioButton2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox1 -Value $TextBox1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox5 -Value $ComboBox5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox9 -Value $TextBox9 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel10 -Value $Panel10 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button20 -Value $Button20 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox13 -Value $TextBox13 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label33 -Value $Label33 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel8 -Value $Panel8 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button8 -Value $Button8 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label22 -Value $Label22 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name DateiToolStripMenuItem -Value $DateiToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name MitAnderenServerVerbindenToolStripMenuItem -Value $MitAnderenServerVerbindenToolStripMenuItem -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button5 -Value $Button5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button10 -Value $Button10 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox12 -Value $TextBox12 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name DateiToolStripMenuItem1 -Value $DateiToolStripMenuItem1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox10 -Value $TextBox10 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox15 -Value $TextBox15 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox14 -Value $TextBox14 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label38 -Value $Label38 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button6 -Value $Button6 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label36 -Value $Label36 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label35 -Value $Label35 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label34 -Value $Label34 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button28 -Value $Button28 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button29 -Value $Button29 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button26 -Value $Button26 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button27 -Value $Button27 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button24 -Value $Button24 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button25 -Value $Button25 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox2 -Value $TextBox2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox3 -Value $TextBox3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox6 -Value $TextBox6 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox7 -Value $TextBox7 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox4 -Value $TextBox4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox5 -Value $TextBox5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label1 -Value $Label1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name BackgroundWorker1 -Value $BackgroundWorker1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox8 -Value $TextBox8 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name RichTextBox1 -Value $RichTextBox1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox2 -Value $ComboBox2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox1 -Value $ComboBox1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox7 -Value $ComboBox7 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox6 -Value $ComboBox6 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button22 -Value $Button22 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox4 -Value $ComboBox4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button19 -Value $Button19 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button18 -Value $Button18 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button4 -Value $Button4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button15 -Value $Button15 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button14 -Value $Button14 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button17 -Value $Button17 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel11 -Value $Panel11 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button21 -Value $Button21 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button11 -Value $Button11 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel13 -Value $Panel13 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name PictureBox1 -Value $PictureBox1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel12 -Value $Panel12 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button12 -Value $Button12 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name TextBox11 -Value $TextBox11 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel9 -Value $Panel9 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name CheckBox1 -Value $CheckBox1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name OpenFileDialog1 -Value $OpenFileDialog1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ComboBox3 -Value $ComboBox3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel4 -Value $Panel4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button9 -Value $Button9 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label11 -Value $Label11 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel5 -Value $Panel5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label13 -Value $Label13 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel6 -Value $Panel6 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel7 -Value $Panel7 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name CheckBox5 -Value $CheckBox5 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name CheckBox4 -Value $CheckBox4 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name CheckBox3 -Value $CheckBox3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label32 -Value $Label32 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name CheckBox2 -Value $CheckBox2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label30 -Value $Label30 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label27 -Value $Label27 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel1 -Value $Panel1 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel2 -Value $Panel2 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Label6 -Value $Label6 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Panel3 -Value $Panel3 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name Button13 -Value $Button13 -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name LabelOverview -Value $LabelOverview -MemberType NoteProperty
Add-Member -InputObject $FormOverview -Name ProgressBar1 -Value $ProgressBar1 -MemberType NoteProperty
#Hinzufgen der Funktionen zu den Buttons
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

#Knpfe Unsichtbar machen
$Button24.Enabled = $false
$Button26.Enabled = $false

#Auswahl unsichtbar machen
$ComboBox1.Enabled = $false

$RichTextBox1.Enabled = $false
$RadioButton1.Checked = $true


}
. InitializeComponent

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

#Fügt Domain\Name in die Rechtevergabe ein
$TextBox13.Text = "$($env:UserDomain)\$($env:UserName)"

#Überprüft die Version
function Test-Version{
    #Lädt den Inhalt der Pastebin Seite mit der neusten Version
    $Update = Invoke-WebRequest https://pastebin.com/raw/zBUriG1D

    $Update.Content
    if ($Update.Content -gt "1910"){
        #Wenn Version älter ist, als die aktuellte Gib Meldung aus
        Write-Host "Update Erforderlich: https://pastebin.com/TvfCY9KQ"
        Write-Output "$(Get-Date) Es ist ein Update erforderlich." >> $MyDir\Log\Latest.log
    [System.Windows.Forms.MessageBox]::Show("Update ist Erforderlich, Bitte Update das Skript um die neusten Funktionen und Support zu erhalten. Alte Versionen werden nicht mehr Supportet. Aktuellste Version: https://pastebin.com/TvfCY9KQ","MinersWin Hyper-V Manager V.2",1)
    } elseif ($Update.Content -lt 1910) {
        #Wenn Version neuer ist als aktuellste Gib Fehler aus
        Write-Output "$(Get-Date) Fehler bei der Updateüberprofung, Aktuelle Version ist älter als die Online zur verfügung stehende." >> $MyDir\Log\Latest.log
        Write-Host "Fehler"
    [System.Windows.Forms.MessageBox]::Show("Fehler beim Abruf der aktuellsten Version","MinersWin Hyper-V Manager V.2",1)
    } else {
        #Wenn Version die Aktuellste ist Gib Hinweis aus und fahre fort
        Write-Host "Alles in Ordnung"
        Write-Host "Aktuellste Version Installiert"
    }
}
#Gib Version und Build im log aus
Write-Output "$(Get-Date) Version 1.9.10 wird ausgeführt. Build: 22.05.2019" >> $MyDir\Log\Latest.log
#Führe Versionstest aus
Test-Version



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
    } else {
        $VMName = $ComboBox1.Text
        $Hostname = $ComboBox4.Text
        Get-VM -ComputerName $Hostname -Name $VMName | Checkpoint-VM -SnapshotName $snapshotName -asJob
        Show-Snapshot
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
    $ISOgewaehlt = $ComboBox3.SelectedItem
    $eigeneiso = $TextBox8.Text.ToString()
    if ($ISOgewaehlt -eq "ISO Liste" -and $eigeneiso -eq ""){
        [System.Windows.Forms.MessageBox]::Show("Bitte eine ISO auswhlen","MinersWin HyperV Manager",1)
    } elseif ($ISOgewaehlt -ne "ISO Liste" -and $eigeneiso -ne ""){
        $isopfad = $eigeneiso
    } elseif ($ISOgewaehlt -ne "ISO Liste"){
        switch ($ISOgewaehlt){
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
    } else {
        $Label12.Text = "Offline"
        $Label12.ForeColor = "Red"
        $Button9.Enabled = $false
        $Button8.Enabled = $true
        $PictureBox1.Enabled = $false
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
}

function Open-Manager{
        Write-Output "[Open-Manager]" >> $MyDir\Log\Latest.log
            $Datum = Get-Date
            Write-Output "$Datum öffne den Hyper-V Manager" >> $MyDir\Log\Latest.log
    virtmgmt.msc
            $Datum = Get-Date
            Write-Output "$Datum Fertig" >> $MyDir\Log\Latest.log
}

function Save-File([string] $initialDirectory ){
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
}

function Send-Information{
    $MailFrom = "hyperv-manager@minerswins.de"
    $MailTo = "minerswin@minerswin.de"
    $Username = "hyperv-manager@minerswins.de"
    $Password = "pufisence"
    $SmtpServer = "mx2f5c.netcup.net"
    $SmtpPort = "587"
    $MessageSubject = "Hyper-V Manager Report von $($env:CLIENTNAME)"
    $Message = New-Object System.Net.Mail.MailMessage $MailFrom,$MailTo
    $Message.Subject = $MessageSubject

    $datei = Get-content $MyDir\Log\Latest.log | Out-String

    $Message.Body = "$($datei)"
    $Smtp = New-Object Net.Mail.SmtpClient($SmtpServer,$SmtpPort)
    $Smtp.EnableSsl = $true
    $Smtp.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
    $Smtp.Send($Message)
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

        $MailFrom = "hyperv-manager@minerswins.de"
        $MailTo = "minerswin@minerswin.de"
        $Username = "hyperv-manager@minerswins.de"
        $Password = "pufisence"
        $SmtpServer = "mx2f5c.netcup.net"
        $SmtpPort = "587"
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

