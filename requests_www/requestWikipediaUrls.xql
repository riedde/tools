xquery version "3.0";
(:
    BauDi, Dennis Ried, 2019
    This script tests, if a GND exists or not.
:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace functx = "http://www.functx.com";
declare namespace http = "http://expath.org/ns/http-client";


let $collection := collection('/db/contents/jra/persons')
let $gndNos := (:'118573527':) $collection//tei:TEI//tei:idno[@type="GND"] 

let $data := <dataSets>
               {
                for $item at $n in $gndNos
                    (:where $n < 500:) (:and $n < 1000:)
                    let $id := $item/ancestor::tei:TEI/@xml:id
                    let $url := concat('https://de.wikipedia.org/w/index.php?search=',normalize-space($item),'&amp;title=Spezial%3ASuche&amp;go=Artikel&amp;ns0=1')
                    (:let $request := http:send-request(<http:request href="{$url}" method="GET"/>)
                    let $test := exists($request//@status[string()='404']):)
                    let $data := (:if($test = false()) then( :) doc($url)(:) else():)
                    let $result := string-join($data//span[@class="searchmatch" and contains(.,$item)][1]/parent::div/parent::li[@class='mw-search-result']/div[1]/a/@href/string(),'|')
(:                    let $link := concat('https://de.wikipedia.org',$result):)
                    where $result
                    return
                        <result>
                            <id>{$id}</id>
                            <link>
                                {$result}
                            </link>
                       </result>
               }
              </dataSets>
return
     $data