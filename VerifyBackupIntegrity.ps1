
#init


$sourcePath      = "Z:\backup"
$destinationPath = "D:\backup"


$sourceFileList      = Get-ChildItem -Path $sourcePath -Recurse
$destinationFileList = Get-ChildItem -Path $destinationPath -Recurse


$sourceCsvPath      = "$PSScriptRoot\sourceHash.csv"
$destinationCsvPath = "$PSScriptRoot\destinationHash.csv"

$compareTableCsvPath = "$PSScriptRoot\compareTableCsvPath.csv"

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




<#
$sourceResultsArray      | sort Path
$destinationResultsArray | sort Path

($sourceResultsArray      | sort Path)[0]
($destinationResultsArray | sort Path)[0]


($sourceResultsArray      | sort Path)[0].path -eq ($destinationResultsArray | sort Path)[0].path 


$destinationResultsArray.IndexOf($sourceResultsArray[0])









#init index counter
$i = 0
foreach($element in $sourceResultsArray ){
    #$sourceResultsArray[$i]
    
    [array]::indexof($destinationResultsArray,$sourceResultsArray[$i])
    

    #increment index counter
    $i++
}

#>

