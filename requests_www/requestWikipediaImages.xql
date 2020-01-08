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


let $newInput := doc('/db/contents/jra/newInputWikiArtikel.xml')

let $data := <dataSets>
               {
                for $each at $n in $newInput//result
(:                    where $n > 0 and $n < 10:)
                    (:where $n < 500:) (:and $n < 1000:)
                    let $id := $each/id/@xml:id
                    let $url := concat('https://commons.wikimedia.org',$each/link)
                    let $request := http:send-request(<http:request href="{$url}" method="GET"/>)
                    let $data := if(exists($request//@status[string()='404'])) then() else(doc($url))
                    let $result := $data//meta[@property='og:image']/@content/string()
(:                    let $link := concat('https://de.wikipedia.org',$result):)
                    where $data
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