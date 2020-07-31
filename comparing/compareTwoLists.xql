xquery version "3.0";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $each at $pos in tokenize(root/temp1,',')

return
    <entry xml:id="{$each}">
    {for $value at $i in tokenize(root/temp2,',')
    where $i = $pos
    return $value}
    </entry>