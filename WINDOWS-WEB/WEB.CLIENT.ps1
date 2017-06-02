

function Create-Folder {
    Param ([string]$path)
    if ((Test-Path $path) -eq $false) 
    {
        Write-Host "$path doesn't exist. Creating now.."
        New-Item -ItemType "directory" -Path $path
    }
}

function Download-File{
    Param ([string]$src, [string] $dst)

    (New-Object System.Net.WebClient).DownloadFile($src,$dst)
    #Invoke-WebRequest $src -OutFile $dst
}

function WaitForFile($File) {
  while(!(Test-Path $File)) {    
    Start-Sleep -s 10;   
  }  
} 


#Setup Folders

$setupFolder = "D:\WEBRDPCLIENT"
Create-Folder "$setupFolder"

Create-Folder "$setupFolder\training"
$setupFolder = "$setupFolder\training"



$os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’

# webRDP-Client Installation 
if((Test-Path "$setupFolder\webRDP-Client_1.2.0.42-32.exe") -eq $false)
{
    Write-Host "Downloading WEBRDP-CLIENT installation file.."
    if ($os_type -eq "True"){
        Download-File "https://shuk06-my.sharepoint.com/personal/syed_shuk06_onmicrosoft_com/_layouts/15/guestaccess.aspx?docid=170c5247fd9664ac89af5beda6036364a&authkey=AaFHc8Vve_8ukS4KElnjdKQ" "$setupFolder\webRDP-Client_1.2.0.42-32.exe"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}

# Prepare Configuration file
Write-Host "Preparing configuration file.."
if((Test-Path "$setupFolder\webrdpClient.inf") -eq $false)
{
    Write-Host "Downloading WEB-RDP CLIENT installation file.."
    if ($os_type -eq "True"){
        Download-File "https://github.com/SYED1306/WEB_CLIENT/blob/master/WINDOWS-WEB/webrdpClient.inf" "$setupFolder\webrdpClient.inf"
    }else {
        Write-Host "32 Bit system is not supported"
    }    
}



Write-Host "Installing SQL Server.."
Start-Process -FilePath "$setupFolder\webRDP-Client_1.2.0.42-32.exe" -ArgumentList '/ConfigurationFile="C:\WEBRDPCLIENT\training\webrdpClient.inf"'
Write-Host 'Installation completed.'

