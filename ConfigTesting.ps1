$File = Import-LocalizedData -BaseDirectory C:\Users\Administrator\Desktop\HyperV-Manager\Config -FileName Config.psd1

$ConfigName = $File.Name
$ConfigDirectoryName = $File.DirectoryName
$ConfigVersion = $File.VersionInfo.ProductVersion
$ConfigBuild = $File.VersionInfo.Build
$ConfigLastUpdate = $File.VersionInfo.LastUpdate
$ConfigLastUpdateSearch = $File.VersionInfo.LastUpdateSearch
$ConfigAuthor = $File.VersionInfo.Author
$ConfigCompanyName = $File.VersionInfo.CompanyName
$ConfigDescription = $File.VersionInfo.Description

$ConfigCheckForUpdates = $File.Update.CheckforUpdates -eq "YES"
$ConfigNewestVersion = $File.Update.NewestVersion
$ConfigUpdateWarn = $File.Update.Warn -eq "YES"
$ConfigUpdateDownload = $File.Update.AutoDownload -eq "YES"
$ConfigUpdateScript = $File.Update.UpdateScript -eq "YES"
$ConfigUpdateReplaceOldVersion = $File.Update.ReplaceOldVersion -eq "YES"
$ConfigUpdateSaveOldVersion = $File.Update.SaveOldVersion -eq "YES"
$ConfigUpdateNewLanguages = $File.Update.DownloadNewLanguages -eq "YES"

$ConfigLanguage = $File.Language.Language

$ConfigDonate1 = $File.Websites.Donate1
$ConfigDonate2 = $File.Websites.Donate2
$ConfigAboutSite = $File.Websites.AboutSite

$ConfigMailSendTo = $File.Mail.SendFeedbackTo

$ConfigSMTPUsername = $File.Mail.Username
$ConfigSMTPPassword = $File.Mail.Password
$ConfigSMTPServer = $File.Mail.SmtpServer
$ConfigSMTPPort = $File.Mail.SmtpPort

$ConfigPathSaveInTemp = $File.Update.SaveInTemp -eq "YES"
$ConfigPathThumbnailPath = $File.Path.ThumbnailPath
$configPathLogPath = $File.Path.LogPath


"
Name: $ConfigName
Directory Name: $ConfigDirectoryName
Version: $ConfigVersion
Build: $ConfigBuild
Last Update: $ConfigLastUpdate
Last Update Search: $ConfigLastUpdateSearch
Author: $ConfigAuthor
Company: $ConfigCompanyName
Description: $ConfigDescription

Check for Updates: $ConfigCheckForUpdates
Newest Version: $ConfigNewestVersion
Update Warn: $ConfigUpdateWarn
Update Download: $ConfigUpdateDownload
Update Script: $ConfigUpdateScript
Replace Old Version: $ConfigUpdateReplaceOldVersion
Save Old Version: $ConfigUpdateSaveOldVersion
$ConfigUpdateNewLanguages

$ConfigLanguage

$ConfigDonate1
$ConfigDonate2
$ConfigAboutSite

$ConfigMailSendTo

$ConfigSMTPUsername
$ConfigSMTPPassword
$ConfigSMTPServer
$ConfigSMTPPort

$ConfigPathSaveInTemp
$ConfigPathThumbnailPath
$configPathLogPath
"