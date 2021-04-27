﻿<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" />
  <xsl:param name="ImagePath" />
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
          <table id="MainTable" border="1" width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <tbody>
              <tr>
                <td colspan ="2" width="100%">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                      <td width ="40%">
                        <img id="imgCompanylogo" runat="server" style="width: 150px;height: 30px">
                          <xsl:attribute name="src">
                            <xsl:value-of select="$ImagePath" />
                          </xsl:attribute>
                        </img>
                      </td>
                      <td width ="60%">
                        <table width ="100%">
                          <tr>
                            <td style="text-align: left;">
                              <b style="padding-left: 30px;">Bill of Lading</b>
                            </td>
                          </tr>
                          <tr>
                            <td style="text-align: left;">
                              <b>
                                Contract# :
                                <xsl:value-of select="JobBOLDS/Header/ContractNumber" />
                              </b>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td style="border : 1px solid black;">
                  <table width="100%" valign="top" align="left">
                    <thead>
                      <tr>
                        <th style="font-weight:bold">Agent Information</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td  style="width:50%;">
                          <b>Vendor : </b>
                        </td>
                        <td align="left" style="width:50%;">
                          <xsl:value-of select="JobBOLDS/Header/VendorName" />
                        </td>
                      </tr>
                      <tr>
                        <td  style="width:50%">
                          <b>Vendor# : </b>
                        </td>
                        <td align="left" style="width:50%">
                          <xsl:value-of select="JobBOLDS/Header/VendorLocation" />
                        </td>
                      </tr>

                    </tbody>
                  </table>
                </td>
                <td style="border : 1px solid black;">
                  <table width="100%" valign="top" align="left">
                    <thead>
                      <tr>
                        <th style="font-weight:bold">Shipment Information</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td  style="width:50%;">
                          <b>Planned Delivery Date : </b>
                        </td>
                        <td align="left" style="width:50%;">
                          <xsl:value-of select="JobBOLDS/Header/DeliveryPlannedDate" />
                        </td>
                      </tr>
                      <tr>
                        <td  style="width:50%">
                          <b>Delivery Window# : </b>
                        </td>
                        <td align="left" style="width:50%">
                          <xsl:value-of select="JobBOLDS/Header/DestinationWindow" />
                        </td>
                      </tr>

                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td style="border : 1px solid black;">
                  <table width="100%" valign="top" align="left">
                    <thead>
                      <tr>
                        <th style="font-weight:bold">Product Seller Information</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td  style="width:50%;">
                          <b>Seller Site : </b>
                        </td>
                        <td align="left" style="width:50%;">
                          <xsl:value-of select="JobBOLDS/Header/SellerSiteName" />
                        </td>
                      </tr>
                      <tr>
                        <td  style="width:50%">
                          <b>Brand : </b>
                        </td>
                        <td align="left" style="width:50%">
                          <xsl:value-of select="JobBOLDS/Header/Brand" />
                        </td>
                      </tr>
                      <tr>
                        <td  style="width:50%">
                          <b>PO Number : </b>
                        </td>
                        <td align="left" style="width:50%">
                          <xsl:value-of select="JobBOLDS/Header/PONumber" />
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </td>
                <td style="border : 1px solid black;">
                  <table>
                    <tr>
                      <td>
                        <b> Quantity : </b>
                        <xsl:value-of select="JobBOLDS/Header/TotalQuantity" />
                      </td>
                      <td>
                        <b> Weight : </b>
                        <xsl:value-of select="JobBOLDS/Header/TotalWeight" />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Parts : </b>
                        <xsl:value-of select="JobBOLDS/Header/TotalParts" />
                      </td>
                      <td>
                        <b>Cubes : </b>
                        <xsl:value-of select="JobBOLDS/Header/TotalCube" />
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td style="border : 1px solid black;">
                  <table width="100%" valign="top" align="left">
                    <tr>
                      <td  style="width:50%;">
                        <b>Origin : </b>
                      </td>
                      <td align="left" style="width:50%;">
                        <xsl:value-of select="JobBOLDS/Header/OriginSiteName" />
                      </td>
                    </tr>
                    <xsl:if test="JobBOLDS/Header/OriginAddress != ''">
                      <tr>
                        <td align="left">
                          <b>Address : </b>
                        </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/OriginAddress" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/OriginAddress1 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/OriginAddress1" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/OriginAddress2 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/OriginAddress2" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/OriginAddress3 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/OriginAddress3" />
                        </td>
                      </tr>
                    </xsl:if>
                    <tr>
                      <td> </td>
                      <xsl:choose>
                        <xsl:when test="JobBOLDS/Header/OriginCity != ''">
                          <td align="left">
                            <xsl:value-of select="JobBOLDS/Header/OriginCity" /> , <xsl:value-of select="JobBOLDS/Header/OriginStateCode" /> <span>  </span> <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>  <xsl:value-of select="JobBOLDS/Header/OriginPostalCode" />
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td align="left">
                            <xsl:value-of select="JobBOLDS/Header/OriginStateCode" />
                            <span>  </span>
                            <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                            <xsl:value-of select="JobBOLDS/Header/OriginPostalCode" />
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                    </tr>
                    <tr>
                      <td align="left">
                        <b>Country : </b>
                      </td>
                      <xsl:if test="((JobBOLDS/Header/OriginCity != '') or (JobBOLDS/Header/OriginStateCode != '') or  (JobBOLDS/Header/OriginPostalCode != ''))">
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/OriginCountry" />
                        </td>
                      </xsl:if>
                    </tr>
                    <tr>
                      <td  style="width:50%">
                        <b>Contact : </b>
                      </td>
                      <td align="left" style="width:50%">
                        <xsl:value-of select="JobBOLDS/Header/OriginContactName" />
                      </td>
                    </tr>
                    <tr>
                      <td  style="width:50%">
                        <b>Phone : </b>
                      </td>
                      <td align="left" style="width:50%">
                        <xsl:value-of select="JobBOLDS/Header/OriginPhoneNumber" />
                      </td>
                    </tr>
                  </table>
                </td>
                <td style="border : 1px solid black;">
                  <table width="100%" valign="top" align="left">
                    <tr>
                      <td  style="width:50%;">
                        <b>Destination : </b>
                      </td>
                      <td align="left" style="width:50%;">
                        <xsl:value-of select="JobBOLDS/Header/DestinationSiteName" />
                      </td>
                    </tr>
                    <xsl:if test="JobBOLDS/Header/DestinationAddress != ''">
                      <tr>
                        <td align="left">
                          <b>Address : </b>
                        </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/DestinationAddress" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/DestinationAddress1 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/DestinationAddress1" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/DestinationAddress2 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/DestinationAddress2" />
                        </td>
                      </tr>
                    </xsl:if>
                    <xsl:if test="JobBOLDS/Header/DestinationAddress3 != ''">
                      <tr>
                        <td align="left"> </td>
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/DestinationAddress3" />
                        </td>
                      </tr>
                    </xsl:if>
                    <tr>
                      <td> </td>
                      <xsl:choose>
                        <xsl:when test="JobBOLDS/Header/DestinationCity != ''">
                          <td align="left">
                            <xsl:value-of select="JobBOLDS/Header/DestinationCity" /> ,
                            <xsl:value-of select="JobBOLDS/Header/DestinationStateCode" />
                            <span>  </span> <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                            <xsl:value-of select="JobBOLDS/Header/DestinationPostalCode" />
                          </td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td align="left">
                            <xsl:value-of select="JobBOLDS/Header/DestinationStateCode" />
                            <span>  </span>
                            <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                            <xsl:value-of select="JobBOLDS/Header/DestinationPostalCode" />
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                    </tr>
                    <tr>
                      <td align="left">
                        <b>Country : </b>
                      </td>
                      <xsl:if test="((JobBOLDS/Header/DestinationCity != '') or (JobBOLDS/Header/DestinationStateCode != '') or  (JobBOLDS/Header/DestinationPostalCode != ''))">
                        <td align="left">
                          <xsl:value-of select="JobBOLDS/Header/DestinationCountry" />
                        </td>
                      </xsl:if>
                    </tr>
                    <tr>
                      <td  style="width:50%">
                        <b>Contact : </b>
                      </td>
                      <td align="left" style="width:50%">
                        <xsl:value-of select="JobBOLDS/Header/DestinationContactName" />
                      </td>
                    </tr>
                    <tr>
                      <td  style="width:50%">
                        <b>Phone : </b>
                      </td>
                      <td align="left" style="width:50%">
                        <xsl:value-of select="JobBOLDS/Header/DestinationPhoneNumber" />
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <tr>
                <td colspan="2" style="border:none;">
                  <table  border="1" width="100%">
                    <tr>
                      <td>
                        <b>
                          Driver Alerts :
                        </b>
                        <xsl:value-of select="JobBOLDS/Header/DriverAlert" />
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="border:none;">
                  <table  border="1" width="100%">
                    <tr>
                      <td>
                        <b>
                          Customer Initial :
                        </b>
                        <xsl:value-of select="JobBOLDS/Header/CustomerInitial" />
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <tr>
                <td colspan="2" width="100%">
                  <table border="0" cellpadding="0" cellspacing="0">
                    <tbody>
                      <tr>
                        <td width="30%" colspan="2">
                          <b> Cargo Items : </b>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr>
                <td colspan="2" width="100%">
                  <div>
                    <table id="ucrBOL1_grdShipmentItems" border="1" cellpadding="0" cellspacing="0" rules="all" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; WIDTH: 100%; BORDER-COLLAPSE: collapse; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;font-family : Calibri;font-size: 12px;">
                      <tbody>
                        <tr align="middle" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;">
                          <th scope="col"> Item </th>
                          <th scope="col"> Part Code </th>
                          <th scope="col"> Serial Number </th>
                          <th scope="col"> Description </th>
                          <th scope="col"> Qty Ord </th>
                          <th scope="col"> Pkg Type </th>
                          <th scope="col"> Qty Unit </th>
                          <th scope="col"> Weight </th>
                          <th scope="col"> Cubes </th>
                        </tr>
                        <xsl:for-each select="JobBOLDS/CargoDetails">
                          <tr align="middle" style="HEIGHT: 19px" valign="center">
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="5%">
                              <xsl:value-of select="ItemNo" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="12%">
                              <xsl:value-of select="PartCode" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;word-break:break-all;" align="center" width="12%">
                              <xsl:value-of select="SerialNumber" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="24%" align="center">
                              <xsl:value-of select="Title" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="14%">
                              <xsl:value-of select="QtyOrdered" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="14%">
                              <xsl:value-of select="PackagingType" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="8%">
                              <xsl:value-of select="QuantityUnit" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="8%">
                              <xsl:value-of select="Weight" />
                            </td>
                            <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="8%">
                              <xsl:value-of select="Cubes" />
                            </td>
                          </tr>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </div>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table  border="1" width="100%">
                    <tr>
                      <td style="border:1px black !important; width:100%">
                        <b>
                          Delivery Acknowledgement :
                        </b>    all listed services were rendered and the property and order has been recieved in apparent good.
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td colspan="2" height="20px">
                  <table>
                    <tr>
                      <td></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table  border="1" width="100%">
                    <tr>
                      <td width ="30%">
                      </td>
                      <td width ="70%">
                        <table width="100%">
                          <tr>
                            <td>
                              <b>Customer Name(Printed):</b>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Customer Signature: </b>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Date: </b>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b style="color:red;">Delivery Time Complete: </b>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Driver Signature: </b>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

            </tbody>
          </table>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="FormatDayMonYear">
    <xsl:param name="DateTime" />
    <xsl:variable name="mo">
      <xsl:value-of select="substring($DateTime,6,2)" />
    </xsl:variable>
    <xsl:variable name="day">
      <xsl:value-of select="substring($DateTime,9,2)" />
    </xsl:variable>
    <xsl:variable name="year">
      <xsl:value-of select="substring($DateTime,3,2)" />
    </xsl:variable>
    <xsl:value-of select="$mo" />
    <xsl:if test="$mo != ''">
      <b>/</b>
    </xsl:if>
    <xsl:value-of select="$day" />
    <xsl:if test="$day != ''">
      <b>/</b>
    </xsl:if>
    <xsl:value-of select="$year" />
  </xsl:template>
</xsl:stylesheet>