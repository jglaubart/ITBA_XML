<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="/data/error">
        <xsl:value-of select="/data/error"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/data/congress"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="//data/congress">
    <h1 align="center"><xsl:value-of select="name"/></h1>
    <h3 align="center"><xsl:value-of select="period"/></h3>
    <hr/>
    <xsl:apply-templates select="chambers/chamber"/>
  </xsl:template>

  <xsl:template match="chamber">
    <h2 align="center"><xsl:value-of select="name"/></h2>
    
    <h4 align="center">Members</h4>
    <table border="1" frame="1" align="center">
      <thead bgcolor="yellow">
        <tr>
          <th>Name</th>
          <th>State</th>
          <th>Party</th>
          <th>Period</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="members/member">
          <xsl:sort select="name"/>
        </xsl:apply-templates>
      </tbody>
    </table>

    <h4 align="center">Sessions</h4>
    <table border="1" frame="1" align="center">
      <thead bgcolor="yellow">
        <tr>
          <th>Number</th>
          <th>Type</th>
          <th>Period</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates select="sessions/session"/>
      </tbody>
    </table>
    <hr/>
  </xsl:template>

  <xsl:template match="member">
    <tr>
      <td><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="state"/></td>
      <td><xsl:value-of select="party"/></td>
      <td><xsl:value-of select="period"/></td>
    </tr>
  </xsl:template>

  <xsl:template match="session">
    <tr>
      <td><xsl:value-of select="number"/></td>
      <td><xsl:value-of select="type"/></td>
      <td><xsl:value-of select="period"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
