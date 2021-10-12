<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:m="http://www.loc.gov/mods/v3"
               xmlns:t="http://www.tei-c.org/ns/1.0"
               xmlns:f="http://www.w3.org/2005/xpath-functions"
               xmlns:h="http://www.w3.org/1999/xhtml"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0">

  <xsl:output method="text" />
  
  <xsl:template match="/">
    <xsl:variable name="json">
      <f:array>
        <xsl:for-each select="//m:mods">
          <xsl:variable name="dom" select="."/>

          <xsl:variable name="record-id">
            <xsl:choose>
              <xsl:when test="processing-instruction('cobject_id')">
                <xsl:value-of select="processing-instruction('cobject_id')"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="m:recordInfo/m:recordIdentifier"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="output_data">
            <f:map>
            <!-- record identification, admin data etc  -->

            <xsl:variable name="edition">
              <xsl:value-of select="substring-before($record-id,'/object')"/>
            </xsl:variable>
            
            <f:string key="id">
              <xsl:value-of select="$record-id"/>
            </f:string>

            <xsl:for-each select="m:recordInfo/m:languageOfCataloging/m:languageTerm[1]">
              <f:string key="cataloging_language">
                <xsl:value-of select="."/>              
              </f:string>
            </xsl:for-each>

            <xsl:for-each select="m:name[@type='cumulus' and m:role/m:roleTerm = 'last-modified-by']">
              <f:array>
                <xsl:attribute name="key">last_modified_by</xsl:attribute>
                <xsl:call-template name="get-names"/>
              </f:array>
            </xsl:for-each>

            <xsl:for-each select="m:recordInfo/m:recordCreationDate">
              <f:string key="record_created"><xsl:value-of select="."/></f:string>
            </xsl:for-each> 

            <xsl:for-each select="m:recordInfo/m:recordChangeDate">
              <f:string key="record_revised"><xsl:value-of select="."/></f:string>
            </xsl:for-each> 
            
            <!-- basic bibliographic metadata -->

            <xsl:if test="m:titleInfo/m:title">
              <f:array key="title">
                <xsl:for-each select="m:titleInfo">
                  <f:map>
                    <xsl:if test="@xml:lang">
                      <f:string key="lang">
                        <xsl:value-of select="@xml:lang"/>
                      </f:string>
                    </xsl:if>
                    <f:string>
                      <xsl:attribute name="key">
                        <xsl:choose>
                          <xsl:when test="@type">
                            <xsl:value-of select="@type"/>
                          </xsl:when>
                          <xsl:otherwise>main</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:for-each select="m:title">
                        <xsl:value-of select="."/>
                      </xsl:for-each>
                    </f:string>
                  </f:map>
                </xsl:for-each>
              </f:array>
            </xsl:if>
            
            <xsl:for-each select="distinct-values(m:name/m:role/m:roleTerm)">
              <xsl:variable name="term" select="."/>
              <xsl:if test="not(contains($term,'last-modified-by'))">
                <f:array>
                  <xsl:attribute name="key">
                    <xsl:choose>
                      <xsl:when test=". = 'src'">scr</xsl:when>
                      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:for-each select="$dom//m:name[m:role/m:roleTerm = $term]">
                    <xsl:call-template name="get-names"/>
                  </xsl:for-each>
                </f:array>
              </xsl:if>
            </xsl:for-each>

            <!-- *********************** misc notes               ******************** -->

            <xsl:if test="m:note[not(@type) or not(@displayLabel)]">
              <f:array key="note">
                <xsl:for-each select="m:note">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </f:array>
            </xsl:if>

            <xsl:if test="m:note[@type or @displayLabel]">
              <f:map key="specific_notes">
                <xsl:for-each select="m:note[@type or @displayLabel]">
                  <f:string>
                    <xsl:attribute name="key">
                      <xsl:choose>
                        <xsl:when test="@type">
                          <xsl:value-of select="@type"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@displayLabel"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                  </f:string>
                </xsl:for-each>
              </f:map>
            </xsl:if>

            <!-- *********************** Subjects, Categories etc ******************** -->

            <xsl:for-each select="distinct-values(m:subject/m:name/m:role/m:roleTerm)">
              <xsl:variable name="term" select="."/>
              <f:array>
                <xsl:attribute name="key">subject</xsl:attribute>
                <xsl:for-each select="$dom//m:subject/m:name[m:role/m:roleTerm = $term]">
                  <xsl:call-template name="get-names"/>
                </xsl:for-each>
              </f:array>
            </xsl:for-each>

            <xsl:if test="m:subject/m:topic">
              <f:array>
                <xsl:attribute name="key">keywords</xsl:attribute>
                <xsl:for-each select="distinct-values(m:subject/m:topic)">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </f:array>
            </xsl:if>

            <xsl:if test="m:subject/m:geographic">
              <f:array>
                <xsl:attribute name="key">keywords_geographic</xsl:attribute>
                <xsl:for-each select="distinct-values(m:subject/m:geographic)">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </f:array>
            </xsl:if>
            
            <f:array key="categories">

              <xsl:variable name="categories" as="xs:string *">
                <xsl:for-each select="m:extension/h:div">
                  <xsl:for-each select="h:a[@href]">
                    <xsl:sort select="@href" data-type="text" />
                    <xsl:if test="not(contains(@href,'editions'))">
                      <xsl:value-of
                          select="concat($edition,'/',replace(@href,'(.*/sub)([^/]+)/../','sub$2'))"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:variable>

              <xsl:for-each select="distinct-values($categories)" >
                <xsl:variable name="subject"
                              select="concat(replace(.,'(.*/sub)([^/]+)','sub$2'),'/')"/>
                <f:map>
                  <f:string key="id"><xsl:value-of select="."/></f:string>
                  <f:string key="da">
                    <xsl:for-each select="distinct-values($dom//h:a[contains(@href,$subject) and @xml:lang='da'])">
                      <xsl:value-of select="."/>
                    </xsl:for-each>
                  </f:string>
                  <f:string key="en">
                    <xsl:for-each select="distinct-values($dom//h:a[contains(@href,$subject) and @xml:lang='en'])">
                      <xsl:value-of select="."/>
                    </xsl:for-each>
                  </f:string>
                </f:map>
              </xsl:for-each>
            </f:array>

            <xsl:if test="m:subject/m:hierarchicalGeographic">
              <f:map key="coverage_geo_names">
                <xsl:for-each select="m:subject/m:hierarchicalGeographic">
                  <xsl:for-each select="m:area">
                    <xsl:element name="f:string">
                      <xsl:attribute name="key"><xsl:value-of select="@areaType"/></xsl:attribute>
                      <xsl:value-of select="."/>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="m:citySection">
                    <xsl:element name="f:string">
                      <xsl:attribute name="key"><xsl:value-of select="@citySectionType"/></xsl:attribute>
                      <xsl:value-of select="."/>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="m:city">
                    <f:string key="city"><xsl:value-of select="m:city"/></f:string>
                  </xsl:if>
                </xsl:for-each>
              </f:map>
            </xsl:if>
            
            <xsl:for-each select="m:subject/m:cartographics/m:coordinates[1]">
              <xsl:if test="not(contains(.,'0.0,0.0'))">
                <f:string key="dcterms_spatial"><xsl:value-of select="."/></f:string>
              </xsl:if>
            </xsl:for-each>

            <!-- dating and origin -->
            
            <xsl:choose>
              <xsl:when test="m:originInfo/m:dateCreated/@t:notAfter">
                <xsl:for-each select="m:originInfo/m:dateCreated/@t:notAfter">
                  <f:string key="not_after_date">
                    <xsl:value-of select="."/>
                  </f:string>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="processing-instruction('cobject_not_after')">
                  <f:string key="not_after_date">
                    <xsl:value-of select="processing-instruction('cobject_not_after')"/>
                  </f:string>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
              <xsl:when test="m:originInfo/m:dateCreated/@t:notBefore">
                <xsl:for-each select="m:originInfo/m:dateCreated/@t:notBefore">
                  <f:string key="not_before_date">
                    <xsl:value-of select="."/>
                  </f:string>
                </xsl:for-each>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="processing-instruction('cobject_not_before')">
                  <f:string key="not_before_date">
                    <xsl:value-of select="processing-instruction('cobject_not_before')"/>
                  </f:string>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="m:originInfo/m:dateCreated">
              <f:array key="date">
                <xsl:for-each select="m:originInfo/m:dateCreated">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </f:array>
            </xsl:if>

            <!-- physical description and the like -->

            <xsl:if test="m:physicalDescription[m:form
                                    | m:reformattingQuality
                                    | m:internetMediaType
                                    | m:extent
                                    | m:digitalOrigin
                                    | m:note[not(@type='pageOrientation')]]">
              <f:map key="physical_description">
                <xsl:for-each select="m:physicalDescription">
                  <xsl:variable name="label">
                    <xsl:choose>
                      <xsl:when test="@displayLabel">
                        <xsl:value-of select="@displayLabel"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="@type">
                            <xsl:value-of select="@type"/>
                          </xsl:when>
                          <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  
                  <xsl:for-each select="m:form
                                        | m:reformattingQuality
                                        | m:internetMediaType
                                        | m:extent
                                        | m:digitalOrigin
                                        | m:note[not(@type='pageOrientation')]">

                    <f:string>
                      <xsl:attribute name="key">
                        <xsl:choose>
                          <xsl:when test="string-length($label) &gt; 0"><xsl:value-of select="$label"/></xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
                              <xsl:otherwise><xsl:value-of select="local-name(.)"/></xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>
                      <xsl:value-of select="."/>
                    </f:string>

                  </xsl:for-each>
                </xsl:for-each>
              </f:map>
            </xsl:if>

            <!-- A library object usually have a more identifiers than
                 a software developer would like -->

            <xsl:if test="m:location/m:physicalLocation[@displayLabel='Shelf Mark' and not(@transliteration)]">
              <xsl:for-each select="m:location/m:physicalLocation[@displayLabel='Shelf Mark' and not(@transliteration)]">
                <f:string key="shelf_mark"><xsl:value-of select="."/></f:string>
              </xsl:for-each>
            </xsl:if>

            <xsl:for-each select="m:identifier[@type='local'][1]">
              <f:string key="local_identifier"><xsl:value-of select="."/></f:string>
            </xsl:for-each>

            <xsl:for-each select="m:relatedItem[@type='original']/m:identifier">
              <f:string key="original_object-identifier"><xsl:value-of select="."/></f:string>
            </xsl:for-each>

            <xsl:for-each select="m:identifier[@type='domsGuid']">
              <f:string key="doms_guid"><xsl:value-of select="."/></f:string>
            </xsl:for-each>
            
            <!--
                This is perhaps not obvious: Normally text is stored
                in the order it is to be read. However, from the point
                of view of people used to read western languages (LTR
                scripts) it might seem odd click on a left-arrow to
                get next page, but that is the way people reading
                Chinese, Arabic and Hebrew thinks (RTL scripts). And
                that is true for languages using those scripts, like
                Persian (using Arabic script) and Yiddish and Ladino
                using Hebrew script. Judeo-Arabic is a dialect of
                Arabic written using Hebrew script. We have all these
                in our collections.

                We have all these in our digital collections. However,
                around 2005-2010 someone decided that the staff doing
                the digitization cannot learn to recognize RTL or LTR
                objects, so a lot of texts has been digitized in what
                was claimed to be the "logical" direction, namely LTR.
                Instead of correcting the data we have done this in
                software.
            -->                          
            <xsl:for-each select="m:physicalDescription/m:note[@type='pageOrientation'][1]">
              <f:string key="read_direction"><xsl:value-of select="."/></f:string>
            </xsl:for-each>

            <xsl:element name="f:array">
              <xsl:attribute name="key">pages</xsl:attribute>
              <xsl:for-each select="m:relatedItem[m:identifier]">
                <xsl:call-template name="make_page_field"/>
              </xsl:for-each>
            </xsl:element>
            </f:map>
          </xsl:variable>
        
          <xsl:apply-templates select="$output_data/f:map">
            <xsl:with-param name="record_identifier" select="$record-id"/>
          </xsl:apply-templates>

        </xsl:for-each>
      </f:array>
    </xsl:variable>
    <xsl:value-of select="f:xml-to-json($json)"/>
  </xsl:template>
  
  <xsl:template name="make_page_field">

    <xsl:choose>
      <xsl:when test="m:identifier[@displayLabel='iiif']">
        <xsl:for-each select="m:identifier[@displayLabel='iiif'][string()]">
          <xsl:call-template name="find-pages"/>
        </xsl:for-each>

        <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[@displayLabel='iiif']]">
          <xsl:call-template name="make_page_field"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
          <xsl:for-each select="m:identifier[contains(.,'.tif')]">
          <xsl:call-template name="find-pages"/>
        </xsl:for-each>

        <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[contains(.,'.tif')]]">
          <xsl:call-template name="make_page_field"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
      
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
      <f:string>
	<xsl:choose>
	  <xsl:when test="contains($img,'.json')">
	    <xsl:value-of select="$img"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('https://kb-images.kb.dk/',$img,'/info.json')"/>
	  </xsl:otherwise>
	</xsl:choose>
      </f:string>
    </xsl:if>
  </xsl:template>

  <xsl:template name="get-names">
    <f:map>
      <xsl:if test="@authorityURI">
        <f:string key="id"><xsl:value-of select="@authorityURI"/></f:string>
      </xsl:if>
      <xsl:if test="@xml:lang">
        <f:string key="lang"><xsl:value-of select="@xml:lang"/></f:string>
      </xsl:if>
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

  <xsl:template match="f:map">
    <xsl:param name="record_identifier"/>
    <f:map>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="not(f:string[@key='id'])">
          <f:string key="id">
            <xsl:value-of select="concat($record_identifier,'-disposable-subrecord-',generate-id())"/>
          </f:string>
          <xsl:apply-templates select="*">
            <xsl:with-param name="record_identifier" select="$record_identifier"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <!-- xsl:apply-templates select="*[not(@key='id')]"/ -->
          <xsl:apply-templates select="*">
            <xsl:with-param name="record_identifier" select="$record_identifier"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </f:map>
  </xsl:template>
  
  <xsl:template match="*|@*">
    <xsl:param name="record_identifier"/>
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()">
        <xsl:with-param name="record_identifier" select="$record_identifier"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:transform>
