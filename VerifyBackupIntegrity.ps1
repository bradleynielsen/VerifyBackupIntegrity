
#init


$sourcePath      = "Z:\backup"
$destinationPath = "D:\backup"


#$sourceFileList      = Get-ChildItem -Path $sourcePath -Recurse -Depth 1
$destinationFileList = Get-ChildItem -Path $destinationPath -Recurse


$sourceCsvPath      = "$PSScriptRoot\sourceHash.csv"
$destinationCsvPath = "$PSScriptRoot\destinationHash.csv"

$sourceResultsArray      = @()
$destinationResultsArray = @()




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


# send to CSV file    
$destinationResultsArray | Export-Csv -Path $destinationCsvPath -NoTypeInformation

notepad $destinationCsvPath