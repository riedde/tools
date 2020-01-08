xquery version "1.0";
(:
    JRA, BauDi, dried, 2019
:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";

declare option saxon:output "method=xml";
declare option saxon:output "media-type=text/xml";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "indent=no";

let $newInput := doc('../contents/resources/newInputWikiImage.xml')

let $docsToUpdate := collection('../contents/persons?select=*.xml')/tei:TEI

for $each in $newInput//result
    let $searchID := $each/id/@xml:id
    let $document := $docsToUpdate[@xml:id=$searchID]
    let $bibl := doc(document-uri($document/root()))//tei:bibl[@type='links']
    let $linkPart := $each/link
    let $link := concat('https://de.wikipedia.org',$linkPart)
    let $ref := <ref xmlns="http://www.tei-c.org/ns/1.0" target="{$link}"/>
return
    update insert $bibl/tei:ref/@target into $link
