xquery version "3.0";

(:  generate, copy/update @n and @lable of <measure/> 

    This is to be used in oXygen XML editor with Saxon-EE.
    nbeer, 2018-03-28 :)

declare namespace mei="http://www.music-encoding.org/ns/mei";

let $sourceURI := '/Users/niko/Repos/MRI/rwa/contents/sources/music/manuscripts/edirom_source_9d3cd0c8-0884-4683-9b91-fccd21cee911.xml'
let $doc := doc($sourceURI)

for $measure in $doc//mei:mdiv[12]//mei:part[1]//mei:measure
let $label := $measure/@n

let $n := if (contains($measure/@n, "'")) then (concat('2', format-number(number(substring-before($measure/@n, "'")), '00'))) else(concat('1', format-number($measure/@n, '00')))
return

(:replace value of node $measure/@n with $n:)
(:    update value $measure/@n with $n :)
    insert nodes (attribute label {$label}) as last into $measure
    
    
