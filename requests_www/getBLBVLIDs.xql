xquery version "3.1";
(:
    JRA, Dennis Ried, 2020
    This script collects BLB Image-URLs
    must be executed by eXist-db
:)

declare namespace functx = "http://www.functx.com"; (:at "../../../BauDi/baudiResources/data/libraries/functx.xqm";:)

declare namespace mei = "http://www.music-encoding.org/ns/mei";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace http = "http://expath.org/ns/http-client";


(:declare function local:get-digitalization-as-html($url as xs:string) {
    
    let $request := hc:send-request(<hc:request method="GET"/>, $url)
    let $imgLinkBSB := $request//xhtml:img[@alt="Image"]/@src/string()
    let $imgLinkJRA := concat('https://daten.digitale-sammlungen.de',$imgLinkBSB)
    return
        <img src="{$imgLinkJRA}" width="600" heigth="500"/>
    
};:)

let $digiPages := (doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=101'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=201'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=301'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=401'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=501'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=601'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=701'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=801'),
                   doc('https://digital.blb-karlsruhe.de/Musikalien/nav/index/name?max=100&amp;facets=name%3D%22Baumann%2C%20Ludwig%22&amp;offset=901'))

let $items := for $item at $i in $digiPages//li[@class='tableContainer']
(:                where $i < 3:)
                let $link := $item//div[@class='title']/a/@href/string()
                let $VLID := substring-after($link,'/titleinfo/')
                let $linkFull := concat('https://digital.blb-karlsruhe.de',$link)
                
                return
                    <blb-item vlid="{$VLID}" uri="{$linkFull}"/>

let $images  := for $item at $i in $items
                     let $digiPage := doc($item/@uri)
                     let $title := $digiPage//tr[@id="mods_titleInfoTitleNotType"]//div[@class="valueDiv"]/text()
                     let $manifest := doc(concat('https://digital.blb-karlsruhe.de/i3f/v20/', $item/@vlid/string(), '?xml'))
                     let $rootWork := $manifest/row
                     let $workTitle := $rootWork/@ot_caption
                     let $result := for $row in $rootWork//row
                                      let $contentItems := $row[not(contains(@ot_caption,'Seite'))]
                                      
                                      for $contentItem in $contentItems
                                        let $contentItemVLID := $contentItem/@ot_id
                                        let $contentItemTitle := $contentItem/@ot_caption
                                        let $images := for $image in $contentItem/row[contains(@oi_ident,'/fragment/')]
                                                        let $imageVLID := $image/@ot_id
                                                        let $width := $image/@ol_imgwidth
                                                        let $height := $image/@ol_imgheight
                                                        let $page := $image/@pos
                                                        return
                                                          <image image-no="{$page}" vlid="{$imageVLID}" width="{$width}" height="{$height}"/>
                                     return
                                        <contentItem vlid="{$contentItemVLID}" title="{$contentItemTitle}">{$images}</contentItem>
                     
                     return
                         <work title="{$workTitle}">
                            {$result}
                        </work>

return
    $images
