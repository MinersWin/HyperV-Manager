Add-Type -AssemblyName System.Windows.Forms
$Config = Import-LocalizedData -FileName Config.psd1
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
$Update = Invoke-WebRequest http://download.hyperv-manager.de/HyperV-Manager/New_Version.html

Expand-Archive "$($Update.Content)_Update.zip" -DestinationPath .\
Set-Location .\HyperV-Manager-master\
del $ConfigDirectoryName
copy *.* $ConfigDirectoryName
