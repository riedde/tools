xquery version "3.0";
(:
    MRI, RWA, nbeer, 2015
    Modify position values of zones in sources

:)

declare default element namespace "http://www.edirom.de/ns/1.2";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace xu="http://www.xmldb.org/xupdate";
declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace mei="http://www.music-encoding.org/ns/mei";

declare option saxon:output "method=xml";
declare option saxon:output "media-type=text/xml";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "indent=no";

let $doc := doc('/Users/dried/Repositories/rwa/contents/sources/music/manuscripts/rwa_musms_0ee6158d-a554-47df-a4fc-6bb3c7e48030.xml')

for $zone in $doc/mei:mei/mei:music/mei:facsimile//mei:zone

    (: Set the scale factor :)
    let $scaleFactor := 2.985
    
    (: Multiply all coordinate values with the scale factor :)
    let $ulxNew :=  round($zone/@ulx * $scaleFactor)
    let $ulyNew :=  round($zone/@uly * $scaleFactor)
    let $lrxNew :=  round($zone/@lrx * $scaleFactor)
    let $lryNew :=  round($zone/@lry * $scaleFactor)
    
    (: Replace all old coordinate values with the scaled coordinate values :)
    return 
        (
        replace value of node $zone/@ulx with $ulxNew,
        replace value of node $zone/@uly with $ulyNew,
        replace value of node $zone/@lrx with $lrxNew,
        replace value of node $zone/@lry with $lryNew
        )