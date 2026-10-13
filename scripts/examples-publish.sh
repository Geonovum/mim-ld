# Fetch libraries
if [ ! -d "../libs" ]; then
  mkdir -v ../libs
fi
if [ ! -f "../libs/rdf2xml.jar" ]; then
  curl -L -k https://github.com/architolk/rdf2xml/releases/download/v1.2.1/rdf2xml.jar -o ../libs/rdf2xml.jar
fi

# Convert
java -jar ../libs/rdf2xml.jar ../example/mim.ttl ../example/mim.graphml mim2graphml.xsl # add ../example/mim-edited.graphml
