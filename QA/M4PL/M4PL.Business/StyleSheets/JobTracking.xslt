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
                              <td width ="25%">
                                <table width ="100%">
                                  <tr>
                                    <td width="15%" style="text-align: center;">
                                      <b> Tracking</b>
                                    </td>
                                    <td>
                                    </td>
                                    <td align="left" valign="middle">
                                    </td>
                                  </tr>
                                  <tr>
                                    <td valign="middle" style="text-align: center;">
                                      <b>
                                        Contract# : <xsl:value-of select="JobTrackingDS/Header/ContractNumber" />
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
              <tr>
                <td align="Top">
                  <table border="0" width="100%">
                    <tbody>
                      <tr>
                        <td  valign="top">
                          <table cellpadding="0" cellspacing="0">
                            <tbody>
                              <tr>
                                <td valign="top" align="left" style="width:206%;">
                                  <table>
                                    <tbody>
                                      <tr>
                                        <td style="width:21%;border : 1px solid black;">

                                          <table border="0" width="100%" valign="top" align="left">

                                            <tbody>
                                              <tr>
                                                <td align="left" border="0">
                                                  <b>Vendor : </b>
                                                </td>
                                                <td align="left">

                                                  <xsl:value-of select="JobTrackingDS/Header/VendorName" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td  align="left">
                                                  <b>BOL Number : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/BOLNumber" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td  align="left">
                                                  <b>Plant Code : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/PlantCode" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td  align="left">
                                                  <b>Brand : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/Brand" />
                                                </td>
                                              </tr>
                                            </tbody>
                                          </table>
                                        </td>
                                        <td style="width:21%;border : 1px solid black;">
                                          <div>
                                            <table border="0" width="100%" valign="top" align="left">
                                              <tbody>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Vendor Location :</b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/VendorLocation" />
                                                  </td>
                                                </tr>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Manifest No :</b>
                                                  </td>
                                                  <td width="40%" align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/ManifestNo" />
                                                  </td>
                                                </tr>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Trailer# :</b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/TrailerNo" />
                                                  </td>
                                                </tr>
                                                <tr>
                                                  <td width="40%" align="left">
                                                    <b>Product Type :</b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/ProductType" />
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
                        <td style="border : 1px solid black;">
                          <table width="100%" valign="top" align="left">
                            <tbody>
                              <tr>
                                <td  style="width:50%;">
                                  <b>Ordered Date : </b>
                                </td>
                                <td align="left" style="width:50%;">
                                  <xsl:value-of select="JobTrackingDS/Header/OrderedDate" />
                                </td>
                              </tr>
                              <tr>
                                <td  style="width:50%">
                                  <b>Arrival Planned Date : </b>
                                </td>
                                <td align="left" style="width:50%">
                                  <xsl:value-of select="JobTrackingDS/Header/ArrivalPlannedDate" />
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                        <td style="border : 1px solid black;">
                          <table border="0" width="100%" valign="top" align="left">
                            <tbody>
                              <tr>
                                <td align="left">
                                  <b>Shipment Date :</b>
                                </td>
                                <td align="left">
                                  <xsl:value-of select="JobTrackingDS/Header/ShipmentDate" />
                                </td>
                              </tr>
                              <tr>
                                <td align="left">
                                  <b>Delivery Planned Date : </b>
                                </td>
                                <td align="left">
                                  <xsl:value-of select="JobTrackingDS/Header/DeliveryPlannedDate" />
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td style="border : 1px solid black;">
                          <table>
                            <tr>
                              <td>
                                <b>Order Type :</b>
                              </td>
                              <td align="left">
                                <xsl:value-of select="JobTrackingDS/Header/OrderType" />
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <b> Shipment Type :</b>
                              </td>
                              <td align="left">
                                <xsl:value-of select="JobTrackingDS/Header/ShipmentType" />
                              </td>
                            </tr>

                          </table>
                        </td>
                        <td style="border : 1px solid black;">
                          <table>
                            <tr>
                              <td>
                                <b> Quantity : </b>
                                <xsl:value-of select="JobTrackingDS/Header/TotalQuantity" />
                              </td>
                              <td>
                                <b> Weight : </b>
                                <xsl:value-of select="JobTrackingDS/Header/TotalWeight" />
                              </td>
                            </tr>
                            <tr>
                              <td>
                                <b>Parts : </b>
                                <xsl:value-of select="JobTrackingDS/Header/TotalParts" />
                              </td>
                              <td>
                                <b>Cubes : </b>
                                <xsl:value-of select="JobTrackingDS/Header/TotalCube" />
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td style="border : 1px solid black;">
                          <table>
                            <tr>
                              <td width="30%">
                                <b>Seller Site :</b>
                              </td>
                              <td align="left" width="70%">
                                <xsl:value-of select="JobTrackingDS/Header/SellerSiteName" />
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td style="border : 1px solid black;">
                          <table>
                            <tr>
                              <td width="30%">
                                <b> PO Number :</b>
                              </td>
                              <td align="left" width="70%">
                                <xsl:value-of select="JobTrackingDS/Header/PONumber" />
                              </td>
                            </tr>
                          </table>
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
                                                        <td align="left" width="30%">
                                                          <b>Origin : </b>
                                                        </td>
                                                        <td align="left" width="70%">
                                                          <xsl:value-of select="JobTrackingDS/Header/OriginSiteName" />
                                                        </td>
                                                      </tr>
                                                      <xsl:if test="JobTrackingDS/Header/OriginAddress != ''">
                                                        <tr>
                                                          <td align="left">
                                                            <b>Address : </b>
                                                          </td>
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginAddress" />
                                                          </td>
                                                        </tr>
                                                      </xsl:if>
                                                      <xsl:if test="JobTrackingDS/Header/OriginAddress1 != ''">
                                                        <tr>
                                                          <td align="left"> </td>
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginAddress1" />
                                                          </td>
                                                        </tr>
                                                      </xsl:if>
                                                      <xsl:if test="JobTrackingDS/Header/OriginAddress2 != ''">
                                                        <tr>
                                                          <td align="left"> </td>
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginAddress2" />
                                                          </td>
                                                        </tr>
                                                      </xsl:if>
                                                      <xsl:if test="JobTrackingDS/Header/OriginAddress3 != ''">
                                                        <tr>
                                                          <td align="left"> </td>
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginAddress3" />
                                                          </td>
                                                        </tr>
                                                      </xsl:if>
                                                      <tr>
                                                        <td> </td>
                                                        <xsl:choose>
                                                          <xsl:when test="JobTrackingDS/Header/OriginCity != ''">
                                                            <td align="left">
                                                              <xsl:value-of select="JobTrackingDS/Header/OriginCity" /> , <xsl:value-of select="JobTrackingDS/Header/OriginStateCode" /> <span>  </span> <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>  <xsl:value-of select="JobTrackingDS/Header/OriginPostalCode" />
                                                            </td>
                                                          </xsl:when>
                                                          <xsl:otherwise>
                                                            <td align="left">
                                                              <xsl:value-of select="JobTrackingDS/Header/OriginStateCode" />
                                                              <span>  </span>
                                                              <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                                                              <xsl:value-of select="JobTrackingDS/Header/OriginPostalCode" />
                                                            </td>
                                                          </xsl:otherwise>
                                                        </xsl:choose>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Country : </b>
                                                        </td>
                                                        <xsl:if test="((JobTrackingDS/Header/OriginCity != '') or (JobTrackingDS/Header/OriginStateCode != '') or  (JobTrackingDS/Header/OriginPostalCode != ''))">
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginCountry" />
                                                          </td>
                                                        </xsl:if>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Contact : </b>
                                                        </td>
                                                        <xsl:value-of select="JobTrackingDS/Header/OriginContactName" />
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Phone : </b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobTrackingDS/Header/OriginPhoneNumber" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Email : </b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobTrackingDS/Header/OriginEmail" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Pickup Window : </b>
                                                        </td>
                                                        <td align="left">
                                                          <xsl:value-of select="JobTrackingDS/Header/OriginWindow" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left">
                                                          <b>Time Zone : </b>
                                                        </td>
                                                        <xsl:if test="((JobTrackingDS/Header/OriginCity != '') or (JobTrackingDS/Header/OriginStateCode != '') or  (JobTrackingDS/Header/OriginPostalCode != ''))">
                                                          <td align="left">
                                                            <xsl:value-of select="JobTrackingDS/Header/OriginTimeZone" />
                                                          </td>
                                                        </xsl:if>
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
                                                <td align="left" width="30%">
                                                  <b>Destination : </b>
                                                </td>
                                                <td align="left" width="70%">
                                                  <xsl:value-of select="JobTrackingDS/Header/DestinationSiteName" />
                                                </td>
                                              </tr>
                                              <xsl:if test="JobTrackingDS/Header/DestinationAddress != ''">
                                                <tr>
                                                  <td align="left">
                                                    <b>Address : </b>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationAddress" />
                                                  </td>
                                                </tr>
                                              </xsl:if>
                                              <xsl:if test="JobTrackingDS/Header/DestinationAddress1 != ''">
                                                <tr>
                                                  <td align="left"> </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationAddress1" />
                                                  </td>
                                                </tr>
                                              </xsl:if>
                                              <xsl:if test="JobTrackingDS/Header/DestinationAddress2 != ''">
                                                <tr>
                                                  <td align="left"> </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationAddress2" />
                                                  </td>
                                                </tr>
                                              </xsl:if>
                                              <xsl:if test="JobTrackingDS/Header/DestinationAddress3 != ''">
                                                <tr>
                                                  <td align="left"> </td>
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationAddress3" />
                                                  </td>
                                                </tr>
                                              </xsl:if>
                                              <tr>
                                                <td> </td>
                                                <xsl:choose>
                                                  <xsl:when test="JobTrackingDS/Header/DestinationCity != ''">
                                                    <td align="left">
                                                      <xsl:value-of select="JobTrackingDS/Header/DestinationCity" /> , <xsl:value-of select="JobTrackingDS/Header/DestinationStateCode" /> <span> </span> <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text> <xsl:value-of select="JobTrackingDS/Header/DestinationPostalCode" />
                                                    </td>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                    <td>
                                                      <xsl:value-of select="JobTrackingDS/Header/DestinationStateCode" />
                                                      <span> </span>
                                                      <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                                                      <xsl:value-of select="JobTrackingDS/Header/DestinationPostalCode" />
                                                    </td>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Country : </b>
                                                </td>
                                                <xsl:if test="((JobTrackingDS/Header/DestinationCity != '') or (JobTrackingDS/Header/DestinationStateCode != '') or  (JobTrackingDS/Header/DestinationPostalCode != ''))">
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationCountry" />
                                                  </td>
                                                </xsl:if>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Contact : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/DestinationContactName" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Phone : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/DestinationPhoneNumber" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Email : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/DestinationEmail" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Delivery Window : </b>
                                                </td>
                                                <td align="left">
                                                  <xsl:value-of select="JobTrackingDS/Header/DestinationWindow" />
                                                </td>
                                              </tr>
                                              <tr>
                                                <td align="left">
                                                  <b>Time Zone : </b>
                                                </td>
                                                <xsl:if test="((JobTrackingDS/Header/DestinationCity != '') or (JobTrackingDS/Header/DestinationStateCode != '') or  (JobTrackingDS/Header/DestinationPostalCode != ''))">
                                                  <td align="left">
                                                    <xsl:value-of select="JobTrackingDS/Header/DestinationTimeZone" />
                                                  </td>
                                                </xsl:if>
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
                                        <xsl:value-of select="JobTrackingDS/Header/DriverAlert" />
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
                            <table id="ucrBOL1_grdShipmentItems" border="1" cellpadding="0" cellspacing="0" rules="all" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; WIDTH: 100%; BORDER-COLLAPSE: collapse; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;font-family : Calibri;font-size: 12px;">
                              <tbody>
                                <tr align="middle" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid; font-family : Calibri;font-size: 12px;">
                                  <th scope="col"> Item </th>
                                  <th scope="col"> Part Code </th>
                                  <th scope="col"> Serial Number </th>
                                  <th scope="col"> Title </th>
                                  <th scope="col"> Qty Ord </th>
                                  <th scope="col"> Pkg Type </th>
                                  <th scope="col"> Qty Unit </th>
                                  <th scope="col"> Weight </th>
                                  <th scope="col"> Cubes </th>
                                </tr>
                                <xsl:for-each select="JobTrackingDS/CargoDetails">
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
                        <td colspan="2" width="100%">
                          <table border="0" cellpadding="0" cellspacing="0">
                            <tbody>
                              <tr>
                                <td width="30%" colspan="2">
                                  <b> Tracking : </b>
                                </td>
                              </tr>
                            </tbody>
                          </table>
                        </td>
                      </tr>
                      <tr>
                        <td width="100%" colspan="2">
                          <div>
                            <table id="ucrTracking1_grdTrackingItems" border="1" cellpadding="0" cellspacing="0" rules="all" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; WIDTH: 100%; BORDER-COLLAPSE: collapse; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;font-family : Calibri;font-size: 12px;">
                              <tbody>
                                <tr align="middle" style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid; font-family : Calibri;font-size: 12px;">
                                  <th scope="col"> Item </th>
                                  <th scope="col"> Code </th>
                                  <th scope="col"> Title </th>
                                  <th scope="col"> Type </th>
                                  <th scope="col"> Date </th>
                                  <!--<th scope="col"> ScheduledDate </th>-->
                                </tr>
                                <xsl:for-each select="JobTrackingDS/TrackingDetails">
                                  <tr align="middle" style="HEIGHT: 19px" valign="center">
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="5%">
                                      <xsl:value-of select="ItemNumber" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="9%">
                                      <xsl:value-of select="GatewayCode" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid;word-break:break-all;" align="center" width="19%">
                                      <xsl:value-of select="GatewayTitle" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="14%" align="center">
                                      <xsl:value-of select="GatewayType" />
                                    </td>
                                    <td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="14%">
                                      <xsl:value-of select="GatewayACD" />
                                    </td>
                                    <!--<td style="BORDER-BOTTOM: 1px solid; BORDER-LEFT: 1px solid; BORDER-TOP: 1px solid; BORDER-RIGHT: 1px solid" width="13%">
                                      <xsl:call-template name="FormatDayMonYear">
                                        <xsl:with-param name="DateTime" select="ScheduledDate" />
                                      </xsl:call-template>
                                    </td>-->
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