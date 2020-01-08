xquery version "1.0";
(:
    BauDi, Dennis Ried, 2019
    This script uses the GND-No-Search-Function of VIAF to get the VIAF-No
:)
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace functx = "http://www.functx.com";
declare namespace http = "http://expath.org/ns/http-client";
declare namespace ns1="http://viaf.org/viaf/terms#";

let $gndNos := ('1091567573','1013411188')

let $data := <dataSets n="{count($gndNos)}">{

                for $item at $n in $gndNos
                    (:where $n = 2:)
                    let $url := concat('https://viaf.org/viaf/sourceID/DNB%7C',$item)
                    let $request := http:send-request(<http:request href="{$url}" method="GET"/>)
                    let $test := exists($request//@status[string()='404'])
                    let $data :=  if($test = true()) then('No Entry at VIAF') else($request//ns1:viafID/string()) 
                    return
                        <dataSet n="{$n}">
                            <gnd>{$item}</gnd>
                            <viaf>{$data}</viaf>
                        </dataSet>
                         
               }
              </dataSets>
(: https://viaf.org//viaf/sourceID/DNB%7C1091567573 :)
return
    $data