xquery version "3.0";

declare namespace mei = "http://www.music-encoding.org/ns/mei";

(:let $sourceCollection := collection('xmldb:exist:///db/contents/edition-rwa/sources/music')

for $source in $sourceCollection
where $source//mei:parts
    return
   $source:)

let $sourceURI := 'xmldb:exist:///db/contents/sources/music/baudi-01-8a00c113.xml'  (: '../../sources/music/baudi-01-5f9f9f33.xml' :)
let $doc := doc($sourceURI)
let $mdivSearch := ('Vorspiel','I. Chor','II. Chor','III. Rezitativ','IV. Arie','V. Chor','VI. Rezitativ','VII. Chor','VIII. Chor','IX. Rezitativ','X. Chor')
let $instrVoiceLabels := for $instrVoice in $doc//mei:instrVoice
let $instrVoiceLabel := $instrVoice/@label
return
    $instrVoiceLabel
let $instrVoiceIDs := for $instrVoice in $doc//mei:instrVoice
let $instrVoiceID := $instrVoice/@xml:id
return
    $instrVoiceID

return
    
    <body>
        {
            for $mdiv in $mdivSearch
            let $mdviID := concat('baudi-10-', substring(util:uuid(),1,8))
            let $mdivs := $doc//mei:mdiv[substring-after(./@label, ' | ') = $mdiv]
            (:let $mdivs := $doc//mei:mdiv/@label:)
            return
                
                <mdiv
                    xml:id="{$mdviID}"
                    label="{$mdiv}">
                    <parts>
                        {
                            for $instrVoiceLabel at $pos in $instrVoiceLabels
                            let $sectionSearch := $mdivs[substring-before(@label, ' | ') = $instrVoiceLabel]//mei:section
(:                            let $sectionSearch := $mdivs//mei:section:)
                            return
                                <part
                                    xml:id="{concat('baudi-11-', substring(util:uuid(),1,8))}"
                                    label="{$instrVoiceLabel}">
                                    <staffDef
                                        decls="{concat('#', $instrVoiceIDs[$pos])}"/>
                                    {$sectionSearch}
                                </part>
                        }
                    </parts>
                </mdiv>
        }
    </body>