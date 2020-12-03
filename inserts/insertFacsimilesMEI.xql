xquery version "3.0";
(:
    JRA, dried, 2020
    insert facsimiles by csv
:)

declare default element namespace "http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com" at "../../portal-app/modules/functx.xqm";

let $csvInput := unparsed-text('../JRA_BSB_Images.csv')
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
                    

return
    for $row at $i in $xml-output//row[position() >= 2][position() != last()]
        let $docsToUpdate := collection("../../jraSources/data/documents/letters?select=*.xml;recurse=yes")//TEI[@xml:id = $row/cell[2]]
        let $docUri := document-uri($docsToUpdate/root())
        let $doc := doc($docUri)
        let $docIDRef := $row/cell[2]
        let $teiHeader := $doc//teiHeader
        let $facsimile := $doc//facsimile
        let $testHeader := exists($teiHeader)
        let $testFacs := exists($facsimile)
        let $tableRow := number($i) + 1
        
        let $surfaces := for $cell at $n in $row/cell[position() >= 3][. != '']
                            let $facsN := $n
                            let $url := $cell
                            
                            return
                               <surface n="{$facsN}">
                                 <graphic url="{$url}">
                                    <desc>
                                       <bibl>
                                          <publisher>D-Mbs</publisher>
                                          <availability>
                                             <licence/>
                                          </availability>
                                       </bibl>
                                    </desc>
                                 </graphic>
                              </surface>
       return
            if($testHeader = true() and $testFacs = false())
            then(insert nodes <facsimile>{$surfaces}</facsimile> after $teiHeader)
            
            else if($testHeader = true() and $testFacs = true())
            then(put(<doc uri="{$docUri}" id-ref="{$docIDRef}" n="{$tableRow}" header="{$teiHeader}" facsimile="{$testFacs}">{$surfaces}</doc>, concat('Fehler/false_row', $tableRow, '.xml')))
            
            else(put(<doc uri="{$docUri}" id-ref="{$docIDRef}" n="{$tableRow}" info="maybeDocNotFound">{$surfaces}</doc>, concat('Fehler/false_row', $tableRow, '.xml')))
