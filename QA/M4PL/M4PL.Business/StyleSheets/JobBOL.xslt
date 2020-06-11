<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="ImagePath"/>
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
        <div id="MyContent" runat="server" width="100%" class="FullScreen" style="font-family : Calibri;font-size: 5px;">
          <table id="MainTable" border="1" width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <tbody>

              <tr>
                <td>
                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tbody>
                      <tr>
                        <td align="left" valign="middle" ColSpan="2" style="font-weight: bold;">
                          <table>
                            <tr>
                              <td width ="25%">
                                <img id="imgCompanylogo" runat="server" style="width: 150px;height: 30px">
                                  <xsl:attribute name="src">
                                    <xsl:value-of select="$ImagePath" />
                                  </xsl:attribute>
                                </img>
                              </td>
                              <td width ="25%" >
                                <table width ="100%">
                                  <tr>
                                    <td width="15%" style="text-align: center;">
                                      <b> Bill of Lading</b>
                                    </td>
                                    <td >
                                    </td>
                                    <td align="left" valign="middle" >
                                    </td>
                                  </tr>
                                  <tr>
                                    <td valign="middle" style="text-align: center;">
                                      <b>
                                        Contract# : <xsl:value-of select="JobBOLDS/Header/ContractNumber" />
                                      </b>
                                    </td>
                                    <td></td>
                                  </tr>
                                </table>
                              </td>
                              <td width="50">
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
              <tr style="width:100%">
                <td align="Top" width="100%">
                  <table border="1" width="100%" style="font-size:6px !important">
                    <tbody >
                      <tr >
                        <td  valign="top">
                          <table cellpadding="0" cellspacing="0" >
                            <tbody >
                              <tr >
                                <td valign="top" style="width:205%;">
                                  <table   >
                                    <tbody>
                                      <tr>
                                        <td style="width:21%;">

                                          <table border="0" width="100%" valign="top" align="left">

                                            <tbody>
                                              <tr>
                                                <td align="left" border="0">
                                                  <b>Vendor : </b>
                                                </td>
                                                <td align="left">

                                                  <xsl:value-of select="JobBOLDS/Header/VendorName" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td  align="left">
                                                  <b>BOL Number : </b>
                                                </td>
                                                <td align="left" >
                                                  <xsl:value-of select="JobBOLDS/Header/BOLNumber" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td  align="left">
                                                  <b>Plant Code : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/PlantCode" />
                                                </td>
                                              </tr>
                                            </tbody>
                                          </table>

                                        </td>
                                        <td style="width:21%;border : 1px solid black;"  >
                                          <div>
                                            <table border="0" width="100%" valign="top" align="left">
                                              <tbody>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Vendor Location :</b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobBOLDS/Header/VendorLocation" />
                                                  </td>
                                                </tr>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Manifest No :</b>
                                                  </td>
                                                  <td width="40%" align="left">
                                                    <xsl:value-of select="JobBOLDS/Header/ManifestNo" />
                                                  </td>
                                                </tr>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Trailer# :</b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobBOLDS/Header/TrailerNo" />
                                                  </td>
                                                </tr>
                                              </tbody>
                                            </table>
                                          </div>
                                        </td>
                                        <td width="58%"></td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td >
                          <table width="100%" valign="top" align="left">
                            <tbody>
                              <tr>
                                <td  style="width:50%;">
                                  <b>Ordered Date : </b>
                                </td>
                                <td align="left" style="width:50%;">
                                  <xsl:value-of select="JobBOLDS/Header/OrderedDate" />
                                </td>
                              </tr>
                              <tr>
                                <td  style="width:50%">
                                  <b>Arrival Planned Date : </b>
                                </td>
                                <td align="left" style="width:50%">
                                  <xsl:value-of select="JobBOLDS/Header/ArrivalPlannedDate" />
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                        <td>
                          <table border="0" width="100%" valign="top" align="left">
                            <tbody>
                              <tr>
                                <td align="left">
                                  <b>Shipment Date :</b>
                                </td>
                                <td align="left">
                                  <xsl:value-of select="JobBOLDS/Header/ShipmentDate" />
                                </td>
                              </tr>
                              <tr>
                                <td align="left">
                                  <b>Delivery Planned Date : </b>
                                </td>
                                <td align="left">
                                  <xsl:value-of select="JobBOLDS/Header/DeliveryPlannedDate" />
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" style="padding-top: 10px; padding-bottom: 10px;">
                          <div>
                            <table width="100%">

                              <tr>
                                <td align="left" style="width:6% !important;">
                                  <b> Order Type : </b>
                                </td>
                                <td align="Left" style="width:10% !important;">
                                  <xsl:value-of select="JobBOLDS/Header/OrderType" />
                                </td>
                                <td align="left">
                                  <b> Total Weight : </b>
                                </td>
                                <td align="Left">
                                  <xsl:value-of select="JobBOLDS/Header/TotalWeight" />
                                </td>
                              </tr>
                              <tr>
                                <td align="left">
                                  <b>Shipment Type : </b>
                                </td>
                                <td align="Left">
                                  <xsl:value-of select="JobBOLDS/Header/ShipmentType" />
                                </td>
                                <td align="left">
                                  <b>Total Cubes : </b>
                                </td>
                                <td align="Left">
                                  <xsl:value-of select="JobBOLDS/Header/TotalCube" />
                                </td>
                              </tr>
                              <tr>
                                <td colspan="2" style="height: 2px;">
                                </td>
                              </tr>
                            </table>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" style="padding-top: 10px; padding-bottom: 10px;">
                          <table  border="1" width="100%">
                            <tbody>
                              <tr>
                                <td style="width:50%" valign="top">
                                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tbody>
                                      <tr>
                                        <td valign="top" width="50%">
                                          <table width="100%">
                                            <tbody>
                                              <tr>
                                                <td>
                                                  <table border="0" width="100%" valign="top" align="left">
                                                    <tbody>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Origin</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginSiteName" />
                                                        </td>
                                                      </tr>
                                                      <xsl:if test="JobBOLDS/Header/OriginAddress != ''">
                                                        <tr>
                                                          <td align="left">
                                                            <b>Address</b>
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
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginCity" /> , <xsl:value-of select="JobBOLDS/Header/OriginStateCode" /> <span> </span> <xsl:value-of select="JobBOLDS/Header/OriginPostalCode" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Country</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginCountry" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Contact</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginContactName" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Phone</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginPhoneNumber" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Email</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginEmail" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Pickup Window</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginWindow" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Time Zone</b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobBOLDS/Header/OriginTimeZone" />
                                                        </td>
                                                      </tr>

                                                    </tbody>
                                                  </table>
                                                </td>
                                              </tr>
                                            </tbody>
                                          </table>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                                <td style="width:50%" valign="top">
                                  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tbody>
                                      <tr>
                                        <td>
                                          <table border="0" width="100%" valign="top" align="left">
                                            <tbody>
                                              <tr>
                                                <td align="left">
                                                  <b>Destination</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationSiteName" />
                                                </td>
                                              </tr>
                                              <xsl:if test="JobBOLDS/Header/DestinationAddress != ''">
                                                <tr>
                                                  <td align="left">
                                                    <b>Address</b>
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
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationCity" /> , <xsl:value-of select="JobBOLDS/Header/DestinationStateCode" /> <span> </span> <xsl:value-of select="JobBOLDS/Header/DestinationPostalCode" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Country</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationCountry" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Contact</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationContactName" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Phone</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationPhoneNumber" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Email</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationEmail" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Delivery Window</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationWindow" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Time Zone</b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobBOLDS/Header/DestinationTimeZone" />
                                                </td>
                                              </tr>

                                            </tbody>
                                          </table>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                </td>
                              </tr>
                              <tr>
                                <td colspan="2" style="border:none;">
                                  <table width="100%">
                                    <tr>
                                      <td>
                                        <b>
                                          Driver Alerts :
                                        </b>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td style="border:1px black !important; width:100%">
                                        <xsl:value-of select="JobBOLDS/Header/DriverAlert" />
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </tbody>
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
                            <table id="ucrBOL1_grdShipmentItems" border="1" cellpadding="0" cellspacing="0" rules="all" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; WIDTH: 100%; BORDER-COLLAPSE: collapse; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid">
                              <tbody>
                                <tr align="middle" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid; font-family : Calibri;font-size: 15px;">
                                  <th scope="col"> Item </th>
                                  <th scope="col"> Part Code </th>
                                  <th scope="col"> Serial Number </th>
                                  <th scope="col"> Title </th>
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
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="9%">
                                      <xsl:value-of select="PartCode" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;word-break:break-all;" align="center" width="14%">
                                      <xsl:value-of select="SerialNumber" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="24%" align="center">
                                      <xsl:value-of select="Title" />
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
                    </tbody>
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
    <xsl:value-of select="$mo"/>
    <xsl:if test="$mo != ''">
      <b>/</b>
    </xsl:if>
    <xsl:value-of select="$day"/>
    <xsl:if test="$day != ''">
      <b>/</b>
    </xsl:if>
    <xsl:value-of select="$year"/>
  </xsl:template>
</xsl:stylesheet>
