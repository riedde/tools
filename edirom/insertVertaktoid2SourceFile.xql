xquery version "1.0";
(:
    MRI, RWA, dried, 2018
    
    >>>Skript muss lokal ausgeführt werden.<<<
    Oxygen-Preferences: Update 'on'; Tree 'linked'; Backup 'on'
:)

declare default element namespace "http://www.edirom.de/ns/1.3";

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare namespace functx = "http://www.functx.com";

(:declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=yes indent=yes";:)

let $sourceID := 'rwa_edition_85fde4af-2f99-442e-8f8b-69a3084e5e26'


let $docToUpdate := doc(concat('insertValues/',$sourceID,'.xml'))
let $docVertaktoidClean := doc(concat('vertaktoid/clean/',$sourceID,'-clean.xml'))

let $surfacesVertaktoid := $docVertaktoidClean//mei:surface
let $mdivsVertaktoid := $docVertaktoidClean//mei:body/mei:mdiv

return
	(
	insert nodes $mdivsVertaktoid as last into $docToUpdate//mei:body,
	for $i in 1 to count($docToUpdate//mei:surface)
		let $zonesVertaktoid := $docVertaktoidClean//mei:surface[$i]/mei:zone
		return
    		insert nodes $zonesVertaktoid as last into $docToUpdate//mei:surface[$i]
    )

