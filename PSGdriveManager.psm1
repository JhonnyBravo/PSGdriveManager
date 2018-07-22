$URL=@{
    x32="https://docs.google.com/uc?id=0B3X9GlR6EmbnV3RNeFVUQjZvS2c&export=download";
    x64="https://drive.google.com/uc?id=0B3X9GlR6EmbnbnBsTXlfS1J5UjQ&export=download"
}

$gdrive_path="${HOME}/gdrive"

<#
.SYNOPSIS
gdrive をインストールします。

.PARAMETER x32
32 bit 版 gdrive をインストールします。

.PARAMETER x64
64 bit 版 gdrive をインストールします。
#>
function Install-Gdrive([switch]$x32,[switch]$x64){
    if((Test-Path $gdrive_path) -eq $false){
        New-Item -ItemType "directory" $gdrive_path
    }
    
    if(Test-Path "${gdrive_path}/gdrive.exe"){
        Remove-Item "${gdrive_path}/gdrive.exe"
    }

    if($x32){
        Invoke-WebRequest $URL["x32"] -OutFile "${gdrive_path}/gdrive.exe"
    }elseif($x64){
        Invoke-WebRequest $URL["x64"] -OutFile "${gdrive_path}/gdrive.exe"
    }else{
        Write-Output "オプションを指定してください。"
    }
}

<#
.SYNOPSIS
gdrive をアンインストールします。
#>
function Uninstall-Gdrive(){
    if(Test-Path $gdrive_path){
        Remove-Item -Recurse $gdrive_path
    }
}

<#
.SYNOPSIS
環境変数 Path へ gdrive がインストールされているフォルダーのパスを追加します。
#>
function Set-GdrivePath(){
    $env:Path="${env:Path}${gdrive_path};"
}

<#
.SYNOPSIS
Google Drive とローカルフォルダーを同期します。

.PARAMETER upload
ローカルフォルダーから Google Drive へ同期します。

.PARAMETER download
Google Drive からローカルフォルダーへ同期します。

.PARAMETER path
ローカルフォルダーのパスを指定します。

.PARAMETER file_id
Google Drive の fileID を指定します。
#>
function Sync-Gdrive([switch]$upload,[switch]$download,[string]$path,[string]$file_id){
    if($upload){
        gdrive sync upload --keep-local --delete-extraneous $path $file_id
    }elseif($download){
        gdrive sync download --keep-local --delete-extraneous $file_id $path
    }
}