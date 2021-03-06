﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
    <xsl:output method="xml" indent="yes"/>
	<xsl:param name="isOrderNumberAvailable" />
	<xsl:template match="/">
    <html>
      <head>
        <style>

          table
          {
          font-family: Arial, Verdana, Times New Roman;
          font-size: 11px;
          }
          .dottedline
          {
          border-top: 2px dashed #000000;
          }
          .solid
          {
          border-bottom: 1px solid #000000;
          }
        </style>
      </head>
      <body>
        <table width="100%" border="0" style="font-size:15px">
          <tr height="640px">
            <td valign="top">
              <table width="100%" border="0" style="font-size:15px" valign="top">
                <tr >
                  <td colspan="2" width="100%">
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#000000">
                      <tr>
						  <xsl:if test="($isOrderNumberAvailable = 'true')">
							  <td bgcolor="#c0c0c0" align="center">
                          <font face="Arial,Helvetica" size="2">
                            <strong>Date Entered</strong>
                          </font>
                        </td>
						  </xsl:if>
						  <td bgcolor="#c0c0c0" align="center">
                          <font face="Arial,Helvetica" size="2">
                            <strong>Trading Partner</strong>
                          </font>
                        </td>
						  <xsl:if test="($isOrderNumberAvailable = 'true')">
							  <td bgcolor="#c0c0c0" align="center">
                          <font face="Arial,Helvetica" size="2">
                            <strong>Order Number </strong>
                          </font>
                        </td>
						  </xsl:if>
						  <xsl:if test="($isOrderNumberAvailable = 'false')">
							  <td bgcolor="#c0c0c0" align="center">
								  <font face="Arial,Helvetica" size="2">
									  <strong>Customer </strong>
								  </font>
							  </td>
						  </xsl:if>
					  </tr>
                      <xsl:for-each select="EDIExceptionDS/ExceptionInfo" >
                        <tr>
							<xsl:if test="($isOrderNumberAvailable = 'true')">
								<td align="center">
                            <font face="Arial,Helvetica" size="1">
                              <xsl:value-of select="DateEntered" />
                            </font>
                          </td>
							</xsl:if>
							<td align="center">
                            <font face="Arial,Helvetica" size="1">
                              <xsl:value-of select="TradingPartner" />
                            </font>
                          </td>
							<xsl:if test="($isOrderNumberAvailable = 'true')">
								<td align="center">
                            <font face="Arial,Helvetica" size="1">
                              <xsl:value-of select="OrderNnumber" />
                            </font>
                          </td>
							</xsl:if>
							<xsl:if test="($isOrderNumberAvailable = 'false')">
								<td align="center">
									<font face="Arial,Helvetica" size="1">
										<xsl:value-of select="Customer" />
									</font>
								</td>
							</xsl:if>
						</tr>
                      </xsl:for-each>
                    </table>
                  </td>
                </tr>

              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
