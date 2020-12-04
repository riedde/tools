xquery version "1.0";
(:
    JRA, BauDi, dried, 2019
:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com" at "../../../BauDi/baudiResources/data/libraries/functx.xqm";

declare option saxon:output "method=xml";
declare option saxon:output "media-type=text/xml";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "indent=no";

let $collection := collection('../../../BauDi/baudiSources/data/music?select=*.xml;recurse=yes')

let $docsToUpdate := $collection//mei:mei (:[@xml:id='baudi-01-ID']:)

for $docToUpdate in $docsToUpdate
    let $docUri := document-uri($docToUpdate/root())
    let $doc := doc($docUri)/mei:mei
    let $docID := $doc/@xml:id/string()
    
    let $fileDesc := $doc//mei:fileDesc
    let $fileDescTitle := $fileDesc/mei:titleStmt/mei:title[@type="uniform"]
    let $fileDescTitleMain := $fileDescTitle/mei:titlePart[@type="main"]/normalize-space(text())
    let $fileDescTitleSub := $fileDescTitle/mei:titlePart[@type="subordinate"]/normalize-space(text())
    
    let $work := $doc//mei:workList/mei:work
    let $workTitle := $work/mei:title[@type="uniform"]
    let $workTitleMain := $workTitle/mei:titlePart[@type="main"]
    let $workTitleSub := $workTitle/mei:titlePart[@type="subordinate"]
    
    return
        (
         if($workTitleMain[. = ''])
         then(replace value of node $workTitleMain with $fileDescTitleMain)
         else(),
         if($workTitleSub[. = ''])
         then(replace value of node $workTitleSub with $fileDescTitleSub)
         else()
        )
