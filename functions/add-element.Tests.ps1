$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "add-element" {

    Context "when appending an element to the context node" {
        It "should add the new element as the last child of the parent" {
            $xml = [xml] (gc ".\resources\valid.xml")
            $parent = select-xml '/root' $xml

            add-element "element2" $parent.node

            $parent.node.childnodes.length | should be 2
            $parent.node.lastchild.localname | should be "element2"
        }
    }

    Context "when prepending an element to the context node" {
        It "should add the new element as the first child of the parent" {
            $xml = [xml] (gc ".\resources\valid.xml")
            $parent = select-xml '/root' $xml

            add-element "element0" $parent.node -position prepend

            $parent.node.childnodes.length | should be 2
            $parent.node.firstchild.localname | should be "element0"
        }
    }
}

