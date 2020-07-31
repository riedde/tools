xquery version "3.0";

(:  Dennis Ried, 2020-07-31 :)

declare namespace mei="http://www.music-encoding.org/ns/mei";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace functx = "http://www.functx.com" at "../../../BauDi/baudiResources/data/libraries/functx.xqm";

let $collectionSources := collection('../../../BauDi/baudiSources/data?select=*.xml;recurse=yes')
let $collectionWorks := collection('../../../BauDi/baudiWorks/data?select=*.xml;recurse=yes')
let $collection := ($collectionWorks, $collectionSources)

let $persNames := ($collection//tei:persName[not(@key)],$collection//mei:persName[not(@auth)])

let $results := for $persName in $persNames
                    let $name := normalize-space(string-join($persName/string(),' '))
                    let $role := $persName/@role
                    
                    where $name !=''
                    order by $name
                    return
                        <person name="{$name}" role="{$role}" xmlns="http://baumann-digital.de/ns/baudiPersons"/>


return
    put(<persons xmlns="http://baumann-digital.de/ns/baudiPersons" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xlink="http://www.w3.org/1999/xlink">{functx:distinct-deep($results)}</persons>,'../../../BauDi/baudiPersons/temp/persNameListWithoutKey.xml')


