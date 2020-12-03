xquery version "3.0";

(:  Dennis Ried, 2020-07-31 :)

declare namespace mei="http://www.music-encoding.org/ns/mei";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx = "http://www.functx.com" at "../../../BauDi/baudiResources/data/libraries/functx.xqm";

let $collectionInstitutions := collection('../../../JRA/jraInstitutions/data?select=*.xml;recurse=yes')
let $collectionPersons := collection('../../../JRA/jraPersons/data?select=*.xml;recurse=yes')
let $collectionSources := collection('../../../JRA/jraSources/data?select=*.xml;recurse=yes')
let $collectionWorks := collection('../../../JRA/jraWorks/data?select=*.xml;recurse=yes')


let $collections := ($collectionInstitutions, $collectionPersons, $collectionSources, $collectionWorks)

let $collectionEntriesGrouped := 
    for $file in ($collections/tei:TEI, $collections/mei:mei)
        let $docUri := document-uri($file/root())
        let $id := $file/@xml:id/string()
        let $group := substring($id,1,1)
        let $entry := <entry id="{$id}"/>
        
        group by $group
        order by $group
        return
            <collection idStartsWith="{$group}">
                {
                    for $each in $entry
                        order by $each/@id
                        return
                            $each
                }
            </collection>

for $collectionGroup in $collectionEntriesGrouped
    let $collectionGroupInitial := $collectionGroup/@idStartsWith/string()
    return
        put($collectionGroup, concat('ignoreList-idStartsWith-', $collectionGroupInitial, '.xml'))
