<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:m="http://www.loc.gov/mods/v3"
               xmlns:t="http://www.tei-c.org/ns/1.0"
               xmlns:f="http://www.w3.org/2005/xpath-functions"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:mix="http://www.loc.gov/mix/v10"
               xmlns:my="urn:my"
               version="3.0">

  
  <xsl:output method="text" />
  <!-- xsl:output method="xml" / -->

  <xsl:param name="sep_string"    select="'/'"/>
  <xsl:param name="result_object" select="'result_object'"/>
  <xsl:param name="base_uri"      select="'base_uri'"/>

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

      <!-- The Manifest if for one object, the source files here are
           sometimes containing multiple. We choose the first for
           the time being.  -->

      <xsl:for-each select="//m:mods[1]">

        <f:map>
          <f:array key="@context">
            <f:string>http://iiif.io/api/presentation/3/context.json</f:string>
            <f:map>
              <f:string key="schema">http://schema.org/</f:string>
              <f:string key="kb">http://kb.dk/vocabs/</f:string>
              <f:string key="relator">https://id.loc.gov/vocabulary/relators/</f:string>
            </f:map>
          </f:array>
          <f:string key="@type">Manifest</f:string>                

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

          <xsl:variable name="cataloging_language">
            <xsl:for-each select="m:recordInfo/m:languageOfCataloging/m:languageTerm[1]">
              <xsl:value-of select="."/>              
            </xsl:for-each>
          </xsl:variable>

          <f:string key="id">
            <xsl:choose>
              <xsl:when test="contains($record-id,'luftfo')">
                <xsl:value-of select="concat('http://www5.kb.dk/danmarksetfraluften/',$record-id)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('http://www5.kb.dk/',$record-id,'/en/')"/>
              </xsl:otherwise>
            </xsl:choose>
          </f:string>

          <xsl:call-template name="get-title">
            <xsl:with-param name="cataloging_language" select="$cataloging_language"/> 
          </xsl:call-template>

          <f:array key="behavior">
            <f:string>paged</f:string>
          </f:array>

          <xsl:variable name="resolution">
            <f:number key="height">
              <xsl:choose>
                <xsl:when test="m:extension/mix:mix/mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:imageHeight">
                  <xsl:value-of
            select="m:extension/mix:mix/mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:imageHeight"/>
                </xsl:when>
              <xsl:otherwise>3312</xsl:otherwise>
              </xsl:choose>
            </f:number>
            <f:number key="width">
              <xsl:choose>
                <xsl:when test="m:extension/mix:mix/mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:imageWidth">
                  <xsl:value-of
                      select="m:extension/mix:mix/mix:BasicImageInformation/mix:BasicImageCharacteristics/mix:imageWidth"/>
                </xsl:when>
                <xsl:otherwise>2080</xsl:otherwise>
              </xsl:choose>
            </f:number>
          </xsl:variable>

          <xsl:element name="f:array">
            <xsl:attribute name="key">items</xsl:attribute>
            <xsl:for-each select="m:relatedItem[m:identifier]">
              <xsl:call-template name="make_page_field">
                <xsl:with-param name="resolution" select="$resolution"/>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:element>

          
        </f:map>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:value-of select="f:xml-to-json($json)" />
    <!-- xsl:copy-of select="$json"/ -->
  </xsl:template>

  <xsl:template name="get-title">
    <xsl:param name="cataloging_language"/>

    <xsl:if test="m:titleInfo[not(@type)]">
      <f:map key="label">
        <xsl:for-each select="m:titleInfo[not(@type)]">
          <xsl:variable name="xml_lang">
            <xsl:choose>
              <xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="$cataloging_language"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:element name="f:array">
            <xsl:attribute name="key"><xsl:value-of select="$xml_lang"/></xsl:attribute>
            <xsl:for-each select="m:title">
              <f:string><xsl:value-of select="."/></f:string>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </f:map>
    </xsl:if>
 
  </xsl:template>

  <xsl:template name="make_page_field">
    <xsl:param name="resolution" select="''"/>
    
    <xsl:if test="m:identifier[string()]">

        <f:map>
          <f:string key="@type">Canvas</f:string>
          <xsl:call-template name="get-title"/>

          <f:string>
            <xsl:attribute name="key">id</xsl:attribute>
            <xsl:for-each select="m:identifier[@displayLabel='iiif'][string()]|m:identifier[contains(.,'.tif')]">
              <xsl:call-template name="find-pages"/>
            </xsl:for-each>
          </f:string>

          <xsl:copy-of select="$resolution"/>
          
        </f:map>
    </xsl:if>
    
    <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[@displayLabel='iiif'][string()]]">
      <xsl:call-template name="make_page_field">
        <xsl:with-param name="resolution" select="$resolution"/>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[contains(.,'.tif')]]">
      <xsl:call-template name="make_page_field">
        <xsl:with-param name="resolution" select="$resolution"/>
      </xsl:call-template>
    </xsl:for-each>
    
  </xsl:template>

    
  <xsl:template name="find-pages">

    <xsl:variable name="img">
      <xsl:choose>	 
	<xsl:when test="./@displayLabel='iiif'">
	  <xsl:value-of select="."/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:choose>
	    <xsl:when test="contains(.,'.tif')">
	      <xsl:value-of select="substring-before(.,'.tif')"/>
	    </xsl:when>
	    <xsl:when test="contains(.,'.TIF')">
	      <xsl:value-of select="substring-before(.,'.TIF')"/>
	    </xsl:when>
	    <xsl:when test="contains(.,'.jp2')">
	      <xsl:value-of select="substring-before(.,'.jp2')"/>
	    </xsl:when>
	  </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="string-length($img) &gt; 0">
      <xsl:choose>
	<xsl:when test="contains($img,'.json')">
	  <xsl:value-of select="$img"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('https://kb-images.kb.dk/',$img,'/info.json')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  
  
</xsl:transform>

          

