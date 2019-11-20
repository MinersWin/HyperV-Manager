function Test_TuningPack{
    $TuningPack = Test-Path '.\TuningPack\TGF-Tuning-Pack-4.0-master\GUI.ps1'
    if ($TuningPack){
        $Button49.Add_Click{(TuningPack)}
        $Button49.ForeColor = 'Green'
    } else {
        $Button49.Add_Click{(Download_TuningPack)}
        $Button49.ForeColor = 'RED'
    }
    }
    function TuningPack{
        & '.\TuningPack\TGF-Tuning-Pack-4.0-master\GUI.ps1'
    }
    function Download_TuningPack{
        mkdir TuningPack
        Set-Location .\TuningPack
        wget 'https://github.com/MinersWin/TGF-Tuning-Pack-4.0/archive/master.zip' -OutFile 'TuningPack.zip'
        Expand-Archive .\TuningPack.zip -DestinationPath .\
        rm TuningPack.zip
        Set-Location .\..\
        Test_TuningPack
    }