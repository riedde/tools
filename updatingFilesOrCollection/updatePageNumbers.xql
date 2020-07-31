xquery version "1.0";
(:
    MRI, RWA, dried, 2018
    Update @n with new numbers; position() will be new @n
    >>>Skript muss in der eXistDB ausgeführt werden.<<<
:)

declare default element namespace "http://www.edirom.de/ns/1.3";

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare namespace functx = "http://www.functx.com";

declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=yes indent=yes";

let $docToUpdate := xmldb:document('/db/contents/edition-rwa/resources/xql/InsertReplace/rwa_musms_0ee6158d-a554-47df-a4fc-6bb3c7e48030.xml')
let $surfaces := $docToUpdate//mei:facsimile/mei:surface

for $surface in $surfaces
    let $pageNumOld := $surface/@n
    let $pageNumNew := count($surface/preceding-sibling::*)+1.

return
    update value $pageNumOld with $pageNumNew


(:replace value of node $pageNumOld with $pageNumNew:) (:$docToUpdate//mei:facsimile/mei:surface/@n:)
    (:update insert $ preceding $editionDoc//work[@xml:id = $workID]/concordances//concordance[1]:)
    
    (:xmldb:store('xmldb:exist:///db/contents/edition-rwa/resources/xml/concs/rwaVol_II-8/', $concFileName, $concordance):)
