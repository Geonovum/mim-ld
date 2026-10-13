<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:mim="http://modellen.mim-standaard.nl/def/mim#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:output indent="yes"/>

<xsl:key name="resources" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="node-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="edge-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:edge" use="graphml:data[@key='d7']"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:variable name="slabel"><xsl:value-of select="replace(@rdf:about|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="mim:naam!=''"><xsl:value-of select="mim:naam"/></xsl:when>
    <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
    <xsl:when test="$slabel!=''"><xsl:value-of select="$slabel"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="exists(key('resources',@rdf:resource|rdf:nodeID))"><xsl:apply-templates select="key('resources',@rdf:resource|rdf:nodeID)" mode="label"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="replace(@rdf:resource|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="edge-label">
  <xsl:param name="label"/>
  <xsl:param name="ratio"/> <!-- 0.0 = start, 0.5 = center, 1.0 = end -->
  <xsl:param name="position"/> <!-- to the left/right of the arrow -->
  <xsl:param name="background"/> <!-- background color -->
  <y:EdgeLabel alignment="center" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" visible="true">
    <xsl:choose>
      <xsl:when test="$background!=''"><xsl:attribute name="backgroundColor"><xsl:value-of select="$background"/></xsl:attribute></xsl:when>
      <xsl:otherwise><xsl:attribute name="hasBackgroundColor">false</xsl:attribute></xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$label"/><y:LabelModel>
    <y:SmartEdgeLabelModel autoRotationEnabled="false" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel>
    <y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="1.5" distanceToCenter="false" position="{$position}" ratio="{$ratio}" segment="0"/></y:ModelParameter>
    <y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/>
  </y:EdgeLabel>
</xsl:template>

<xsl:template match="*" mode="property-label">
  <xsl:apply-templates select="." mode="label"/>
  <xsl:if test="mim:waardetype/@rdf:resource!=''">
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="mim:waardetype" mode="label"/>
  </xsl:if>
  <xsl:if test="mim:kardinaliteit!='' and mim:kardinaliteit!='1..1'">
    <xsl:text> [</xsl:text><xsl:value-of select="mim:kardinaliteit"/><xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:if test="mim:identificerend='true'">
    <xsl:text> {id}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <xsl:variable name="subject-uri" select="@rdf:about"/>
  <xsl:variable name="geo" select="key('node-geo',$subject-uri)"/>
  <xsl:if test="not($params='follow') or exists($geo/graphml:data)">
    <node id="{$subject-uri}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6">
  			<y:UMLClassNode>
          <xsl:variable name="geo" select="key('node-geo',@rdf:about)"/>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/*/y:Geometry)"><xsl:copy-of select="$geo/graphml:data/*/y:Geometry"/></xsl:when>
  				  <xsl:otherwise><y:Geometry height="90.0" width="80.0" x="637.0" y="277.0"/></xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/*/y:Fill)"><xsl:copy-of select="$geo/graphml:data/*/y:Fill"/></xsl:when>
            <xsl:otherwise><y:Fill color="#ffffc7" transparent="false"/></xsl:otherwise>
          </xsl:choose>
          <y:BorderStyle color="#000000" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="node_width" fontFamily="Dialog" fontSize="13" fontStyle="bold" hasBackgroundColor="false" hasLineColor="false" height="25" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="t" textColor="#000000" verticalTextPosition="bottom" visible="true" width="57.9931640625" x="33.50341796875" y="0.0">
  					<xsl:apply-templates select="." mode="label"/>
          </y:NodeLabel>
          <y:UML clipContent="true" constraint="" detailsColor="#000000" omitDetails="false" stereotype="{replace(rdf:type/@rdf:resource,'^.*(#|/)([^(#|/)]+)$','$2')}" use3DEffect="false">
            <y:AttributeLabel>
              <!-- Properties -->
    					<xsl:for-each select="key('resources',mim:attribuuttype/(@rdf:nodeID|@rdf:resource))">
                <xsl:apply-templates select="." mode="property-label"/><xsl:text>&#xa;</xsl:text>
    					</xsl:for-each>
            </y:AttributeLabel>
          </y:UML>
        </y:UMLClassNode>
  		</data>
  	</node>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Relatietype']" mode="edge">
  <xsl:variable name="statement-uri"><xsl:value-of select="@rdf:about"/></xsl:variable>
  <xsl:variable name="statement-geo" select="key('edge-geo',$statement-uri)"/>
  <!-- Voorlopig zoals in MIM 1.2, dus 1 propositie per relatietype -->
  <xsl:if test="not($params='follow') or exists($statement-geo/graphml:data)">
    <xsl:for-each select="key('resources',mim:propositie/(@rdf:resource|@rdf:nodeID))[1]">
      <xsl:variable name="subject-uri"><xsl:value-of select="key('resources',mim:bron/@rdf:resource)/mim:rolinvuller/@rdf:resource"/></xsl:variable>
      <xsl:variable name="object-uri"><xsl:value-of select="key('resources',mim:doel/@rdf:resource)/mim:rolinvuller/@rdf:resource"/></xsl:variable>
      <xsl:if test="exists(key('resources',$subject-uri)) and exists(key('resources',$object-uri))">
        <xsl:variable name="subject-geo" select="key('node-geo',$subject-uri)"/>
        <xsl:variable name="object-geo" select="key('node-geo',$object-uri)"/>
        <xsl:if test="not($params='follow') or (exists($subject-geo/graphml:data) and exists($object-geo/graphml:data))">
          <!-- Associations -->
          <edge source="{$subject-uri}" target="{$object-uri}">
            <data key="d7"><xsl:value-of select="$statement-uri"/></data>
            <data key="d8"><xsl:value-of select="$statement-uri"/></data> <!--Which to use? Was: property-uri -->
      			<data key="d10">
      				<y:PolyLineEdge>
                <xsl:copy-of select="$statement-geo/graphml:data/y:PolyLineEdge/y:Path"/>
      					<y:LineStyle color="#000000" type="line" width="1.0"/>
                <xsl:variable name="source-arrow">
                  <xsl:choose>
                    <xsl:when test="key('resources',mim:bron/@rdf:resource)/mim:aggregatietype/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Compositie'">diamond</xsl:when>
                    <xsl:when test="key('resources',mim:bron/@rdf:resource)/mim:aggregatietype/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Aggregatie'">white_diamond</xsl:when>
                    <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="target-arrow">
                  <xsl:choose>
                    <xsl:when test="mim:unidirectioneel='true'">plain</xsl:when>
                    <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
      					<y:Arrows source="{$source-arrow}" target="{$target-arrow}"/>
                <xsl:if test="mim:verwoording!=''">
                  <xsl:call-template name="edge-label">
                    <xsl:with-param name="label"><xsl:value-of select="mim:verwoording"/></xsl:with-param>
                    <xsl:with-param name="ratio">0.5</xsl:with-param>
                    <xsl:with-param name="position">left</xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="edge-label">
                  <xsl:with-param name="label">«Relatietype»</xsl:with-param>
                  <xsl:with-param name="ratio">0.5</xsl:with-param>
                  <xsl:with-param name="position">right</xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select="key('resources',mim:bron/@rdf:resource)">
                  <xsl:if test="mim:naam!='' or rdfs:label!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                      <xsl:with-param name="ratio">0.0</xsl:with-param>
                      <xsl:with-param name="position">left</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="mim:kardinaliteit!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                      <xsl:with-param name="ratio">0.0</xsl:with-param>
                      <xsl:with-param name="position">right</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="key('resources',mim:doel/@rdf:resource)">
                  <xsl:if test="mim:naam!='' or rdfs:label!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label">
                        <xsl:apply-templates select="." mode="label"/>
                        <xsl:if test="mim:identificerend='true'"> {id}</xsl:if>
                      </xsl:with-param>
                      <xsl:with-param name="ratio">1.0</xsl:with-param>
                      <xsl:with-param name="position">left</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="mim:kardinaliteit!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                      <xsl:with-param name="ratio">1.0</xsl:with-param>
                      <xsl:with-param name="position">right</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
      					<y:BendStyle smoothed="false"/>
      				</y:PolyLineEdge>
      			</data>
      		</edge>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
	<graphml>
		<key attr.name="url" attr.type="string" for="node" id="d3"/>
    <key attr.name="statement-url" attr.type="string" for="edge" id="d7"/>
    <key attr.name="url" attr.type="string" for="edge" id="d8"/>
		<key for="node" id="d6" yfiles.type="nodegraphics"/>
		<key for="edge" id="d10" yfiles.type="edgegraphics"/>
		<graph id="G" edgedefault="directed">
			<xsl:apply-templates select="ROOT/rdf:RDF"/>
		</graph>
	</graphml>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Objecttype']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Relatietype']" mode="edge"/>
</xsl:template>

</xsl:stylesheet>
