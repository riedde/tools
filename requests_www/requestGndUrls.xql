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
let $gndNos := $collection//tei:TEI//tei:idno[@type="GND"] (:'1091567573':)

let $data := <div class="container">
                <p>Fehlerhafte GND-Nummern</p>
                <table n="{count($gndNos)}">
                    <tr>
                        <td>Pos. (Abfrage)</td>
                        <td>Identifikationsnummer</td>
                        <td>GND (eingetragen)</td>
                        <td>URL</td>
                        <td>Test</td>
                    </tr>
                    {
                        for $item at $n in $gndNos
                            (: very slow, process packages with just 50 or 100 items :)
                            where $n > 1 and $n < 100
                            let $itemString := $item/normalize-space(string())
                            let $urlGND := concat('http://d-nb.info/gnd/',$itemString)
                            let $request := http:send-request(<http:request href="{$urlGND}" method="GET"/>)
                            let $test := exists($request//@status[string()='404'])
                                
                            where $test = true()
                            let $id := $item/ancestor::tei:TEI/@xml:id/string()
                            let $result := if($test = true())then('Existiert nicht!')else()
                                
                            order by $result,$id
                            return
                                (<tr>
                                    <td>{$n}</td>
                                    <td>{$id}</td>
                                    <td>{$itemString}</td>
                                    <td>{$urlGND}</td>
                                    <td>{$result}</td>
                                </tr>)
                    }
                </table>
             </div>
return
    $data