function add-element {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)] [string]$name,
        [Parameter(Position=1,Mandatory=1)] [system.xml.xmlnode]$context,
        [Parameter(Position=2,Mandatory=0)] 
        [ValidateSet('append', 'prepend')]  [string]$position = 'append',
        [Parameter(Position=3,Mandatory=0)] [hashtable]$attributes = @{}
    )

    $doc = $context.ownerdocument
    $element = $doc.createelement($name) 

    $attributes.keys | foreach {
        $element.setattribute($_, $attributes[$_])
    }

    $context.appendchild($element)
}

