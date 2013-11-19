$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "edit-xml" {
    $testfile = ".\resources\valid.xml"

    Context "with a valid file and xpath" {
        It "should call the specified block with the resulting node" {
            edit-xml $testfile '/root/element1' {
                param($node)
                $node.name | should be 'element1'
            }
        }

        It "should save the file after the action is done" {
            $before = (gci $testfile).lastwritetime

            edit-xml $testfile '/root/element1' {}

            $after = (gci $testfile).lastwritetime

            $after | should not be $before
        }
    }

    Context "when the file is not found" {
        It "should throw an exception with the specified path in the message" {
            try {
                edit-xml '.\foo.xml' '/foo' {}
            } catch {
                $_.exception.message | should match "foo.xml"
            }
        }
    }

    Context "when the xpath is not found" {
        It "should return without invoking the action" {
            edit-xml $testfile '/non-existing-node' {
                throw "This should not happen"
            }
        }
    }

    Context "when the file is not valid XML" {
        It "should throw an exception with the specified path in the message" {
            "not valid xml" > .\resources\invalid.xml

            try {
                edit-xml .\resources\invalid.xml "/foo" {}
            } catch {
                $_.exception.message | should match "invalid.xml"
            } finally {
                rm .\resources\invalid.xml
            }
        }
    }

    Context "when selecting context nodes in a namespace" {
        It "should select the specified element" {
            $namespaces = @{ 'x' = 'http://www.example.com' }

            edit-xml .\resources\namespace.xml "//x:element1" {
                param($node)
                $node.localname | should be 'element1'
                $node.namespaceuri | should be 'http://www.example.com'
            }
        }

        It "should return nothing when no namespaces are defined" {
            edit-xml .\resources\namespace.xml "//x:element1" {
                param($node)
                $node | should be $null
            }
        }
    }
}

