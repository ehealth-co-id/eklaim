[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [AllowEmptyString()]
    [String]
    $OriginalInput
)
process {
    $unicodeEncoding = [System.Text.Encoding]::Unicode;
    $asciiEncoding = [System.Text.Encoding]::ASCII;
    $byteArray = $unicodeEncoding.GetBytes($OriginalInput);
    $outputString = $asciiEncoding.GetString($byteArray)
    Write-Output $outputString
}

