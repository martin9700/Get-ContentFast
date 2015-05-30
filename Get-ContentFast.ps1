Function Get-ContentFast
{
    <#
    .SYNOPSIS
        Fast alternative to Get-Content
    .DESCRIPTION
        Get-Content is a slow, but powerful cmdlet.  Get-ContentFast is a faster alternative with much of the same functionality.  Get-ContentFast is limited to only reading text files.

    .PARAMETER Path
        Specify the path to the file you want to read.  Pipeline or array input is accepted.

    .PARAMETER FullName
        Pipe the file name for the file you want to read from Get-ChildItem or Get-ItemProperty

    .PARAMETER Raw
        Ignores newline characters and returns the entire contents of a file in one string. By default, the contents of a file is returned as a array of strings that is delimited by the newline character.

    .PARAMETER TotalCount
        Gets the specified number of lines from the beginning of a file. Default is all lines.

    .PARAMETER Tail
        Gets the specified number of lines from the end of a file.

    .INPUTS
        [String]
        [System.IO.FileInfo]
    .OUTPUTS
        [String]
        [String[]]
    .EXAMPLE
        Get-ContentFast -Path .\test.txt

        Read the file test.txt

    .EXAMPLE
        Get-ContentFast -Path ".\test.txt",".\test2.txt"

        Read both files

    .EXAMPLE
        Get-ContentFast -Path .\test.txt -Raw

        Read the entire file and output a single string

    .EXAMPLE
        ".\Test.txt" | Get-ContentFast -Tail 4

        Read the Test.txt file and only output the last 4 lines.

    .EXAMPLE
        Get-ChildItem Test.txt | Get-ContentFast -TotalCount 5

        Read the Test.txt file and ouput only the first 5 lines

    .EXAMPLE
        Get-ChildItem *.txt | Get-ContentFast -TotalCount 4 -Tail 2

        Read all text files in the current directory and output the first 4 lines and the last 2 lines

    .NOTES
        Author:             Martin Pugh
        Twitter:            @thesurlyadm1n
        Spiceworks:         Martin9700
        Blog:               www.thesurlyadmin.com
      
        Changelog:
            1.0             Initial Release
    .LINK
        https://github.com/martin9700/Get-ContentFast
    #>
    [CmdletBinding(DefaultParameterSetName="Normal")]
    Param (
        [Parameter(ParameterSetName="Normal",Position=0,ValueFromPipeline)]
        [string[]]$Path,

        [Parameter(ParameterSetName="Pipe",ValueFromPipelineByPropertyName)]
        [string]$Fullname,

        [Parameter(ParameterSetName="Raw")]
        [Parameter(ParameterSetName="Pipe")]
        [switch]$Raw,

        [Parameter(ParameterSetName="Normal")]
        [Parameter(ParameterSetName="Pipe")]
        [ValidateScript({ $_ -gt 0 })]
        [int64]$TotalCount,

        [Parameter(ParameterSetName="Normal")]
        [Parameter(ParameterSetName="Pipe")]
        [ValidateScript({ $_ -gt 0 })]
        [int64]$Tail
    )

    PROCESS
    {
        If ($PSCmdlet.ParameterSetName -eq "Pipe")
        {
            $Path = $FullName
        }
        Else
        {
            If (-not (Test-Path $Path))
            {
                Write-Error "Unable to find $Path"
                Exit 2
            }
        }

        ForEach ($PathName in $Path)
        {
            Try {
                Write-Verbose "Reading $PathName..."
                $File = New-Object System.IO.StreamReader -Argument $PathName
            }
            Catch {
                Write-Error "Unable to read $PathName because $($Error[0])"
                Exit 999
            }

            If ($Raw)
            {
                Write-Output $File.ReadToEnd()
            }
            Else
            {
                $RawData = New-Object -TypeName System.Collections.ArrayList
                Switch ($true)
                {
                    {$TotalCount} 
                    {
                        $Count = 0
                        While ($Line = $File.ReadLine())
                        {
                            Write-Output $Line
                            $RawData.Add($Line) | Out-Null
                            $Count ++

                            If ($Count -eq $TotalCount)
                            {
                                Break
                            }
                        }
                        If ($Count -eq 0)
                        {
                            Write-Warning "$Path was empty"
                            Break
                        }
                    }
                    {$Tail} 
                    {
                        While ($Line = $File.ReadLine())
                        {
                            $RawData.Add($Line) | Out-Null
                        }


                        If ($Tail -gt $RawData.Count)
                        {
                            Write-Warning "Tail = $Tail is larger then file size, reading whole file"
                            $Tail = $RawData.Count
                        }
                        For ($i = ($RawData.Count - 1) - ($Tail - 1) ; $i -le $RawData.Count - 1 ; $i++)
                        {
                            Write-Output $RawData[$i]
                        }
                    }
                    Default 
                    {
                        While ($Line = $File.ReadLine())
                        {
                            Write-Output $Line
                        }
                        Break
                    }
                }
            }
        }
    }
}

Get-ContentFast -Tail 2 -path @("c:\dropbox\test\words.txt","c:\dropbox\test\test.txt")
#gci "c:\dropbox\test\dictionary.txt" | Get-ContentFast 

