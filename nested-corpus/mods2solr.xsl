<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:m="http://www.loc.gov/mods/v3"
               xmlns:t="http://www.tei-c.org/ns/1.0"
               xmlns:f="http://www.w3.org/2005/xpath-functions"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0">

  <xsl:output method="text" />
  
  <xsl:template match="/">
    <xsl:variable name="json">
      <f:array>
        <xsl:for-each select="//m:mods">
          <xsl:variable name="dom" select="."/>
          <f:map>
            <f:string key="id">
              <xsl:choose>
                <xsl:when test="processing-instruction('cobject_id')">
                  <xsl:value-of select="processing-instruction('cobject_id')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="m:recordInfo/m:recordIdentifier"/>
                </xsl:otherwise>
              </xsl:choose>
            </f:string>
            <f:string key="title">
              <xsl:value-of select="m:titleInfo/m:title"/>
            </f:string>

             <xsl:for-each select="distinct-values(m:name/m:role/m:roleTerm)">
              <xsl:variable name="term" select="."/>
              <xsl:if test="not(contains($term,'last-modified-by'))">
                <f:array>
                  <xsl:attribute name="key"><xsl:value-of select="."/></xsl:attribute>
                  <xsl:for-each select="$dom//m:name[m:role/m:roleTerm = $term]">
                    <xsl:call-template name="get-names"/>
                  </xsl:for-each>
                </f:array>
              </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="distinct-values(m:subject/m:name/m:role/m:roleTerm)">
              <xsl:variable name="term" select="."/>
              <f:array>
                <xsl:attribute name="key">subject</xsl:attribute>
                <xsl:for-each select="$dom//m:subject/m:name[m:role/m:roleTerm = $term]">
                  <xsl:call-template name="get-names"/>
                </xsl:for-each>
              </f:array>
            </xsl:for-each>

            <xsl:for-each select="m:originInfo/m:dateCreated/@t:notAfter">
              <f:string key="not_after_date">
                <xsl:value-of select="."/>
              </f:string>
            </xsl:for-each>
            
           <xsl:for-each select="m:originInfo/m:dateCreated/@t:notBefore">
              <f:string key="not_before_date">
                <xsl:value-of select="."/>
              </f:string>
            </xsl:for-each>

            <xsl:for-each select="m:originInfo/m:dateCreated">
              <f:string key="date">
                <xsl:value-of select="."/>
              </f:string>
            </xsl:for-each>
            
          </f:map>
        </xsl:for-each>
      </f:array>
    </xsl:variable>
    <xsl:value-of select="f:xml-to-json($json)"/>
  </xsl:template>


  <xsl:template name="get-names">
    
    <f:map>
      <f:string key="id"><xsl:value-of select="@authorityURI"/></f:string>
      <f:string key="name">
        <xsl:for-each select="m:namePart">
          <xsl:choose>
            <xsl:when test="@type = 'date'"> (<xsl:value-of select="."/>)</xsl:when>
            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </f:string>
    </f:map>
    
  </xsl:template>


  
</xsl:transform>
