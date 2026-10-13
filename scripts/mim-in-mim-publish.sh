# Fetch libraries
if [ ! -d "../libs" ]; then
  mkdir -v ../libs
fi
if [ ! -f "../libs/rdf2rdf.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2rdf/releases/download/v1.6.0/rdf2rdf.jar -o ../libs/rdf2rdf.jar
fi

# Create MIM-diagram for CIM
java -jar ../libs/rdf2xml.jar ../mim-in-mim/mim-cim.ttl ../mim-in-mim/mim-cim.graphml mim2graphml.xsl add ../mim-in-mim/mim-cim-edited.graphml
