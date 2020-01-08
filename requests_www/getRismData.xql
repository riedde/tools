xquery version "3.0";
(:
    BauDi, Dennis Ried, 2019
    Get data from RISM-OPAC as MARC21
:)
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace functx = "http://www.functx.com";

(: All RISM-IDs of Sources of Ludwig Baumann:)

let $rismIDs := ('453003872','453003873','453003874','453003875','453003876','453003935','453003936','453003937','453003938','453003939','453003940','453003941','453003942','453003943','453003944','453003947','453003948','453003949','453003950','453003951','453003952','453003953','453003956','453007174','453007175','453007177','453007283','453007288','453007291','453007333','453007343','453007347','453007349')

(: Find dataset :)
let $data := <dataSets n="{count($rismIDs)}">
               {
                for $item in $rismIDs
                    let $url := concat('https://opac.rism.info/id/rismid/',$item,'?format=marc')
                    let $data := doc($url)
                    return
                        $data
               }
              </dataSets>

(: Print Dataset :)
return
    fn:put($data,'requestedRismData.xml')