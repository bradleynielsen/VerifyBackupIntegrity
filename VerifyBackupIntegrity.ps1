
#init


$sourcePath      = "Z:\backup"
$destinationPath = "D:\backup"


$sourceFileList      = Get-ChildItem -Path $sourcePath -Recurse
$destinationFileList = Get-ChildItem -Path $destinationPath -Recurse


$sourceCsvPath      = "$PSScriptRoot\sourceHash.csv"
$destinationCsvPath = "$PSScriptRoot\destinationHash.csv"



function getnerate-HashTable {

    Param (
        [Parameter(Mandatory = $true)] $FileList
    )

    $ResultsArray = @()

    foreach ($file in $FileList) {
	    #Getting file hash 
        $fileHash = Get-FileHash $file.FullName -Algorithm MD5
        
        if ($fileHash){
            #get path without disk letter
            $pathOnDisk = ($fileHash.Path).substring(2)
            #push file hash to table
            $results = [PSCustomObject]@{
                Hash = $fileHash.Hash
                Path = $pathOnDisk
            }
            $ResultsArray += $results
        } else {
        
        }
    }

    return $ResultsArray
}


$sourceResultsArray = getnerate-HashTable -FileList $sourceFileList
#$destinationResultsArray = getnerate-HashTable -FileList $destinationFileList -ResultsArray $destinationResultsArray



<#
foreach ($file in $destinationFileList) {
	#Getting file hash Using MD5 for speed
    $fileHash = Get-FileHash $file.FullName -Algorithm MD5
    
    if ($fileHash){
        $results = [PSCustomObject]@{
            Path = $fileHash.Path
            Hash = $fileHash.Hash
        }
        $destinationResultsArray += $results
    } else {
        
    }
}


#>

$sourceResultsArray | sort Path
