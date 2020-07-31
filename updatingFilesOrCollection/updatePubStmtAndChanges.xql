xquery version "3.0";
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

let $docsToUpdate := collection('../contents/sources/documents?select=*.xml')/tei:TEI

for $each in $docsToUpdate
    let $doc := doc(document-uri($each/root()))
    let $changesNew := <change></change>
    let $publStmtNew := local:getSenderTurned($doc//tei:correspAction[@type='sent'])
    let $adressat := local:getReceiverTurned($doc//tei:correspAction[@type='received'])
    let $datum := local:formatDate(local:getDate($doc//tei:correspAction[@type='sent']))
    let $name := local:turnName(local:getNameJoined($doc//tei:person))
    (:let $titleNew := concat('Brief vom ',$datum,' – ',$absender,' an ',$adressat):)
    let $titleNew := normalize-space($name)
    return
        replace value of node $titleOld with $titleNew
