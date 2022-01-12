<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:m="http://www.loc.gov/mods/v3"
               xmlns:t="http://www.tei-c.org/ns/1.0"
               xmlns:f="http://www.w3.org/2005/xpath-functions"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:my="urn:my"
               version="3.0">

  
  <xsl:output method="text" />
  <!-- xsl:output method="xml" / -->

  <xsl:param name="sep_string" select="'/'"/>

  <xsl:variable name="roles">
    <roles>
      <role key="act" href="https://schema.org/actor">actor</role>
      <role key="art" href="https://schema.org/artist ">artist</role>
      <role key="aut" href="https://schema.org/author">author</role>
      <role key="cre" href="https://schema.org/creator">creator</role>
      <role key="creator" href="https://schema.org/creator">creator</role>
      <role key="ctb" href="https://schema.org/contributor">contributor</role>
      <role key="rcp" href="https://schema.org/recipient">recipient</role>
      <role key="scr" href="http://id.loc.gov/vocabulary/relators/art">relator:scr</role>
      <role key="src" href="http://id.loc.gov/vocabulary/relators/art">relator:scr</role>
      <role key="trl" href="https://schema.org/translator">translator</role>
      <role key="pat" href="https://schema.org/funder">funder</role>
      <role key="prt" href="http://id.loc.gov/vocabulary/relators/art">relator:prt</role>
    </roles>
  </xsl:variable>
  
  <xsl:template match="/">
    
    <xsl:variable name="json">

      <f:map>
        <f:string key="@context">http://schema.org/</f:string>
        <f:string key="@type">DataFeed</f:string>
        <f:array  key="dataFeedElement">
          <xsl:for-each select="//m:mods">

            <xsl:variable name="cataloging_language">
              <xsl:for-each select="m:recordInfo/m:languageOfCataloging/m:languageTerm[1]">
                <xsl:value-of select="."/>              
              </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="dom" select="."/>

            <xsl:variable name="record-id-in">
              <xsl:choose>
                <xsl:when test="processing-instruction('cobject_id')">
                  <xsl:value-of select="replace(processing-instruction('cobject_id'),'^/','')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="replace(m:recordInfo/m:recordIdentifier,'^/','')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="record-id">
              <xsl:value-of select="replace($record-id-in,'/',$sep_string,'s')"/>
            </xsl:variable>

            <xsl:variable name="output_data">
              <f:map>

              </f:map>
            </xsl:variable>
          </xsl:for-each>
        </f:array>
      </f:map>
    </xsl:variable>
    <xsl:value-of select="f:xml-to-json($json)"/>
    <!-- xsl:copy-of select="$json"/ -->
  </xsl:template>
</xsl:transform>

          

