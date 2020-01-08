# -*- coding: utf-8 -*-

import uuid

# Number of IDs to be generated
generateID = 500

with open("generatedIDs.xml", "w") as file:

	file.write(str("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"))
	file.write(str("<generatedIDs>\n"))
	file.write(str("	<sources>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-01-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</sources>\n"))

   	file.write(str("	<works>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-02-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</works>\n"))

   	file.write(str("	<editions>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-03-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</editions>\n"))

   	file.write(str("	<persons>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-04-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</persons>\n"))

   	file.write(str("	<institutions>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-05-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</institutions>\n"))

   	file.write(str("	<places>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-06-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</places>\n"))

   	file.write(str("	<documentsPrim>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-07-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</documentsPrim>\n"))

   	file.write(str("	<images>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-08-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</images>\n"))

   	file.write(str("	<instruments>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-09-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</instruments>\n"))

   	file.write(str("	<documentsSek>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-10-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</documentsSek>\n"))
   	
   	file.write(str("	<mdiv>\n"))
    
    	for i in range(1, generateID+1):
        	if (i) % 1 == 0:
        		file.write("		<id n=\"{0}\"".format(i))
        		file.write(" xml:id=\"baudi-20-")
        		file.write(str(uuid.uuid4())[:8])
        		file.write("\"/>\n")
    
   	file.write(str("	</mdiv>\n"))

   	file.write(str("</generatedIDs>"))
