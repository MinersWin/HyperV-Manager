$Datum = Get-Date

$Exists = Test-Path "$($MyDir)\Config\Config.psd1"
if ($Exists){
    Set-Location "$($MyDir)\Config\"
    rm Config.psd1
} else {

}

@"
@{
    Name = 'Hyper-V Manager by MinersWin'
    Length = 4532304
    DirectoryName = '$MyDir\'

    VersionInfo = @{
      ProductVersion = '1.9.10' 
      Build = '21.05.2019'
      LastUpdate = '21.05.2019'
      LastUpdateSearch = '$Datum'
      Author = 'Moritz Mantel'
      CompanyName = 'MinersWin'
      Description = 'Some description.'
    }
    Update = @{
      CheckForUpdates = 'YES'
      NewestVersion = 'https://pastebin.com/raw/zBUriG1D'
      Warn = 'YES'
      AutoDownload = 'YES'
      UpdateScript = '$($MyDir)\Upload.ps1'
      ReplaceOldVersion = 'YES'
      SaveOldVersion = 'YES'
      DownloadNewLanguages = 'NO'
    }
    Language = @{
      #Avaiable Languages: de-DE en-EN
      Language = 'de-DE'
    }
    Websites = @{
      Donate1 = 'https://www.paypal.me/minerswin'
      Donate2 = 'https://www.patreon.com/minerswin'
      AboutSite = 'https://www.Hyper-V-Manager.de/About/'
    }
    Mail = @{
      SendFeedbackTo = 'HyperV-Manager@MinersWin.de'
      
      #SMTP Server
      Username = ''
      Password = ''
      SmtpServer = ''
      SmtpPort = ''
    }
    Path = @{
      SaveInTemp = 'YES'
      ThumbnailPath = '$($MyDir)\Thumbnails\'
      LogPath = '$($MyDir)\Log\'
    }
}
"@ | Out-File -FilePath $MyDir\Config\Config.psd1
 
