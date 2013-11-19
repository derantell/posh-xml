$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "use-namespace" {

    It "should add the specified namespace to the global `$namespaces variable" {
        use-namespace 'x' 'http://www.example.com'

        $namespaces['x'] | should be 'http://www.example.com'
    }

    It "should add multiple namespaces when called multiple times" {
        use-namespace 'x' 'http://www.example.com'
        use-namespace 'y' 'http://www.contoso.com'
        use-namespace 'z' 'http://www.tempuri.com'

        $namespaces.count | should be 3
    }
}

