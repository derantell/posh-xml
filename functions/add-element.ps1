function add-element {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)] [string]$name,
        [Parameter(Position=1,Mandatory=1)] [system.xml.xmlnode]$context,
        [Parameter(Position=2,Mandatory=0)] 
        [ValidateSet('append','prepend','before','after')]  [string]$position = 'append',
        [Parameter(Position=3,Mandatory=0)] [hashtable]$attributes = @{}
    )

    $doc = $context.ownerdocument
    $element = $doc.createelement($name) 

    $attributes.keys | foreach {
        $element.setattribute($_, $attributes[$_])
    }

    switch( $position ) {
        'append'  { $context.appendchild($element) }
        'prepend' { $context.prependchild($element) } 
        'before'  { $context.parentnode.insertbefore($element, $context) } 
        'after'   { $context.parentnode.insertafter($element, $context) }
    }
}

