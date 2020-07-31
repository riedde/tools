xquery version "3.0";

(:  Dennis Ried, 2020-07-31 :)

declare namespace mei="http://www.music-encoding.org/ns/mei";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace uuid = "java:java.util.UUID";
declare namespace pers="http://baumann-digital.de/ns/baudiPersons";

let $persNameList := doc('../../../BauDi/baudiPersons/temp/persNameListWithoutKey.xml')/pers:persons

for $person in $persNameList/pers:person[not(@xml:id)]

let $newPersID := concat('baudi-04-',substring(fn:string(uuid:randomUUID()), 1, 8))
let $name := $person/@name/string()
let $role := $person/@role/string()
let $sex := if($person/@sex)
            then($person/@sex/string())
            else if(contains($name,'Herr'))
            then ('male')
            else if(contains($name,'Frau'))
            then ('female')
            else('unknown')

let $result := <person xmlns="http://www.tei-c.org/ns/1.0" xml:id="{$newPersID}">
                  <persName>
                      {$name}
                  </persName>
                  <birth/>
                  <death/>
                  <faith key="unknown"/>
                  <education/>
                  <sex type="{$sex}"/>
                  <nationality key="de"/>
                  <occupation>{$role}</occupation>
                  <affiliation/>
                  <idno type="gnd"/>
                  <idno type="viaf"/>
                  <note/>
              </person>

return
    put($result,concat('../../../BauDi/baudiPersons/data/new/',$newPersID,'.xml'))