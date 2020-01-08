
xquery version "3.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace functx = "http://www.functx.com";

declare function functx:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;
 
declare function functx:distinct-deep
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;

let $eventCollection := collection('xmldb:exist:///db/contents/edition-rwa/texts/auffuehrungen')
let $events :=
    for $event in $eventCollection//tei:event
    group by $year := substring($event//tei:desc/tei:date/@when, 1, 4)
    order by $year
    return
        (<events year="{$year}" xmlns="http://www.tei-c.org/ns/1.0">
            {$event}
        </events>)

let $letters := 
        for $each in $eventCollection//tei:persName[ancestor::tei:work/@label or ancestor::tei:work[@genre and contains(tei:persName[@role = 'komponist'], 'Max Reger')]][not(. = '') and not(. = 'N. N.') and not(@role = 'komponist')]
        let $initial := if(number(substring($each,1,1))<=9)then('0')else(substring($each,1,1))
        group by $initial
        order by $initial
    return
        <li class="nav-item">
            <a class="nav-link active" id="home-tab" data-toggle="tab" href="{concat('#',$initial)}" role="tab" aria-controls="home" aria-selected="true">{$initial}</a>
        </li>

let $lettersContent := 
            for $each in $eventCollection//tei:persName[ancestor::tei:work/@label or ancestor::tei:work[@genre and contains(tei:persName[@role = 'komponist'], 'Max Reger')]][not(. = '') and not(. = 'N. N.') and not(@role = 'komponist')]
        let $initial := if(number(substring($each,1,1))<=9)then('0')else(substring($each,1,1))
        group by $initial
        order by $initial
                return
                <div xmlns="http://www.w3.org/1999/xhtml" class="tab-pane fade" id="{$initial}" role="tabpanel">
                    {$each}
                </div>
                    
            
return
    <div xmlns="http://www.w3.org/1999/xhtml">
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            {$letters}
        </ul>
        <div class="tab-content" id="myTabContent">
            {$lettersContent}
        </div>
    </div>
