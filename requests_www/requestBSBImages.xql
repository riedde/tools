xquery version "3.0";
(:
    JRA, Dennis Ried, 2020
    This script resolves BSB Image-URLs
:)
declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace functx = "http://www.functx.com";
declare namespace hc = "http://expath.org/ns/http-client";


declare function local:get-digitalization-as-html($url as xs:string, $library as xs:string) {
    
    if ($library = 'bsb')
    then (
            let $request := hc:send-request(<hc:request method="GET"/>, $url)
            let $imgLinkBSB := $request//xhtml:img[@alt="Image"]/@src/string()
            let $imgLinkJRA := concat('https://daten.digitale-sammlungen.de',$imgLinkBSB)
            return
                <img src="{$imgLinkJRA}" width="600" heigth="500"/>
         )
    else()
    
};

let $testLink := 'http://daten.digitale-sammlungen.de/bsb00117918/image_8'

return
    local:get-digitalization-as-html($testLink, 'bsb')