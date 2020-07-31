xquery version "1.0";
(: 
    @author Nikolaos Beer
    @author Benjamin W. Bohl
    @author Dennis Ried
:)


declare default element namespace "http://www.edirom.de/ns/1.3";

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare namespace functx = "http://www.functx.com";


declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=yes indent=yes";

declare function functx:escape-for-regex
($arg as xs:string?) as xs:string {
    
    replace($arg,
    '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))', '\\$1')
};

declare function functx:substring-after-last
($arg as xs:string?,
$delim as xs:string) as xs:string {
    
    replace($arg, concat('^.*', functx:escape-for-regex($delim)), '')
};

(: TODO
 : 
 : declare parameters instead of variables to submit values externally
 : concat value to check against mei:relation/@target from workID or expression and respective workFile uri
 :  :)

(: not yet in use :)
(:let $defaultLang := request:get-parameter('lang', 'de')
let $expressionID := 'TODO to get concordance for specific expression':)

(: in use :)
(:let $workID := request:get-parameter('works', 'edirom_work_61b5ce81-4667-4f8a-8438-f7937e6d99db'):)

let $editionDoc := doc('/db/contents/edition-rwa/ediromEditions/rwaVol_II-7.xml')

for $work in $editionDoc//work[@xml:id = 'edirom_work_24e5a3a7-6af7-4bac-b075-16275883889a']
(:for $work in $editionDoc//work:)


let $workID := $work/@xml:id/fn:string()
let $workDoc := collection('/db/contents/edition-rwa/works')//id($workID)


let $workNavSourceColl := doc('/db/contents/edition-rwa/ediromEditions/rwaVol_II-7.xml')//work[./@xml:id = $workID]//navigatorCategory[./names//name[not(contains(., 'löschen'))]]//navigatorItem[contains(@targets, 'edirom_source_') | contains(@targets, 'rwa_edition_') | contains(@targets, 'rwa_muspr_') | contains(@targets, 'rwa_musms_')]

let $sourceColl := for $source in $workNavSourceColl
            let $sourceID := substring-before(functx:substring-after-last($source/@targets/fn:string(), '/'), '.xml')
            return
                collection('/db/contents/edition-rwa/sources/music')//mei:mei[@xml:id = $sourceID]

(:
let $sourceColl := xmldb:document('/db/contents/edition-rwa/sources/music/editions/II_08/rwa_edition_4019b13c-5cd7-4177-a739-97ea942a4eae.xml','/db/contents/edition-rwa/sources/music/prints/edirom_source_a2267960-b6bb-4718-958e-e3272d691235.xml','/db/contents/edition-rwa/sources/music/prints/edirom_source_9ed34ef7-088b-4b26-8f14-dc74b517d588.xml','/db/contents/edition-rwa/sources/music/prints/edirom_source_a1373019-17b6-4d26-8481-fdd11f6b13f3.xml')
:)
let $workSources := $sourceColl//mei:source[.//mei:relation/@target[contains(., concat($workID, '.xml#', $workID, '_exp1'))]]/root()/mei:mei

let $referenceSource := $workSources//mei:source[contains(.//mei:title, 'Werkausgabe') and contains(.//mei:relation/@target, concat($workID, '.xml#', $workID, '_exp1'))]/root()/mei:mei

let $plistPrefix := 'xmldb:exist:///db/contents/edition-rwa/sources/music/'

let $concFileName := concat('rwaMusicConc_', $workID, '.xml')

let $concordance := element concordance {
    attribute name {"Werkausgabe"},
    element names {
        element name {
            attribute xml:lang {'de'}, 'Werkausgabe'
        },
        element name {
            attribute xml:lang {'en'}, 'Reger Edition'
        }
    },
    element groups {
        attribute label {"Chor"},
        element names {
            element name {
                attribute xml:lang {'de'}, 'Chor'
            },
            element name {
                attribute xml:lang {'en'}, 'Choir'
            }
        },
        for $mdiv at $n in $referenceSource//mei:mdiv
(:        where $n = 11:)
        
        return
            element group {
                element names {
                    element name {
                        attribute xml:lang {'de'}, string($mdiv/@label)
                    },
                    element name {
                        attribute xml:lang {'en'},
                        if (contains($mdiv/@label, 'Nr.'))
                        then
                            concat('No. ', substring-after(string($mdiv/@label), 'Nr. '))
                        else
                            (string($mdiv/@label))
                    }
                },
                
                 element connections{
                                                attribute label {"Takt"},
                                                for $measure in $mdiv//mei:measure
                                                order by number($measure/@n)
                                                return
                                                    element connection{
                                                        attribute name {if ($measure/@label) then ($measure/@label) else ($measure/@n)},
                                                        attribute plist {
                                                            for $match in $sourceColl//mei:measure[ancestor::mei:mdiv[contains(@label, $mdiv/@label) and ./*[not(self::mei:parts)]] and @n = $measure/@n]
                                                            let $matchID := $match/@xml:id
                                                            let $sourceID := $match/ancestor::mei:mei/@xml:id
                                                            let $sourceTypeCollectionName := if ( $match/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusPr')
                                                            then ('prints')
                                                            else if ( $match/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusMs')
                                                            then ('manuscripts')
                                                            else if ( $match/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusEd')
                                                            then ('editions/II_07')
                                                            else ()
                                                            return concat($plistPrefix,$sourceTypeCollectionName,'/',$sourceID,'.xml#',$matchID)
                                                            ,
                                                            for $matchPart in $sourceColl//mei:part[1]//mei:measure[ancestor::mei:mdiv[contains(@label, $mdiv/@label) and ./*[self::mei:parts]] and @n = $measure/@n]
                                                            (:let $matchIDPart := $matchPart/@xml:id:)
                                                            let $matchPartmdivID := $matchPart/ancestor::mei:mdiv/@xml:id
                                                            let $matchPartMeasureNo := $matchPart/@n
                                                            let $sourceIDPart := $matchPart/ancestor::mei:mei/@xml:id
                                                            let $sourceTypeCollectionName := if ( $matchPart/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusPr')
                                                            then ('prints')
                                                            else if ( $matchPart/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusMs')
                                                            then ('manuscripts')
                                                            else if ( $matchPart/root()//mei:sourceDesc/mei:source/mei:classification/text() = 'MusEd')
                                                            then ('editions')
                                                            else ()
                                                            return concat($plistPrefix,$sourceTypeCollectionName,'/',$sourceIDPart,'.xml#measure_',$matchPartmdivID,'_',$matchPartMeasureNo) (: Fehler bei $matchPartmdivID :)
                                                        }
                                                    }
                                            }
            }
    }
}


return
    $concordance
    
    (:update insert $concordance preceding $editionDoc//work[@xml:id = $workID]/concordances//concordance[1]:)
    
    (:xmldb:store('xmldb:exist:///db/contents/edition-rwa/resources/xml/concs/rwaVol_II-8/', $concFileName, $concordance):)