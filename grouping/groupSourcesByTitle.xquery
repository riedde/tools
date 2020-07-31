xquery version "3.0";
(:
    BauDi, Dennis Ried, 2019
:)
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace functx = "http://www.functx.com";
declare namespace uuid = "java:java.util.UUID";


fn:put(<works xmlns="http://www.music-encoding.org/ns/mei">
{
let $sources := collection('../BauDi/baudi-contents/sources/music?select=*.xml;recurse=yes')

for $source in $sources
    let $name := $source//mei:fileDesc/mei:titleStmt/mei:title[@type='uniform' and @xml:lang='de']/mei:titlePart[@type='main']/normalize-space(text())
    let $workRelation := $source//mei:relation[@rel='isEmbodimentOf']
    let $workID := substring-after(substring-before($workRelation/@target,'.xml'),'works/')
    let $newID := concat('baudi-02-', substring(fn:string(uuid:randomUUID()), 1, 8))
    let $id := $source/mei:mei/@xml:id/string()
    let $lyricist := $source//mei:lyricist/normalize-space(string())
    group by $name
    order by $name ascending
    return
        <work id='{distinct-values(if($workRelation)then($workID)else($newID[1]))}' type='{if($workRelation)then('exists')else('new')}'>
            <title>{$name}</title>
            <lyricist>{distinct-values($lyricist)}</lyricist>
            {for $each in $id
                return
                    <sourceID>{$each}</sourceID>}
        </work>
}
</works>,'../BauDi/baudi-contents/works/workListToDo.xml')