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

declare function local:getDate($date) {

    let $get := if(count($date/tei:date[matches(@type,'^editor')])=1)
                then(
                        if($date/tei:date[matches(@type,'^editor')]/@when)
                        then($date/tei:date[matches(@type,'^editor')]/@when/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@when-custom)
                        then($date/tei:date[matches(@type,'^editor')]/@when-custom/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@from)
                        then($date/tei:date[matches(@type,'^editor')]/@from/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@from-custom)
                        then($date/tei:date[matches(@type,'^editor')]/@from-custom/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@notBefore)
                        then($date/tei:date[matches(@type,'^editor')]/@notBefore/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@notAfter)
                        then($date/tei:date[matches(@type,'^editor')]/@notAfter/string())
                        else('0000-00-00')
                    )
                else if(count($date/tei:date[matches(@type,'^source')])=1)
                then(
                        if($date/tei:date[matches(@type,'^source')]/@when)
                        then($date/tei:date[matches(@type,'^source')]/@when/string())
                        else if($date/tei:date[matches(@type,'^source')]/@when-custom)
                        then($date/tei:date[matches(@type,'^source')]/@when-custom/string())
                        else if($date/tei:date[matches(@type,'^source')]/@from)
                        then($date/tei:date[matches(@type,'^source')]/@from/string())
                        else if($date/tei:date[matches(@type,'^source')]/@from-custom)
                        then($date/tei:date[matches(@type,'^source')]/@from-custom/string())
                        else if($date/tei:date[matches(@type,'^source')]/@notBefore)
                        then($date/tei:date[matches(@type,'^source')]/@notBefore/string())
                        else if($date/tei:date[matches(@type,'^source')]/@notAfter)
                        then($date/tei:date[matches(@type,'^source')]/@notAfter/string())
                        else('0000-00-00')
                    )
                else if(count($date/tei:date[matches(@type,'^editor') and @confidence])=1)
                then(
                       $date/tei:date[matches(@type,'^editor') and not(matches(@confidence,'0.5'))][@confidence = max(@confidence)]/@when
                    )
                else if(count($date/tei:date[matches(@type,'^source') and @confidence])=1)
                then(
                       $date/tei:date[matches(@type,'^source') and not(matches(@confidence,'0.5'))][@confidence = max(@confidence)]/@when
                    )
                    else if($date/tei:date[matches(@type,'^editor') and matches(@confidence,'0.5')])
                then(
                       $date/tei:date[matches(@type,'^editor') and matches(@confidence,'0.5')][1]/@when
                    )
                else if($date/tei:date[matches(@type,'^source') and matches(@confidence,'0.5')])
                then(
                       $date/tei:date[matches(@type,'^source') and matches(@confidence,'0.5')][1]/@when
                    )
                else if($date/tei:date[matches(@type,'^editor')])
                then(
                        if($date/tei:date[matches(@type,'^editor')]/@when)
                        then($date/tei:date[matches(@type,'^editor')][1]/@when/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@when-custom)
                        then($date/tei:date[matches(@type,'^editor')][1]/@when-custom/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@from)
                        then($date/tei:date[matches(@type,'^editor')][1]/@from/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@from-custom)
                        then($date/tei:date[matches(@type,'^editor')][1]/@from-custom/string())
                        else if($date/tei:date[matches(@type,'^editor')]/@notBefore)
                        then($date/tei:date[matches(@type,'^editor')][1]/@notBefore/string())
                        else('0000-00-00')
                    )
                else if(count($date/tei:date[matches(@type,'^source')]))
                then(
                        if($date/tei:date[matches(@type,'^source')]/@when)
                        then($date/tei:date[matches(@type,'^source')][1]/@when/string())
                        else if($date/tei:date[matches(@type,'^source')]/@when-custom)
                        then($date/tei:date[matches(@type,'^source')][1]/@when-custom/string())
                        else if($date/tei:date[matches(@type,'^source')]/@from)
                        then($date/tei:date[matches(@type,'^source')][1]/@from/string())
                        else if($date/tei:date[matches(@type,'^source')]/@from-custom)
                        then($date/tei:date[matches(@type,'^source')][1]/@from-custom/string())
                        else if($date/tei:date[matches(@type,'^source')]/@notBefore)
                        then($date/tei:date[matches(@type,'^source')][1]/@notBefore/string())
                        else if($date/tei:date[matches(@type,'^source')]/@notAfter)
                        then($date/tei:date[matches(@type,'^source')][1]/@notAfter/string())
                        else('0000-00-00')
                    )
                else('0000-00-00')
                
    return
        $get
};

declare function local:formatDate($dateRaw){
    let $date :=  if(string-length($dateRaw)=10 and not(contains($dateRaw,'00')))
                  then(format-date(xs:date($dateRaw),'[D]. [M,*-3]. [Y]','de',(),()))
                  else if($dateRaw =('0000','0000-00','0000-00-00'))
                  then('[undatiert]')
                  else if(string-length($dateRaw)=7 and not(contains($dateRaw,'00')))
                  then (concat(upper-case(substring(format-date(xs:date(concat($dateRaw,'-01')),'[Mn,*-3]. [Y]','de',(),()),1,1)),substring(format-date(xs:date(concat($dateRaw,'-01')),'[Mn,*-3]. [Y]','de',(),()),2)))
                  else if(contains($dateRaw,'0000-') and contains($dateRaw,'-00'))
                  then (concat(upper-case(substring(format-date(xs:date(replace(replace($dateRaw,'0000-','9999-'),'-00','-01')),'[Mn,*-3].','de',(),()),1,1)),substring(format-date(xs:date(replace(replace($dateRaw,'0000-','9999-'),'-00','-01')),'[Mn,*-3].','de',(),()),2)))
                  else if(starts-with($dateRaw,'0000-'))
                  then(concat(format-date(xs:date(replace($dateRaw,'0000-','9999-')),'[D]. ','de',(),()),upper-case(substring(format-date(xs:date(replace($dateRaw,'0000-','9999-')),'[Mn,*-3]. ','de',(),()),1,1)),substring(format-date(xs:date(replace($dateRaw,'0000-','9999-')),'[Mn,*-3].','de',(),()),2)))
                  else($dateRaw)

    let $replaceMay := replace($date,'Mai.','Mai')
    return
        $replaceMay
};

declare function local:turnName($nameToTurn){
let $nameTurned := if(contains($nameToTurn,'['))
                   then($nameToTurn)
                   else(concat(string-join(subsequence(tokenize($nameToTurn,', '),2),' '),
                   ' ',subsequence(tokenize($nameToTurn,', '),1,1)))
return
    $nameTurned
};

declare function local:getSenderTurned($correspActionSent){
let $sender := if($correspActionSent/tei:persName[3]/text())
                then(concat(local:turnName($correspActionSent/tei:persName[1]/text()[1]),'/', local:turnName($correspActionSent/tei:persName[2]/text()[1]),'/', local:turnName($correspActionSent/tei:persName[3]/text()[1]))) 
                else if($correspActionSent/tei:persName[2]/text())
                        then(concat(local:turnName($correspActionSent/tei:persName[1]/text()[1]),' und ',local:turnName($correspActionSent/tei:persName[2]/text()[1]))) 
                        else if($correspActionSent/tei:persName/text()) 
                             then(local:turnName($correspActionSent/tei:persName/text()[1])) 
                             else if($correspActionSent/tei:orgName/text()) 
                                  then($correspActionSent/tei:orgName/text()[1]) 
                                  else('[N.N.]')
  return
    $sender
};

declare function local:getReceiverTurned($correspActionReceived){

let $receiver := if($correspActionReceived/tei:persName[3]/text()) 
                                then(concat(local:turnName($correspActionReceived/tei:persName[1]/text()[1]),'/', local:turnName($correspActionReceived/tei:persName[2]/text()[1]),'/', local:turnName($correspActionReceived/tei:persName[3]/text()[1]))) 
                                else if($correspActionReceived/tei:persName[2]/text()) 
                                     then(concat(local:turnName($correspActionReceived/tei:persName[1]/text()[1]),' und ', local:turnName($correspActionReceived/tei:persName[2]/text()[1]))) 
                                     else if($correspActionReceived/tei:persName/text()) 
                                          then(local:turnName($correspActionReceived/tei:persName/text()[1])) 
                                          else if($correspActionReceived/tei:orgName/text()) 
                                               then($correspActionReceived/tei:orgName/text()[1]) 
                                               else ('[N.N.]')
 return
     $receiver
};

declare function local:getNameJoined($person){
 let $nameSurname := $person//tei:surname[matches(@type,"^used")][1]/text()[1]
 let $nameGenName := $person//tei:genName/text()
 let $nameSurnameFull := if($nameGenName)then(concat($nameSurname,' ',$nameGenName))else($nameSurname)
 let $nameForename := $person//tei:forename[matches(@type,"^used")][1]/text()[1]
 let $nameNameLink := $person//tei:nameLink[1]/text()[1]
 let $nameAddNameTitle := $person//tei:addName[matches(@type,"^title")][1]/text()[1]
 let $nameAddNameEpitet := $person//tei:addName[matches(@type,"^epithet")][1]/text()[1]
 let $nameForeFull := concat(if($nameForename)then(concat($nameForename,' '))else(),
                             if($nameAddNameEpitet)then(concat($nameAddNameEpitet,' '))else(),
                             if($nameNameLink)then(concat($nameNameLink,' '))else()
                             )
 let $pseudonym := if ($person//tei:forename[matches(@type,'^pseudonym')] or $person//tei:surname[matches(@type,'^pseudonym')])
                   then (concat($person//tei:forename[matches(@type,'^pseudonym')], ' ', $person//tei:surname[matches(@type,'^pseudonym')]))
                   else ()
 let $nameRoleName := $person//tei:roleName[1]/text()[1]
 let $nameAddNameNick := $person//tei:addName[matches(@type,"^nick")][1]/text()[1]
 let $nameUnspec := $person//tei:name[matches(@type,'^unspecified')][1]/text()[1]
 
 let $nameToJoin := if ($nameSurnameFull and $nameForeFull)
                    then (concat($nameSurnameFull,', ',$nameForeFull))
                    else if ($nameSurnameFull)
                    then ($nameSurnameFull)
                    else if($nameForeFull)
                    then ($nameForeFull)
                    else if($pseudonym)
                    then ($pseudonym)
                    else if($nameRoleName)
                    then ($nameRoleName)
                    else if ($nameAddNameNick)
                    then ($nameAddNameNick)
                    else if ($nameUnspec)
                    then ($nameUnspec)
                    else ('[N.N.]')
 
 return
    $nameToJoin
};

(:let $docsToUpdate := collection('../JRA/raff-contents/sources/documents/letters?select=*.xml')/tei:TEI:)
let $docsToUpdate := collection('../JRA/raff-contents/persons?select=*.xml')/tei:TEI

for $each in $docsToUpdate
    let $doc := doc(document-uri($each/root()))
    let $titleOld := $doc//tei:titleStmt/tei:title[1]
    let $absender := local:getSenderTurned($doc//tei:correspAction[@type='sent'])
    let $adressat := local:getReceiverTurned($doc//tei:correspAction[@type='received'])
    let $datum := local:formatDate(local:getDate($doc//tei:correspAction[@type='sent']))
    let $name := local:turnName(local:getNameJoined($doc//tei:person))
    (:let $titleNew := concat('Brief vom ',$datum,' – ',$absender,' an ',$adressat):)
    let $titleNew := normalize-space($name)
    return
        replace value of node $titleOld with $titleNew
(:$document:)

(:replace value of node $pageNumOld with $pageNumNew:) (:$docToUpdate//mei:facsimile/mei:surface/@n:)
    (:update insert $ preceding $editionDoc//work[@xml:id = $workID]/concordances//concordance[1]:)
    
    (:xmldb:store('xmldb:exist:///db/contents/edition-rwa/resources/xml/concs/rwaVol_II-8/', $concFileName, $concordance):)
