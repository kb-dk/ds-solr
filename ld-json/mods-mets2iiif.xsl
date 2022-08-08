<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:md="http://www.loc.gov/mods/v3"
               xmlns:m="http://www.loc.gov/METS/"
               xmlns:t="http://www.tei-c.org/ns/1.0"
               xmlns:f="http://www.w3.org/2005/xpath-functions"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:mix="http://www.loc.gov/mix/v10"
               xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns:my="urn:my"
               exclude-result-prefixes="m md t h xs xsl mix my xlink"
               version="3.0">

  
  <xsl:output method="text"/>
  <!-- xsl:output method="xml" / -->

  <xsl:param name="sep_string"    select="'/'"/>
  <xsl:param name="result_object" select="'result_object'"/>
  <xsl:param name="base_uri"      select="'base_uri'"/>

  <xsl:variable name="dom" select="/"/>
  
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

      <f:map>
        <f:string key="@context">http://iiif.io/api/presentation/3/context.json</f:string>

        <f:string key="type">Manifest</f:string>                

      
        <xsl:apply-templates select="m:mets/m:structMap[@type='physical']"/>
        
      </f:map>

    </xsl:variable>
    
    <xsl:value-of select="f:xml-to-json($json)" />
    <!-- xsl:copy-of select="$json"/ -->
        
  </xsl:template>

  <xsl:template match="m:structMap">

    <xsl:variable name="mid" select="m:div/@DMDID"/>
    <xsl:apply-templates select="$dom//m:dmdSec[@ID=$mid]//md:mods"/>

    <xsl:element name="f:array">
      <xsl:attribute name="key">items</xsl:attribute>
      <xsl:apply-templates select="m:div"/>
    </xsl:element>
  
  </xsl:template>
  
  <xsl:template match="m:div">
    <f:map>
      <xsl:variable name="fileid"><xsl:value-of select="m:fptr/@FILEID"/></xsl:variable>
      <xsl:if test="$dom//m:file[@ID=$fileid]/m:FLocat/@xlink:href">
        <xsl:element name="f:array">
          <xsl:attribute name="key">items</xsl:attribute>
          <f:string>
            <xsl:value-of select="$dom//m:file[@ID=$fileid]/m:FLocat/@xlink:href"/>
          </f:string>
        </xsl:element>
      </xsl:if>
    </f:map>
    <xsl:apply-templates select="m:div"/>
  </xsl:template>
  
  <xsl:template match="md:mods">

    <xsl:variable name="record-id-in">
      <xsl:choose>
        <xsl:when test="processing-instruction('cobject_id')">
          <xsl:value-of select="replace(processing-instruction('cobject_id'),'^/','')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="replace(md:recordInfo/md:recordIdentifier,'^/','')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="record-id">
      <xsl:value-of select="replace($record-id-in,'/',$sep_string,'s')"/>
    </xsl:variable>

    <xsl:variable name="cataloging_language">eng</xsl:variable>
    
    <f:string key="id">
      <xsl:value-of select="concat($base_uri,'/',$result_object)"/>
    </f:string>

    <xsl:call-template name="get-title">
      <xsl:with-param name="cataloging_language" select="$cataloging_language"/>
      <xsl:with-param name="dom"                 select="."/> 
    </xsl:call-template>

    <f:array key="behavior">
      <f:string>paged</f:string>
    </f:array>

    <f:string key="viewingDirection">
      <xsl:choose>
        <xsl:when test="contains(md:physicalDescription/md:note[@type='pageOrientation'][1],'RTL')">right-to-left</xsl:when>
        <xsl:otherwise>left-to-right</xsl:otherwise>
      </xsl:choose>
    </f:string>


  </xsl:template>

  <xsl:template name="get-title">
    <xsl:param name="cataloging_language"/>
    <xsl:param name="dom"  />
    <!-- xsl:variable name="dom" select="."/ -->

    <xsl:choose>
      <xsl:when test="md:titleInfo[not(type)]">
        <f:map key="label">
          <xsl:variable name="languages" as="xs:string *">
            <xsl:for-each select="md:titleInfo[not(type)]">
              <xsl:choose>
                <xsl:when test="@xml:lang"><xsl:value-of select="@xml:lang/string()"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$cataloging_language"/></xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:variable>
          <xsl:for-each select="distinct-values($languages)" >
            <xsl:variable name="xml_lang" select="."/>
            <xsl:element name="f:array">
              <xsl:attribute name="key"><xsl:value-of select="$xml_lang"/></xsl:attribute>
              <xsl:for-each select="$dom/md:titleInfo[@xml:lang=$xml_lang]">            
                <xsl:for-each select="md:title">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </f:map>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="make_page_field">
    <!-- xsl:param name="resolution" select="''"/ -->
    <xsl:param name="dom"        select="''"/>




    <xsl:if test="md:identifier[string()]">
        <f:map>
          <f:string key="type">Canvas</f:string>
          <xsl:call-template name="get-title">
            <xsl:with-param name="dom"  select="$dom"/>
          </xsl:call-template>

          <xsl:variable name="id_string">
            <xsl:for-each select="md:identifier[@displayLabel='iiif'][string()]|md:identifier[contains(.,'.tif')]">
              <xsl:call-template name="find-pages"/>
            </xsl:for-each>
          </xsl:variable>
          
          <f:string>
            <xsl:attribute name="key">id</xsl:attribute>
            <xsl:for-each select="md:identifier[@displayLabel='iiif'][string()]|md:identifier[contains(.,'.tif')]">
              <xsl:call-template name="find-pages"/>
            </xsl:for-each>
          </f:string>
        
        </f:map>
    </xsl:if>
    
  </xsl:template>

  <xsl:template name="make_hierarchy">
    <xsl:param name="id_string"  select="''"/>    
    <f:array key="items">
      <f:map>
        <f:string key="id"><xsl:value-of select="concat(substring-before($id_string,'/info.json'),'/page')"/></f:string>

        <f:string key="type">AnnotationPage</f:string>
        <f:array key="items">
          <f:map>
            <f:string key="id"><xsl:value-of select="concat(substring-before($id_string,'/info.json'),'/annotation')"/></f:string>

            <f:string key="type">Annotation</f:string>
            <f:string key="motivation">painting</f:string>
            <f:map key="body">
              <f:string key="id"><xsl:value-of select="concat(substring-before($id_string,'/info.json'),'/full/!1225,/0/default.jpg')"/></f:string>

              <f:array key="thumbnail">
                <f:map>
                  <f:string key="id"><xsl:value-of select="concat(substring-before($id_string,'/info.json'),'/full/!225,/0/default.jpg')"/></f:string>
                  <f:string key="format">image/jpeg</f:string>
                <f:string key="type">Image</f:string>
                </f:map>
              </f:array>
                <f:string key="type">Image</f:string>
                <f:string key="format">image/jpeg</f:string>
                <!-- xsl:copy-of select="$resolution"/ -->
                <f:array key="service">
                  <f:map>
                    <f:string key="id"><xsl:value-of select="substring-before($id_string,'/info.json')"/></f:string>
                    <f:string key="type">ImageService2</f:string>
                    <f:string key="profile">level1</f:string>
                  </f:map>
                </f:array>
            </f:map>
            <f:string key="target">https://iiif.io/api/cookbook/recipe/0009-book-1/canvas/p1</f:string>
          </f:map>
        </f:array>
      </f:map>
    </f:array>
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
	  <xsl:value-of select="replace($img,'http:','https:')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('https://kb-images.kb.dk/',$img,'/info.json')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  
  
</xsl:transform>

          

