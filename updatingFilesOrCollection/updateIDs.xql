xquery version "1.0";
(:
    BauDi, dried, 2018
    >>>execute script at exist-db<<<
:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";

(:declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=yes indent=yes";:)

let $docsToUpdate := collection('../../contents/institutions?select=*.xml')/tei:TEI

for $doc in $docsToUpdate
    let $document := doc(document-uri($doc))/tei:TEI
    let $id := $document/@xml:id
    let $idNew := substring-before(substring-after(document-uri($doc),'institutions/'),'.xml')

return
    replace value of node $id with string($idNew)
