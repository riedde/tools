xquery version "3.0";

(:  Dennis Ried, 2020-07-31 :)

declare default element namespace "http://www.music-encoding.org/ns/mei";

let $collectionSources := collection('../../../BauDi/baudiSources/data/music?select=*.xml;recurse=yes')
let $collectionWorks := collection('../../../BauDi/baudiWorks/data?select=*.xml;recurse=yes')

for $work at $n in $collectionWorks
    let $workDoc := doc(document-uri($work))
    let $work := $workDoc/work
    let $workID := $work/@xml:id
    let $workTitleStmt := $work/title
    let $dedications := for $source in $collectionSources[//relation/@corresp = $workID]
                            let $dedication := $source//dedicatee/node()
                            where not(empty($dedication))
                            return
                                <titlePart type="dedication"
                                  xmlns="http://www.music-encoding.org/ns/mei">{$dedication}</titlePart>
    where $dedications
    return
        for $each in $dedications
            return
                insert node $each as last into $workTitleStmt