<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output indent="yes" encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>

<xsl:include href="./vulnerabilitiesdates.xsl"/>

<xsl:key name="unique-date" match="@public" use="substring(.,1,4)"/>
<xsl:key name="unique-base" match="@base" use="."/>

<xsl:template match="security">
  <xsl:text>## Do not edit this file, instead edit vulnerabilities.xml
## then create it using
## xsltproc vulnerabilities.xsl vulnerabilities.xml 
##

</xsl:text>
  <xsl:text>#use wml::openssl area=news page=vulnerabilities

</xsl:text>
<title>OpenSSL vulnerabilities</title>

<h1>OpenSSL vulnerabilities</h1>

<h2>Reporting a security vulnerability</h2>

<p>If you think you have found a security vulnerability then please send
  it to the OpenSSL team using the private security list
  <a href="mailto:openssl-security@openssl.org">openssl-security@openssl.org</a>.
  Encrypting your report is not necessary, but you can either use the
  <a href="openssl-security.asc">team PGP key</a>. If you wish to
  limit the initial disclosure, send it encrypted to specific team
  members.</p>

<p>Any mail sent to that address that is not about a security vulnerability will be ignored.  In general, bugs that are only present in the openssl
  command-line utility are not considered security issues.</p>

<h2>Notification of security vulnerabilities</h2>

<p>Please read the <a href="../about/secpolicy.html">OpenSSL Security Policy</a>.</p>

<p>To get notified when an OpenSSL update addresses a security vulnerability please subscribe to the
<a href="https://www.openssl.org/support/community.html">openssl-announce mailing list</a></p>

<h2>Security vulnerabilities and advisories</h2>

<p>This section lists all security vulnerabilities fixed in released
versions of OpenSSL since 0.9.6a was released on 5th April 2001.
</p>
<p>Note: OpenSSL 0.9.6 versions and 0.9.7 versions are no longer supported and will not 
receive security updates</p>

<xsl:for-each select="issue/@public[generate-id()=generate-id(key('unique-date',substring(.,1,4)))]">
  		  <xsl:sort select="." order="descending"/>
<xsl:variable name="year" select="substring(.,1,4)"/>
<h2><xsl:value-of select="$year"/></h2>
             <dl>
                <xsl:apply-templates select="../../issue[substring(@public,1,4)=$year]">
                  <xsl:sort select="./@public" order="descending"/>
	        </xsl:apply-templates>
             </dl>
        </xsl:for-each>
</xsl:template>

<xsl:template match="issue">
  <dt>
  <xsl:apply-templates select="cve"/>
  <xsl:if test="impact/@severity">
    [<xsl:value-of select="impact/@severity"/> severity]
  </xsl:if>
<xsl:call-template name="dateformat">
  <xsl:with-param name="date" select="@public"/>
</xsl:call-template>
<p/>
</dt><dd>
  <xsl:copy-of select="description"/>
  <xsl:if test="advisory/@url">
    <a href="{advisory/@url}">(original advisory)</a><xsl:text>. </xsl:text>
  </xsl:if>
  <xsl:if test="reported/@source">
    Reported by <xsl:value-of select="reported/@source"/>.
  </xsl:if>
  </dd>
  <p/>
    <xsl:for-each select="fixed">
      <dd>Fixed in OpenSSL  
      <xsl:value-of select="@version"/>
      <xsl:if test="git/@hash">
	<xsl:text> </xsl:text><a href="https://github.com/openssl/openssl/commit/{git/@hash}">(git commit)</a><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:variable name="mybase" select="@base"/>
      <xsl:for-each select="../affects[@base=$mybase]|../maybeaffects[@base=$mybase]">
        <xsl:sort select="@version" order="descending"/>
            <xsl:if test="position() =1">
              <xsl:text> (Affected </xsl:text>
            </xsl:if>
            <xsl:value-of select="@version"/>
            <xsl:if test="name() = 'maybeaffects'">
              <xsl:text>?</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="position() = last()">
              <xsl:text>) </xsl:text>
            </xsl:if>
      </xsl:for-each>
      </dd>
    </xsl:for-each>
  <p/>
</xsl:template>

<xsl:template match="cve">
<xsl:if test="@name != ''">
<b><a name="{@name}">
<xsl:if test="@description = 'full'">
The Common Vulnerabilities and Exposures project
has assigned the name 
</xsl:if>
<a href="http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-{@name}">CVE-<xsl:value-of select="@name"/>: </a>
<xsl:if test="@description = 'full'">
 to this issue.
</xsl:if>
</a></b>
</xsl:if>
</xsl:template>
</xsl:stylesheet>


