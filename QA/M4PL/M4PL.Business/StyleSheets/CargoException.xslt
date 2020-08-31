<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="ExceptionCode"/>
  <xsl:param name="JobId"/>
  <xsl:param name="ContractNo"/>
  <xsl:param name="CreatedDate"/>
  <xsl:param name="Username"/>
  <xsl:param name="JobURL"/>
  <xsl:param name="Comment"/>
  <xsl:param name="IsCommentPresent"/>
  <xsl:param name="CgoPartNumCode"/>
  <xsl:param name="CgoTitle"/>
  <xsl:param name="CgoSerialNumber"/>
  <xsl:param name="CurrentGateway"/>
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
          Hi,
          <br></br>
          There was a cargo exception(<b>
            <xsl:value-of select="$ExceptionCode" />
          </b>) has been created
          for JobId <b>
            <xsl:value-of select="$JobId" />
          </b> (Contract # <b>
            <xsl:value-of select="$ContractNo" />
          </b>) on <b>
            <xsl:value-of select="$CreatedDate" />
          </b> by user
          <b>
            <xsl:value-of select="$Username" />
          </b>. <br></br>You can view the job by clicking on the link: <b>
            <xsl:value-of select="$JobURL" />
          </b>.
          <xsl:if test="($IsCommentPresent = 1)">
            <br></br>
            <b>Comment add by user: </b>
            <xsl:value-of select="$Comment" />
          </xsl:if>
          <br></br>
          <b>Details-</b>
          <table>
            <tr>
              <td>Cargo Part code -</td>
              <td>
                <xsl:value-of select="$CgoPartNumCode" />
              </td>
            </tr>
            <tr>
              <td>Title -</td>
              <td>
                <xsl:value-of select="$CgoTitle" />
              </td>
            </tr>
            <tr>
              <td>Serial number -</td>
              <td>
                <xsl:value-of select="$CgoSerialNumber" />
              </td>
            </tr>
            <tr>
              <td>Current Gateway -</td>
              <td>
                <xsl:value-of select="$CurrentGateway" />
              </td>
            </tr>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
