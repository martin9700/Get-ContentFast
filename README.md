# Get-ContentFast
Fast alternative to Get-Content
####SYNOPSIS
    Fast alternative to Get-Content
####DESCRIPTION
    Get-Content is a slow, but powerful cmdlet.  Get-ContentFast is a faster alternative with much of the same functionality.  Get-ContentFast is limited to only reading text files.

####PARAMETER Path
    Specify the path to the file you want to read.  Pipeline or array input is accepted.

####PARAMETER FullName
    Pipe the file name for the file you want to read from Get-ChildItem or Get-ItemProperty

####PARAMETER Raw
    Ignores newline characters and returns the entire contents of a file in one string. By default, the contents of a file is returned as a array of strings that is delimited by the newline character.

####PARAMETER TotalCount
    Gets the specified number of lines from the beginning of a file. Default is all lines.

####PARAMETER Tail
    Gets the specified number of lines from the end of a file.

####INPUTS
    [String]
    [System.IO.FileInfo]
####OUTPUTS
    [String]
    [String[]]
####EXAMPLE
    Get-ContentFast -Path .\test.txt

    Read the file test.txt

####EXAMPLE
    Get-ContentFast -Path ".\test.txt",".\test2.txt"

    Read both files

####EXAMPLE
    Get-ContentFast -Path .\test.txt -Raw

    Read the entire file and output a single string

####EXAMPLE
    ".\Test.txt" | Get-ContentFast -Tail 4

    Read the Test.txt file and only output the last 4 lines.

####EXAMPLE
    Get-ChildItem Test.txt | Get-ContentFast -TotalCount 5

    Read the Test.txt file and ouput only the first 5 lines

####EXAMPLE
    Get-ChildItem *.txt | Get-ContentFast -TotalCount 4 -Tail 2

    Read all text files in the current directory and output the first 4 lines and the last 2 lines
