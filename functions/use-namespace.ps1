$namespaces = @{}

function use-namespace {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)] [string] $prefix,
        [Parameter(Position=1,Mandatory=1)] [string] $uri
    )

    $namespaces[$prefix] = $uri
}

