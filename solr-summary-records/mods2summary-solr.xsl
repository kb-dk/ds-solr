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

  <xsl:param name="sep_string" select="'!'"/>
  <xsl:param name="record_identifier" select="''"/>
  <xsl:param name="debug_params" select="''"/>
  <xsl:param name="collection_identifier" select="''"/>
  <xsl:param name="collection_type" select="''"/>
  
  <xsl:template match="/">

    <xsl:if test="$record_identifier and $debug_params">
      <xsl:message>Using  <xsl:value-of select="$record_identifier"/></xsl:message>
    </xsl:if>
    
    <xsl:if test="count(//m:mods) &gt; 1 and $record_identifier">
      <xsl:message terminate="yes">Fatal: We were passed one single record_identifier but have multiple records.</xsl:message>
    </xsl:if>
    
    <xsl:variable name="json">
      <f:array>
        <xsl:for-each select="//m:mods">
          <xsl:variable name="dom" select="."/>

          <xsl:variable name="record-id-in">
            <xsl:choose>
              <xsl:when test="$record_identifier"><xsl:value-of select="$record_identifier"/></xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="processing-instruction('cobject_id')">
                    <xsl:value-of select="replace(processing-instruction('cobject_id'),'^/','')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="replace(m:recordInfo/m:recordIdentifier,'^/','')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="record-id">
            <xsl:value-of select="replace($record-id-in,'/',$sep_string,'s')"/>
          </xsl:variable>

          <xsl:variable name="output_data">
            <f:map>
              <!-- record identification, admin data etc  -->

              <xsl:variable name="edition">
                <xsl:value-of select="substring-before($record-id,concat($sep_string,'object'))"/>
              </xsl:variable>
              
              <f:string key="id">
                <xsl:value-of select="$record-id"/>
              </f:string>

              <f:array key="title">
                <xsl:for-each select="distinct-values(m:titleInfo/m:title)">
                  <f:string><xsl:value-of select="normalize-space(.)"/></f:string>
                </xsl:for-each>
              </f:array>

              <f:array key="creator">
                <xsl:for-each select="m:name[not(@type='cumulus')][m:role/m:roleTerm = 'art' or m:role/m:roleTerm = 'aut' or m:role/m:roleTerm = 'creator']">
                  <f:string>
                    <xsl:value-of select="m:namePart"/>
                  </f:string>
                </xsl:for-each>
              </f:array>
              
              <f:array key="subject_person">
                <xsl:for-each select="m:name[not(@type='cumulus')][not(m:role/m:roleTerm = 'art' or m:role/m:roleTerm = 'aut' or m:role/m:roleTerm = 'creator')]|m:subject/m:name">
                  <f:string>
                    <xsl:value-of select="m:namePart"/>
                  </f:string>
                </xsl:for-each>
              </f:array>
              
              <f:array key="subject">
                <xsl:for-each select="m:subject">
                  <xsl:for-each select="m:topic|m:geographic|m:temporal|m:titleInfo|m:genre|m:hierarchicalGeographic|m:geographicCode|m:occupation">
                    <f:string><xsl:value-of select="normalize-space(.)"/></f:string>
                  </xsl:for-each>
                </xsl:for-each>
              </f:array>

              <f:array key="description">
                <xsl:for-each select="m:note">
                  <f:string><xsl:value-of select="normalize-space(.)"/></f:string>
                </xsl:for-each>
                <xsl:for-each select="m:physicalDescription">
                  <xsl:for-each select="m:form
                                        | m:reformattingQuality
                                        | m:internetMediaType
                                        | m:extent
                                        | m:digitalOrigin
                                        | m:note[not(@type='pageOrientation')]">
                    <f:string><xsl:value-of select="normalize-space(.)"/></f:string>
                  </xsl:for-each>
                </xsl:for-each>
              </f:array>
              
              <xsl:for-each select="m:recordInfo/m:languageOfCataloging/m:languageTerm[1]">
                <f:string key="cataloging_language">
                  <xsl:value-of select="."/>              
                </f:string>
              </xsl:for-each>

              <xsl:for-each select="m:recordInfo/m:recordCreationDate">
                <f:string key="record_created"><xsl:value-of select="."/></f:string>
              </xsl:for-each> 

              <xsl:for-each select="m:recordInfo/m:recordChangeDate">
                <f:string key="record_revised"><xsl:value-of select="."/></f:string>
              </xsl:for-each> 
              
              
              <xsl:if test="m:subject/m:geographic">
                <f:array key="location">
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
                        <!-- xsl:variable name="cat"><xsl:value-of
                        select="replace(@href,'^.*subject(\d+).*$','subject$1')"/></xsl:variable -->
                        <!-- xsl:value-of select="$cat"/ -->
                        <xsl:value-of select="."/>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:for-each>
                </xsl:variable>

                <xsl:for-each select="distinct-values($categories)" >
                  <!-- xsl:variable name="subject"
                                select="concat(replace(.,'(.*/sub)([^/]+)','sub$2'),'')"/ -->
                  
                  <!-- f:string>
                    <xsl:for-each
                        select="distinct-values($dom//h:a[contains(@href,$subject) and @xml:lang='da'])">
                      <xsl:value-of select="."/> 
                    </xsl:for-each>
                  </f:string>
                  <f:string>
                    <xsl:for-each
                        select="distinct-values($dom//h:a[contains(@href,$subject) and @xml:lang='en'])">
                      <xsl:value-of select="."/> 
                    </xsl:for-each -->
                  <f:string>
                    <xsl:value-of select="."/>
                  </f:string>

                </xsl:for-each>
              </f:array>

              
              
              <xsl:for-each select="m:subject/m:cartographics/m:coordinates[1]">
                <xsl:if test="not(contains(.,'0.0,0.0'))">
                  <f:string key="location_coordinates"><xsl:value-of select="."/></f:string>
                </xsl:if>
              </xsl:for-each>

              <!-- dating and origin -->
              
              <xsl:choose>
                <xsl:when test="m:originInfo/m:dateCreated/@t:notAfter">
                  <xsl:for-each select="m:originInfo/m:dateCreated/@t:notAfter[1]">
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
                  <xsl:for-each select="m:originInfo/m:dateCreated/@t:notBefore[1]">
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
                <f:array key="visible_date">
                  <xsl:for-each select="m:originInfo/m:dateCreated">
                    <f:string><xsl:value-of select="."/></f:string>
                  </xsl:for-each>
                </f:array>
              </xsl:if>

              

              <!-- A library object usually have a more identifiers than
                   a software developer would like -->

              <xsl:if test="m:location/m:physicalLocation[@displayLabel='Shelf Mark' and not(@transliteration)]">
                <f:array key="shelf_mark">
                  <xsl:for-each select="m:location/m:physicalLocation[@displayLabel='Shelf Mark' and not(@transliteration)]">
                    <f:string><xsl:value-of select="."/></f:string>
                  </xsl:for-each>
                </f:array>
              </xsl:if>

              <xsl:for-each select="m:identifier[@type='local'][1]">
                <f:string key="local_identifier"><xsl:value-of select="."/></f:string>
              </xsl:for-each>

              <f:array key="original_object_identifier">
                <xsl:for-each select="m:relatedItem[@type='original']/m:identifier">
                  <f:string><xsl:value-of select="."/></f:string>
                </xsl:for-each>
              </f:array>
              
              <xsl:choose>
                <xsl:when test="m:relatedItem[m:typeOfResource/@collection='yes']/m:titleInfo/m:title">

                  <xsl:for-each select="m:relatedItem[m:typeOfResource/@collection='yes'][1]">
                    <f:string key="collection"><xsl:value-of select="m:titleInfo/m:title"/></f:string>
                    <f:string key="collection_content">
                      <xsl:value-of select="m:typeOfResource[@collection='yes']"/>
                    </f:string>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="$collection_identifier">
                    <f:string key="collection_identifier"><xsl:value-of select="$collection_identifier"/></f:string>
                    <xsl:if test="$collection_type">
                      <f:string key="content">
                        <xsl:value-of select="$collection_type"/>
                      </f:string>
                    </xsl:if>
                    <f:string key="id">
                      <xsl:value-of
                          select="$collection_identifier"/>
                    </f:string>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              
              <xsl:for-each select="m:identifier[@type='domsGuid']">
                <f:string key="doms_guid"><xsl:value-of select="."/></f:string>
              </xsl:for-each>

              <xsl:if test="m:language/m:languageTerm[@authority='rfc4646']">
                <f:array key="language">
                  <xsl:for-each select="m:language/m:languageTerm[@authority='rfc4646']">
                    <f:string><xsl:value-of select="."/></f:string>
                  </xsl:for-each>
                </f:array>
              </xsl:if>
              
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

We have all these in our digital
collections. However, around 2005-2010 someone
decided that the staff doing the digitization cannot
learn to recognize RTL or LTR objects, so a lot of
texts has been digitized in what was claimed to be
the "logical" direction, namely LTR.  Instead of
correcting the data we have done this in software.
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
          
          <!-- xsl:apply-templates select="$output_data/f:map">
               <xsl:with-param name="record_identifier" select="$record-id"/>
               </xsl:apply-templates -->

          <xsl:copy-of select="$output_data"/>
          
        </xsl:for-each>
      </f:array>
    </xsl:variable>
    <xsl:value-of select="f:xml-to-json($json)"/>
    <!-- xsl:copy-of select="$json"/ -->
  </xsl:template>
  
  <xsl:template name="make_page_field">
    <!--    <xsl:variable name="chapter" select="m:titleInfo/m:title"/>-->

    <xsl:choose>
      <xsl:when test="m:identifier[@displayLabel='iiif']">
        <xsl:for-each select="m:identifier[@displayLabel='iiif'][string()]">
          <f:string>
            <xsl:call-template name="find-pages">
              <!--            <xsl:with-param name="chapter"><xsl:value-of select="$chapter"/></xsl:with-param>-->
            </xsl:call-template>
          </f:string>
        </xsl:for-each>

        <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[@displayLabel='iiif']]">
          <xsl:call-template name="make_page_field"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="m:identifier[contains(.,'.tif')]">
          <f:string>
            <xsl:call-template name="find-pages">
              <!--            <xsl:with-param name="chapter"><xsl:value-of select="$chapter"/></xsl:with-param>-->
            </xsl:call-template>
          </f:string>
        </xsl:for-each>

        <xsl:for-each select="m:relatedItem[@type='constituent'][m:identifier[contains(.,'.tif')]]">
          <xsl:call-template name="make_page_field"/>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  
  <xsl:template name="find-pages">
    <!--    <xsl:param name="chapter" select="''"/>-->
    
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
      <!--      <f:map>
           <xsl:if test="string-length($chapter) &gt; 0">
           <f:string key="title">
           <xsl:value-of select="$chapter"/>
           </f:string>
           </xsl:if>
           <f:string key="url">-->
      <!-- f:string -->
      <xsl:choose>
	<xsl:when test="contains($img,'.json')">
	  <xsl:value-of select="$img"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('https://kb-images.kb.dk/',$img,'/info.json')"/>
	</xsl:otherwise>
      </xsl:choose>            
      <!-- /f:string -->
      <!--      </f:map>-->
    </xsl:if>
  </xsl:template>


  <xsl:template match="f:map">
    <xsl:param name="record_identifier"/>
    <f:map>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="not(f:string[@key='id'])">
          <f:string key="id">
            <xsl:value-of select="concat($record_identifier,$sep_string,'disposable',$sep_string,'subrecord',$sep_string,generate-id())"/>
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

  <xsl:template name="disposable-subrecord">
    <xsl:param name="record_identifier"/>
    <f:string key="id">
      <xsl:value-of select="concat($record_identifier,$sep_string,'disposable',$sep_string,'subrecord',$sep_string,generate-id())"/>
    </f:string>
  </xsl:template>

  <xsl:function name="my:escape_stuff"><xsl:param name="arg"/><xsl:value-of select="replace($arg,'\s',$sep_string,'s')"/></xsl:function>
  
  <xsl:template match="*|@*">
    <xsl:param name="record_identifier"/>
    <xsl:copy>
      <xsl:apply-templates select="*|@*|text()">
        <xsl:with-param name="record_identifier" select="$record_identifier"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  
</xsl:transform>
