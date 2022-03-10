#User vars:
$sourcePath          = "Z:\"
$destinationPath     = "D:\"



#init quick vars
$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$sourceCsvPath       = "$PSScriptRoot\sourceHash.csv"
$destinationCsvPath  = "$PSScriptRoot\destinationHash.csv"
$compareTableCsvPath = "$PSScriptRoot\compareTableCsvPath.csv"
cls


#load file info into vars (long process)


Write-Host (
"Getting source file information
Start time: " + (Get-Date -Format "HH:mm:ss")
)

$sourceFileList      = Get-ChildItem -Path $sourcePath -Recurse
$destinationFileList = Get-ChildItem -Path $destinationPath -Recurse


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
                Path = $pathOnDisk
                Hash = $fileHash.Hash

            }
            $ResultsArray += $results
        } else {
        
        }
    }

    return $ResultsArray
}


$sourceResultsArray      = getnerate-HashTable -FileList $sourceFileList      | sort Path
$destinationResultsArray = getnerate-HashTable -FileList $destinationFileList | sort Path




$comp = Compare-Object -ReferenceObject $sourceResultsArray -DifferenceObject $destinationResultsArray -Property path, hash


$comp | Export-Csv $compareTableCsvPath

notepad $compareTableCsvPath

$minutes = $Stopwatch.elapsed.Minutes
$seconds = $Stopwatch.elapsed.Seconds


"Complete."

"End time: " + (Get-Date -Format 'HH:mm:ss')

"Time elapsed: "
$minutes.ToString() + " Minutes" 
$seconds.ToString() + " Seconds" 
