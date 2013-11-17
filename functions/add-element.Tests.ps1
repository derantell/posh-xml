$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

function get-contextnode ($xpath) {
    $xml = [xml] (gc ".\resources\valid.xml")
    (select-xml $xpath $xml).node
}

Describe "add-element" {

    It "Should return the newly inserted node" {
        $parent = get-contextnode '/root'

        $newelement = add-element "element2" $parent

        $newelement.localname | should be 'element2'
    }

    Context "when appending an element to the context node" {
        It "should add the new element as the last child of the parent" {
            $parent = get-contextnode '/root'
            add-element "element2" $parent

            $parent.childnodes.count | should be 2
            $parent.lastchild.localname | should be "element2"
        }
    }

    Context "when prepending an element to the context node" {
        It "should add the new element as the first child of the parent" {
            $parent = get-contextnode '/root'

            add-element "element0" $parent -position prepend

            $parent.childnodes.count | should be 2
            $parent.firstchild.localname | should be "element0"
        }
    }

    Context "when inserting an element before the context node" {
        It "should insert the new element as the previous sibling of the context node" {
            $sibling = get-contextnode '/root/element1' 

            add-element "element0" $sibling -position before

            $sibling.previoussibling.localname | should be "element0"
        }
    }

    Context "when inserting an element after the context node" {
        It "should insert the new element as the following sibling of the context node" {
            $sibling = get-contextnode '/root/element1' 

            add-element "element2" $sibling -position after 

            $sibling.nextsibling.localname | should be "element2"
        }
    }
}

