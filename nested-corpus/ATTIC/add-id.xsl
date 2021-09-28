<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	       xmlns:t="http://www.tei-c.org/ns/1.0"
	       xmlns="http://www.tei-c.org/ns/1.0"
               xmlns:a="http://www.loc.gov/standards/alto/ns-v3#"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:atom="http://www.w3.org/2005/Atom"
               xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
               xmlns:georss="http://www.georss.org/georss"
               xmlns:md="http://www.loc.gov/mods/v3"
               xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:mix="http://www.loc.gov/mix/v10"
	       exclude-result-prefixes="t xlink h a"
	       version="1.0">

  <xsl:output
      method="xml"
      encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name(.)}">
      <xsl:if test="not(@xml:id)">
	<xsl:attribute name="xml:id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
 </xsl:template>

 <xsl:template match="@*">
   <xsl:variable name="attribute" select="name(.)"/>
   <xsl:if test="not(name(.) = 'id')">
     <xsl:attribute name="{$attribute}">
       <xsl:value-of select="."/>
     </xsl:attribute>
   </xsl:if>
 </xsl:template>

</xsl:transform>
