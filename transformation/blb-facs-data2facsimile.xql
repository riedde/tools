xquery version "3.1";
(:
    JRA, Dennis Ried, 2020
    This script collects BLB Image-URLs
    must be executed by eXist-db
:)

declare namespace functx = "http://www.functx.com"; (:at "../../../BauDi/baudiResources/data/libraries/functx.xqm";:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace http = "http://expath.org/ns/http-client";

declare function local:getFolia ($n) {
    switch (string($n))
    case '1' return '1r'
    case '2' return '1v'
    case '3' return '2r'
    case '4' return '2v'
    case '5' return '3r'
    case '6' return '3v'
    case '7' return '4r'
    case '8' return '4v'
    case '9' return '5r'
    case '10' return '5v'
    case '11' return '6r'
    case '12' return '6v'
    case '13' return '7r'
    case '14' return '7v'
    case '15' return '8r'
    case '16' return '8v'
    case '17' return '9r'
    case '18' return '9v'
    case '19' return '10r'
    case '20' return '10v'
    case '21' return '11r'
    case '22' return '11v'
    case '23' return '12r'
    case '24' return '12v'
    case '25' return '13r'
    case '26' return '13v'
    case '27' return '14r'
    case '28' return '14v'
    case '29' return '15r'
    case '30' return '15v'
    case '31' return '16r'
    case '32' return '16v'
    case '33' return '17r'
    case '34' return '17v'
    case '35' return '18r'
    case '36' return '18v'
    case '37' return '19r'
    case '38' return '19v'
    case '39' return '20r'
    case '40' return '20v'
    case '41' return '21r'
    case '42' return '21v'
    case '43' return '22r'
    case '44' return '22v'
    case '45' return '23r'
    case '46' return '23v'
    case '47' return '24r'
    case '48' return '24v'
    case '49' return '25r'
    case '50' return '25v'
    default return $n
};

let $collection := collection('../../../BauDi/baudiSources/data/music?select=*.xml;recurse=yes')

let $docsToUpdate := $collection//mei:mei

for $docToUpdate in $docsToUpdate
    let $docUri := document-uri($docToUpdate/root())
    let $doc := doc($docUri)/mei:mei
    let $docID := $doc/@xml:id/string()
    
    let $facs := $doc//mei:facsimile[not(mei:surface)]
    let $images := $facs/mei:image
    let $surfaces := for $image at $i in $images
                        let $vlid := $image/@vlid
                        let $width := $image/@width
                        let $height := $image/@height
                        let $number := format-number($i, '0000')
                        let $folia := local:getFolia($i)
                        return
                            <surface xml:id="{$docID}-surface-{$number}" n="{$i}" label="{$folia}" xmlns="http://www.music-encoding.org/ns/mei">
                                <graphic targettype="blb-vlid" target="{$vlid}" xml:id="{$docID}-00-{$number}" type="facsimile"/>
                            </surface>
    
    return
        if($images)
        then(
            insert nodes $surfaces into $facs,
            delete nodes $images
        )
        else()