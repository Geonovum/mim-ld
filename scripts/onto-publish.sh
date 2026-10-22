# Fetch libraries
if [ ! -d "../libs" ]; then
  mkdir -v ../libs
fi
if [ ! -f "../libs/rdf2rdf.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2rdf/releases/download/v1.6.0/rdf2rdf.jar -o ../libs/rdf2rdf.jar
fi
if [ ! -f "../libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o ../libs/rdf2xml.jar
fi
if [ ! -f "../libs/rdf2graphml.xsl" ]; then
  curl -L -k https://raw.githubusercontent.com/architolk/rdf2xml/refs/heads/main/rdf2graphml.xsl -o ../libs/rdf2graphml.xsl
fi

# Create diagram for CIM metamodel
java -jar ../libs/rdf2rdf.jar -i ../model/mim-ontologie.ttl -i2 ../model/mim-sh-cim.ttl -o ../model/mim-cim.ttl
java -jar ../libs/rdf2xml.jar ../model/mim-cim.ttl ../model/mim-cim.graphml ../libs/rdf2graphml.xsl add ../model/mim-cim-edited.graphml
rm ../model/mim-cim.ttl

# Create diagram for CIM metamodel (alternatief met Fenomeen)
java -jar ../libs/rdf2rdf.jar -i ../model/mim-ontologie.ttl -i2 ../model/mim-sh-cim-fenomeen.ttl -o ../model/mim-cim.ttl
java -jar ../libs/rdf2xml.jar ../model/mim-cim.ttl ../model/mim-cim-fenomeen.graphml ../libs/rdf2graphml.xsl add ../model/mim-cim-edited.graphml
rm ../model/mim-cim.ttl
