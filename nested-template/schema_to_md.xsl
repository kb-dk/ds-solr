<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:my="urn:my"
               version="3.0">

  <xsl:output method="text"
              encoding="UTF-8" />

  <xsl:template match="/schema">
    <xsl:text># </xsl:text><xsl:value-of select="@name"/> <xsl:value-of select="@version"/>
    <xsl:apply-templates select="fields"/>
  </xsl:template>

  <xsl:template match="fields">

    <xsl:for-each select="processing-instruction('begin-field-group')">
      <xsl:variable name="pi"><xsl:value-of select="."/></xsl:variable>
<xsl:text>

## </xsl:text> <xsl:value-of select="$pi"/><xsl:text>
      
</xsl:text>

<xsl:for-each select="following-sibling::field[following-sibling::processing-instruction('end-field-group')=$pi]">
<xsl:variable name="this_field"><xsl:value-of select="@name"/></xsl:variable>  
* <xsl:value-of select="my:escape_stuff(@name)"/> (<xsl:for-each select="@*"><xsl:value-of select="my:escape_stuff(local-name(.))"/>=<xsl:value-of select="my:escape_stuff(.)"/><xsl:text> </xsl:text></xsl:for-each>) <xsl:for-each select="following-sibling::processing-instruction('field-description')[contains(.,$this_field)]"> -- <xsl:value-of select="substring-after(.,$this_field)"/></xsl:for-each>
</xsl:for-each>

<xsl:text>
  
### References
  
</xsl:text>
<xsl:for-each select="following-sibling::processing-instruction(field-references)[following-sibling::processing-instruction('end-field-group')=$pi]">
  <xsl:value-of select="."/><xsl:text>
</xsl:text>
</xsl:for-each>


    </xsl:for-each>
    
  </xsl:template>

  <xsl:function name="my:escape_stuff">
    <xsl:param name="arg"/>
    <xsl:value-of select="replace($arg,'_','\\_','s')"/>
  </xsl:function>
  
</xsl:transform>
