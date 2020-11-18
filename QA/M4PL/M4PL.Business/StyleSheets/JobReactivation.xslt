<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
  <xsl:param name="JobId" />
  <xsl:param name="Date" />
  <xsl:param name="Time" />
  <xsl:param name="ContactNumber" />
  <xsl:param name="JobURL" />
  <xsl:param name="JobOriginDateTimePlanned" />
  <xsl:param name="JobDeliveryDateTimePlanned" />
  <xsl:template match="/">
    <html>
      <head>
        <style type="text/css" ref="stylesheet">
          .page-break	{
          page-break-inside: avoid;
          margin-top:5px;
          }
          .RemoveRow {
          display: none;
          visibility: hidden;
          }
          .AddRow
          {
          display:all;
          visibility:visible;
          }
        </style>
      </head>
      <body>
        <div id="MyContent" runat="server" width="100%" class="FullScreen" style="font-family : Calibri;">
          The order for Job ID
            <xsl:value-of select="$JobId" />
			(<b>
			<xsl:value-of select="$ContactNumber" />
          </b>) was uncanceled on
          <xsl:value-of select="$Date" />
		  at
		  <xsl:value-of select="$Time" /> .
          <br></br>
          <br></br>
		You can view the job by clicking on the link:
		<xsl:value-of select="$JobURL" />
		<br></br>
		<table>
		<tr>
		<td>Arrival Date: </td>
		<td><xsl:value-of select="$JobOriginDateTimePlanned" /> </td>
		</tr>
		<tr>
		<td>Delivery Date: </td>
		<td><xsl:value-of select="$JobDeliveryDateTimePlanned" /> </td>
		</tr>
		</table>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>