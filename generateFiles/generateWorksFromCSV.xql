xquery version "3.0";

(:  convert csv to xml
    Dennis Ried, 2020-07-10 :)
declare default element namespace "http://www.music-encoding.org/ns/mei";
declare namespace uuid = "java:java.util.UUID";
declare namespace mei = "http://www.music-encoding.org/ns/mei";

import module namespace functx = "http://www.functx.com" at "../../BauDi/baudiResources/data/libraries/functx.xqm";



let $csvInput := unparsed-text('../../BauDi/baudiWorks/data/HochsteinSeebold.csv')
let $lines := functx:lines($csvInput)

let $xml-output :=  <table>
                        {
                            for $line at $i in $lines
                               let $cells := tokenize($line, ';')
                               return
                                   <row n="{$i}">
                                       {
                                           for $cell at $n in $cells
                                           return
                                           <cell n="{$n}">{normalize-space($cell)}</cell>
                                       }
                                   </row>
                        }
                    </table>
   

for $row in $xml-output//row
    let $fassung := if($row/cell[2]/string() !='')then(true())else(false())
    let $IdPartString := substring(fn:string(uuid:randomUUID()), 1, 8)
    let $composer := if($row/cell[7]/string() = 'Ludwig Baumann')
                     then(<persName auth="baudi-04-5e3ed698">Ludwig Baumann</persName>)
                     else($row/cell[7]/string())
    let $arranger := if($row/cell[9]/string() = 'Ludwig Baumann')
                     then(<persName auth="baudi-04-5e3ed698">Ludwig Baumann</persName>)
                     else()
    let $lyricist := if(contains($row/cell[8]/string(),'lied'))
                     then($row/cell[8]/string())
                     else(<persName>{$row/cell[8]/string()}</persName>)
    let $MeterCount := $row/cell[12]/string()
    let $MeterUnit := $row/cell[13]/string()
    let $MeterSym := if($row/cell[14]/string() = 'true') then('common') else('')
    
    let $work := <work xmlns="http://www.music-encoding.org/ns/mei" status="created" xml:id="baudi-02-{$IdPartString}">
                     <identifier type="baudi-copy">{$row/cell[21]/string()}</identifier>
                     <title type="uniform" xml:id="baudi-02-{$IdPartString}-title">
                         <titlePart type="main" xml:id="baudi-02-{$IdPartString}-titleMain">{$row/cell[3]/string()}</titlePart>
                         {if($row/cell[5]/string() !='')
                          then(<titlePart type="number" auth="opus">{$row/cell[5]/string()}</titlePart>)
                          else()}
                         <titlePart type="mainSort" xml:id="baudi-02-{$IdPartString}-titleMainSort">{$row/cell[4]/string()}</titlePart>
                         <titlePart type="subordinate" xml:id="baudi-02-{$IdPartString}-titleSub">{$row/cell[6]/string()}</titlePart>
                         <titlePart type="perfmedium" xml:id="baudi-02-{$IdPartString}-titleDesc"/>
                     </title>
                     <composer xml:id="baudi-02-{$IdPartString}-composer">
                         {$composer}
                     </composer>
                     <arranger xml:id="baudi-02-{$IdPartString}-arranger">
                        {$arranger}
                     </arranger>
                     <lyricist xml:id="baudi-02-{$IdPartString}-lyricist">
                        {$lyricist}
                     </lyricist>
                     <key pname="{functx:substring-before-if-contains($row/cell[10]/string(),'-')}" accid="{if(contains($row/cell[10]/string(),'-'))then('f')else()}" mode="{$row/cell[11]/string()}"/>
                     {if ($MeterSym = '')
        				then (
        				<meter
        					count="{$MeterCount}"
        					unit="{$MeterUnit}"/>)
        					else (<meter
        					count="{$MeterCount}"
        					unit="{$MeterUnit}" sym="{$MeterSym}"/>)
        				}
                     <tempo>{$row/cell[24]/string()}</tempo>
                     <incip/>
                     <creation>{if($row/cell[19]/string() !='')then(concat('Erschienen ',$row/cell[19]/string()))else()}</creation>
                     <history/>
                     <langUsage>
                         <head>In der Quelle verwendete Sprache(n)</head>
                         <language auth="de"/>
                     </langUsage>
                     <perfMedium>
                        <perfResList auth="{if($row/cell[29]/string()='S,A,T,B')
                                            then('choirMixed')
                                            else if($row/cell[29]/string()='T,T,B,B')
                                            then('choirMen')
                                            else('choir')}">
                         {for $perfMedium in tokenize($row/cell[29],',')
                            let $auth := switch($perfMedium)
                                          case 'S' return 'soprano'
                                          case 'A' return 'alto'
                                          case 'T' return 'tenor'
                                          case 'B' return 'bass'
                                          case 'Org' return 'organ'
                                          default return $perfMedium
                            return
                                <perfRes auth="{$auth}"/>}
                        </perfResList>
                     </perfMedium>
                     <audience/>
                     <contents>
                         <contentItem/>
                     </contents>
                     <context/>
                     <notesStmt>
                        {if($row/cell[23]/string())
                        then(<annot type="perf">{$row/cell[23]/string()}</annot>)
                        else()}
                        <annot type="internal">{$row/cell[22]/string()}</annot>
                     </notesStmt>
                     <classification>
                         <head/>
                         <termList>
                             <term type="workGroup" subtype="vocal"/>
                             <term type="genre" subtype="choir"/>
                         </termList>
                     </classification>
                     <!--<relationList>
                         <relation rel="hasEmbodiment"/>
                     </relationList>-->
                 </work>
                 
    where $fassung = false()
        return
            put($work,concat('../../BauDi/baudiWorks/data/hochstein/baudi-02-', $IdPartString, '.xml'))

