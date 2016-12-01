//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              2/6/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The web service allows the CDATA tag to not be included for AWC requirements and no WS-A addressing as requested 
//
//==================================================================================================================================================== 
using System;
using System.Data;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    public class MeridianService : IMeridianService
    {
        XCBL_User xCblServiceUser = null;
        string xml = string.Empty;

        string sCsvFileName;

        /// <summary>
        /// Soap Method to pass xCBL XML data to the web serivce
        /// </summary>
        /// <param name="ShippingSchedule">XmlElement the xCBL XML data to parse</param>
        /// <returns>XElement - XML Message Acknowledgement response indicating Success or Failure</returns>
        public XElement SubmitDocument()
        {
            try
            {
                sCsvFileName = string.Empty;
                // Get the entire Soap request text to parse the xCBL XML ShippingSchedule 
                Message request = OperationContext.Current.RequestContext.RequestMessage;

                xml = request.ToString();
                XmlDocument xmlDoc = new XmlDocument();
                xCblServiceUser = new XCBL_User();
                xmlDoc.LoadXml(xml);
                MeridianSystemLibrary.sysInsertTransactionRecord("No WebUser", "No FTPUser", "Meridian_SendScheduleMessage", "1.1", "Success - SOAP Request Received", "Submit Document Process", "No FileName", "No Schedule ID","No Order NO", null,"Success");

                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                int index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Credentials", "");

                // Retrieve the first soap headers, this should be the Credentials tag
                MessageHeaderInfo header = OperationContext.Current.IncomingMessageHeaders[index];

                // Authenticate the user credentials and process the xCBL data
                if (Meridian_AuthenticateUser(header, index, ref xCblServiceUser))
                {
                    //Meridian_ReplaceSpecialCharacters
                    xml = Meridian_ReplaceSpecialCharacters(xml);
                    xmlDoc.LoadXml(xml);
                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.3", "Success - Reading XCBL File", "Process Special Characters", "No FileName", "No Schedule ID", "No Order NO", null, "Success");


                    string xmlResponse;
                    xmlResponse = xcblProcessXML(xmlDoc, sCsvFileName);

                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.4", "Success - Reading XCBL File", "Process xCBL Object Complete", "No FileName", "No Schedule ID", "No Order NO", null, "Success");
                    return XElement.Parse(xmlResponse);

                }
                else
                {
                    //Handling the exception if Web Username/Password is invalid.
                    String status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                    MeridianSystemLibrary.sysInsertTransactionRecord("No WebUser", "No FTP User", "Meridian_AuthenticateUser", "2.4", "Error - The Incorrect Username /  Password", "Authentication Failed", "No FileName", "No Schedule ID", "No Order NO", null, "Error 1 - Incorrect Credentials");

                    return XElement.Parse(GetMeridian_Status(status, string.Empty));
                }
            }
            catch
            {
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_AuthenticateUser", "2.7", "Error - The Soap Request was invalid", "xCBL Parsing Failed", "No FileName", "No Schedule ID", "No Order NO", null, "Error 2 - xCBL Parsing");
                return XElement.Parse(GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, string.Empty));
            }
        }

        /// <summary>
        /// The function which replaces the special characters (Comma, Carriage return and Line Feed) to space found in the xml String
        /// </summary>
        /// <param name="xmlData">Xml Data</param>
        private string Meridian_ReplaceSpecialCharacters(string xmlData)
        {
            try
            {
                if (xmlData != null)
                {
                    char charLineFeed = (char)10;
                    char charCarriageReturn = (char)13;
                    char charComma = (char)44;

                    if (xmlData.IndexOf(charCarriageReturn) != -1)
                        xmlData = xmlData.Replace(charCarriageReturn.ToString(), " ");

                    if (xmlData.IndexOf(charLineFeed) != -1)
                        xmlData = xmlData.Replace(charLineFeed.ToString(), " ");

                    if (xmlData.IndexOf(charComma) != -1)
                        xmlData = xmlData.Replace(charComma.ToString(), " ");
                }
                return xmlData;
            }
            catch
            {
                return xmlData;
            }
        }

        /// <summary>
        /// This is the function that will parse the xCBL Shipping Schedule XML data from the web request
        /// </summary>
        /// <param name="xmlDoc">XmlDocument - xCBL Shipping Schedule Data</param>
        /// <returns>String - Returns the string Message Acknowledgement</returns>
        private string xcblProcessXML(XmlDocument xmlDoc, string sCsvFileName)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            string filePath = string.Empty;

            StringBuilder csvoutput = new StringBuilder();
            csvoutput.AppendLine(MeridianGlobalConstants.CSV_HEADER_NAMES);
            ShippingSchedule xCBL = new ShippingSchedule();

            XmlNamespaceManager nsMgr = new XmlNamespaceManager(xmlDoc.NameTable);
            nsMgr.AddNamespace("default", "rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd");
            nsMgr.AddNamespace("core", "rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd");



            //Set "No Schedule ID" for Empty ScheduleID
            sCsvFileName = string.IsNullOrEmpty(sCsvFileName) ? "No FileName" : sCsvFileName;

            try
            {
                XmlNodeList shippingElement = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER);

                //Find the Shipping schedule tag and getting the Inner Xml of its Node
                XmlNodeList shippingScheduleNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Http);//Http Request creating this tag
                if (shippingScheduleNode_xml.Count == 0)
                {
                    shippingScheduleNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Https);//Https Request creating this tag
                }


                // There should only be one element in the Shipping Schedule request, but this should handle multiple ones
                foreach (XmlNode element in shippingElement)
                {
                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_ID, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.ScheduleID = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_ID, nsMgr).InnerText;
                        }
                        catch
                        {
                            xCBL.ScheduleID = string.Empty;
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "2.1", "Error - The SCHEDULE_ID not found.", "Exception - Schedule ID", sCsvFileName, "No Schedule ID", "No Order NO", null, "Error 3 - SCHEDULE_ID not found");
                        }

                        finally
                        {
                            //Set "No Schedule ID" for Empty ScheduleID
                            xCBL.ScheduleID = string.IsNullOrEmpty(xCBL.ScheduleID) ? "No Schedule ID" : xCBL.ScheduleID;
                        }
                    }


                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_ISSUED_DATE, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.ScheduleIssuedDate = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_ISSUED_DATE, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.12", "Warning - The XCBL_SCHEDULE_ISSUED_DATE not found.", "Exception - Schedule Issue Date", sCsvFileName, xCBL.ScheduleID, "No Order NO", null, "Warning 1 - XCBL_SCHEDULE_ISSUED_DATE not found");
                        }
                    }


                    XmlNode xnScheduleReferences = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_REFERENCES, nsMgr);

                    if (xnScheduleReferences == null)
                    {
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.9", "Warning - The SCHEDULE_REFERENCES not found.", "Exception - Schedule References", sCsvFileName, xCBL.ScheduleID, "No Order NO", null, "Warning 2 - SCHEDULE_REFERENCES not found");
                    }

                    else if (xnScheduleReferences != null)
                    {
                        try
                        {
                            XmlNode xnPurchaseOrderReferences = xnScheduleReferences.SelectSingleNode(MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE, nsMgr);
                            XmlNodeList xnlPurchaseOrderReferences = xnPurchaseOrderReferences.ChildNodes;

                            for (int iPurchaseOrderIndex = 0; iPurchaseOrderIndex < xnlPurchaseOrderReferences.Count; iPurchaseOrderIndex++)
                            {
                                if (xnlPurchaseOrderReferences[iPurchaseOrderIndex].Name.Contains(MeridianGlobalConstants.XCBL_SELLER_ORDER_NUMBER))
                                    xCBL.OrderNumber = xnlPurchaseOrderReferences[iPurchaseOrderIndex].InnerText;

                                if (xnlPurchaseOrderReferences[iPurchaseOrderIndex].Name.Contains(MeridianGlobalConstants.XCBL_CHANGE_ORDER_SEQUENCE_NUMBER))
                                    xCBL.SequenceNumber = xnlPurchaseOrderReferences[iPurchaseOrderIndex].InnerText;
                            }
                        }
                        catch (Exception e)
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.6", "Warning - There was an exception retrieving the Purchase Order References.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, "No Order NO", xmlDoc, "Warning 3 - OrderNO not found");
                        }

                        // Loop through all the Other Schedule Reference tags, there can be up to 10
                        try
                        {
                            XmlNode xnOtherScheduleReferences = xnScheduleReferences.SelectSingleNode(MeridianGlobalConstants.XCBL_OTHER_SCHEDULE_REFERENCES, nsMgr);

                            XmlNodeList xnReferenceCoded = xnOtherScheduleReferences.ChildNodes;

                            for (int iReferenceCodedIndex = 0; iReferenceCodedIndex < xnReferenceCoded.Count; iReferenceCodedIndex++)
                            {
                                XmlNodeList xnReferences = xnReferenceCoded[iReferenceCodedIndex].ChildNodes;
                                for (int iReferencesIndex = 0; iReferencesIndex < xnReferences.Count; iReferencesIndex++)
                                {
                                    if (xnReferences[iReferencesIndex].Name.Contains(MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION))
                                    {
                                        SetOtherScheduleReference(xnReferences[iReferencesIndex].InnerText, ref xCBL, iReferenceCodedIndex);
                                    }
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.5", "Warning - There was an exception retrieving the Reference Codes.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 4 - ReferenceCodes not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_PURPOSE_CODED, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.PurposeCoded = element.SelectSingleNode(MeridianGlobalConstants.XCBL_PURPOSE_CODED, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.13", "Warning - The XCBL_PURPOSE_CODED not found.", "Exception - Purpose Coded", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 5 - XCBL_PURPOSE_CODED not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.ScheduleType = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.14", "Warning - The XCBL_SCHEDULE_TYPE_CODED not found.", "Exception - Schedule Type", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 6 - XCBL_SCHEDULE_TYPE_CODED not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_AGENCY_CODED, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.AgencyCoded = element.SelectSingleNode(MeridianGlobalConstants.XCBL_AGENCY_CODED, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.15", "Warning - The XCBL_AGENCY_CODED not found.", "Exception - Agency Code", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 7 - XCBL_AGENCY_CODED not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_NAME, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.Name1 = element.SelectSingleNode(MeridianGlobalConstants.XCBL_NAME, nsMgr).InnerText;
                            //Modified on 14-april-16  by Ramkumar(Dreamorbit) on Client(Geoff) request to remove comma and replace it with space
                            xCBL.Name1 = xCBL.Name1.Replace(",", "");
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.16", "Warning - The XCBL_NAME not found.", "Exception - Name", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 8 - XCBL_NAME not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_STREET, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.Street = element.SelectSingleNode(MeridianGlobalConstants.XCBL_STREET, nsMgr).InnerText;
                            //Modified on 14-april-16  by Ramkumar(Dreamorbit) on Client(Geoff) request to remove comma and replace it with space
                            xCBL.Street = xCBL.Street.Replace(",", "");
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.17", "Warning - The XCBL_STREET not found.", "Exception - Street", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 9 - Street not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_STREET_SUPPLEMENT, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.StreetSupplement1 = element.SelectSingleNode(MeridianGlobalConstants.XCBL_STREET_SUPPLEMENT, nsMgr).InnerText;
                            //Modified on 14-april-16  by Ramkumar(Dreamorbit) on Client(Geoff) request to remove comma and replace it with space
                            xCBL.StreetSupplement1 = xCBL.StreetSupplement1.Replace(",", "");
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.18", "Warning - The XCBL_STREET_SUPPLEMENT not found.", "Exception - Street Supplement", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 10 - XCBL_STREET_SUPPLEMENT not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_POSTAL_CODE, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.PostalCode = element.SelectSingleNode(MeridianGlobalConstants.XCBL_POSTAL_CODE, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.19", "Warning - The XCBL_POSTAL_CODE not found.", "Exception - Postal Code", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 11 - PostalCode not found");
                        }
                    }


                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_CITY, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.City = element.SelectSingleNode(MeridianGlobalConstants.XCBL_CITY, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.20", "Warning - The XCBL_CITY not found.", "Exception - City", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 12 - CITY not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_REGION_CODED, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.RegionCoded = element.SelectSingleNode(MeridianGlobalConstants.XCBL_REGION_CODED, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.21", "Warning - The XCBL_REGION_CODED not found.", "Exception - Region Coded", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 13 - Region Coded not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_CONTACT_NAME, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.ContactName = element.SelectSingleNode(MeridianGlobalConstants.XCBL_CONTACT_NAME, nsMgr).InnerText;
                            //Modified on 14-april-16  by Ramkumar(Dreamorbit) on Client(Geoff) request to remove comma and replace it with space
                            xCBL.ContactName = xCBL.ContactName.Replace(",", "");
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.22", "Warning - The XCBL_CONTACT_NAME not found.", "Exception - Contact Name", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 14 - Contact Name not found");
                        }
                    }


                    // Need to try and loop through all the contact numbers, there can be up to 6
                    try
                    {
                        if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBERS, nsMgr) != null)
                        {
                            XmlNode xnContactNames = element.SelectSingleNode(MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBERS, nsMgr);


                            if (xnContactNames == null && xnContactNames.ChildNodes == null)
                            {
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.8", "Warning - The Contact Number not found.", "Exception - Contact Number", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 15 - Contact Name not found");
                            }

                            else if (xnContactNames != null && xnContactNames.ChildNodes != null)
                            {
                                XmlNodeList xnlContactNames = xnContactNames.ChildNodes;

                                for (int iContactNameIndex = 0; iContactNameIndex < xnlContactNames.Count; iContactNameIndex++)
                                {
                                    XmlNodeList xnlContactValues = xnlContactNames[iContactNameIndex].ChildNodes;
                                    for (int iContactValuesIndex = 0; iContactValuesIndex < xnlContactValues.Count; iContactValuesIndex++)
                                    {
                                        if (xnlContactValues[iContactValuesIndex].Name.Contains(MeridianGlobalConstants.XCBL_CONTACT_VALUE))
                                        {
                                            SetContactNumbers(xnlContactValues[iContactValuesIndex].InnerText, ref xCBL, iContactNameIndex);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.4", "Warning - There was an exception retrieving the contact numbers.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 16 - contact numbers not found");
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_SHIPPING_INSTRUCTIONS, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.ShippingInstruction = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SHIPPING_INSTRUCTIONS, nsMgr).InnerText;
                            //Modified on 14-april-16  by Ramkumar(Dreamorbit) on Client(Geoff) request to remove comma and replace it with space
                            xCBL.ShippingInstruction = xCBL.ShippingInstruction.Replace(",", "");
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.22", "Warning - The XCBL_SHIPPING_INSTRUCTIONS not found.", "Exception - Shipping Instructions", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 17 - Shipping Instructions not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_GPS_SYSTEM, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.GPSSystem = element.SelectSingleNode(MeridianGlobalConstants.XCBL_GPS_SYSTEM, nsMgr).InnerText;

                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.23", "Warning - The XCBL_GPS_SYSTEM not found.", "Exception - GPS System", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 18 - Gps System not found");
                        }
                    }


                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_LATITUDE, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.Latitude = double.Parse(element.SelectSingleNode(MeridianGlobalConstants.XCBL_LATITUDE, nsMgr).InnerText);

                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.23", "Warning - The XCBL_LATITUDE not found.", "Exception - Latitude", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 19 - Latitude not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_LONGITUDE, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.Longitude = double.Parse(element.SelectSingleNode(MeridianGlobalConstants.XCBL_LONGITUDE, nsMgr).InnerText);


                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.24", "Warning - The XCBL_LONGITUDE not found.", "Exception - Longitude", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 20 - Longitude not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_LOCATION_ID, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.LocationID = element.SelectSingleNode(MeridianGlobalConstants.XCBL_LOCATION_ID, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.25", "Warning - The XCBL_LOCATION_ID not found.", "Exception - Location ID", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 21 - Location not found");
                        }
                    }

                    if (element.SelectSingleNode(MeridianGlobalConstants.XCBL_ESTIMATED_ARRIVAL_DATE, nsMgr) != null)
                    {

                        try
                        {
                            xCBL.EstimatedArrivalDate = element.SelectSingleNode(MeridianGlobalConstants.XCBL_ESTIMATED_ARRIVAL_DATE, nsMgr).InnerText;
                        }
                        catch
                        {
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.26", "Warning - The XCBL_ESTIMATED_ARRIVAL_DATE not found.", "Exception - Estimated Arrival Date", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 22 - Arrival Date not found");
                        }
                    }


                    // preparing string builder data which needs to be written to CSV file.
                    csvoutput.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35}",
                        Meridian_ReplaceSpecialCharacters(xCBL.ScheduleID), Meridian_ReplaceSpecialCharacters(xCBL.ScheduleIssuedDate), Meridian_ReplaceSpecialCharacters(xCBL.OrderNumber), Meridian_ReplaceSpecialCharacters(xCBL.SequenceNumber), Meridian_ReplaceSpecialCharacters(xCBL.Other_FirstStop), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before7), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before9), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before12), Meridian_ReplaceSpecialCharacters(xCBL.Other_SameDay), Meridian_ReplaceSpecialCharacters(xCBL.Other_OwnerOccupied),
                        Meridian_ReplaceSpecialCharacters(xCBL.Other_7), Meridian_ReplaceSpecialCharacters(xCBL.Other_8), Meridian_ReplaceSpecialCharacters(xCBL.Other_9), Meridian_ReplaceSpecialCharacters(xCBL.Other_10), Meridian_ReplaceSpecialCharacters(xCBL.PurposeCoded), Meridian_ReplaceSpecialCharacters(xCBL.ScheduleType), Meridian_ReplaceSpecialCharacters(xCBL.AgencyCoded), Meridian_ReplaceSpecialCharacters(xCBL.Name1), Meridian_ReplaceSpecialCharacters(xCBL.Street), Meridian_ReplaceSpecialCharacters(xCBL.StreetSupplement1), Meridian_ReplaceSpecialCharacters(xCBL.PostalCode), Meridian_ReplaceSpecialCharacters(xCBL.City), Meridian_ReplaceSpecialCharacters(xCBL.RegionCoded),
                        Meridian_ReplaceSpecialCharacters(xCBL.ContactName), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_1), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_2), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_3), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_4), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_5), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_6), Meridian_ReplaceSpecialCharacters(xCBL.ShippingInstruction), Meridian_ReplaceSpecialCharacters(xCBL.GPSSystem), xCBL.Latitude.ToString(),
                        xCBL.Longitude.ToString(), Meridian_ReplaceSpecialCharacters(xCBL.LocationID), Meridian_ReplaceSpecialCharacters(xCBL.EstimatedArrivalDate)));



                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.5", "Success - SOAP Request Parsed", "Process xCBL Parsed", "No FileName", xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Success");

                    string pathDesktop = string.Empty;
                    string dateFormatYYMonSS = DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT);

                    // Create and upload CSV file to FTP site
                    try
                    {


                        //Creating the CSV file on the Server Desktop - (Webservice hosted)
                        pathDesktop = System.Configuration.ConfigurationManager.AppSettings["CsvPath"].ToString();
                        filePath = string.Format("{0}\\{1}{2}{3}", pathDesktop, MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, dateFormatYYMonSS, MeridianGlobalConstants.XCBL_FILE_EXTENSION);

                        if (File.Exists(filePath))
                        {
                            //Delete file  if already exists on server path.
                            File.Delete(filePath);
                        }


                        try
                        {
                            // Finally writing the xCBL Data to CSV file.
                            File.Create(filePath).Close();
                            File.AppendAllText(filePath, csvoutput.ToString());
                            sCsvFileName = Path.GetFileName(filePath);
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.6", "Success - Creating CSV File - Success", "Process CSV Output", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Success");

                            // This should be updated to use the XCBL_User xCblServiceUser variable that contains the FTP server url, FTP username, and FTP password
                            // Make sure the xCblServiceUser object is not null for the FTP credentials
                            try
                            {
                                Meridian_FTPUpload(MeridianGlobalConstants.FTP_SERVER_CSV_URL, xCblServiceUser.FtpUsername, xCblServiceUser.FtpPassword, filePath, xCblServiceUser, xCBL.ScheduleID);
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.7", "Success - Uploaded CSV File to FTP Site", "Process FTP CSV Upload", sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Success");

                            }
                            catch (Exception e)
                            {
                                //Handling the exception if any FTP Error occurs while transferring the CSV file.
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "2.8", "Error - The FTP Error while transferring the CSV file.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Error 4 - FTP CSV");
                                return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, xCBL.ScheduleID);
                            }
                        }
                        catch (Exception e)
                        {
                            //Handling the exception if CSV file is not valid.
                            status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "2.2", "Error - The CSV file cannot be created or closed.", Convert.ToString(e.Message), string.IsNullOrEmpty(sCsvFileName) ? "No FileName" : sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Error 5 - Create CSV");
                            return GetMeridian_Status(status, xCBL.ScheduleID);
                        }
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if CSV file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "2.10", "Error - The Server path does not Exist while copying the files to FTP Server.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID,  xCBL.OrderNumber, xmlDoc, "Error 6 - FTP Server Path");
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }

                    // Create and upload XML file to FTP site
                    try
                    {
                        //Creating the XML file on the Server Desktop - (Webservice hosted)
                        pathDesktop = System.Configuration.ConfigurationManager.AppSettings["XmlPath"].ToString();

                        //Start XML file Creation & Ftp Upload xml file
                        //Added by  Ramkumar on June-20-16 for XML file Generation after removing the Special characters
                        string xmlFilePath = string.Format("{0}\\{1}{2}{3}", pathDesktop, MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, dateFormatYYMonSS, MeridianGlobalConstants.XCBL_XML_EXTENSION);
                        string sXmlFileName = Path.GetFileName(xmlFilePath);

                        if (File.Exists(xmlFilePath))
                        {
                            //Delete file  if already exists on server path.
                            File.Delete(xmlFilePath);
                        }
                        try
                        {
                            if (shippingScheduleNode_xml.Count > 0)
                            {
                                // Finally writing the xCBL Data to XML file.
                                File.Create(xmlFilePath).Close();
                                File.AppendAllText(xmlFilePath, Meridian_ReplaceSpecialCharacters(shippingScheduleNode_xml[0].InnerXml.ToString()));
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.8", "Success - Creating XML File", "Process Delete XML", sXmlFileName, xCBL.ScheduleID , xCBL.OrderNumber, xmlDoc, "Success");
                                // This should be updated to use the XCBL_User xCblServiceUser variable that contains the FTP server url, FTP username, and FTP password
                                // Make sure the xCblServiceUser object is not null for the FTP credentials
                                try
                                {
                                    Meridian_FTPUpload(MeridianGlobalConstants.FTP_SERVER_XML_URL, xCblServiceUser.FtpUsername, xCblServiceUser.FtpPassword, xmlFilePath, xCblServiceUser, xCBL.ScheduleID);
                                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.9", "Success - Uploaded XML File to FTP Site", "Process FTP XML Upload", sXmlFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Success");
                                }
                                catch (Exception e)
                                {
                                    //Handling the exception if any FTP Error occurs while transferring the XML file.
                                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "3.10", "Warning - The FTP Error while transferring the XML file.", Convert.ToString(e.Message), sXmlFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 23 - FTP XML");
                                    return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS, xCBL.ScheduleID);
                                }
                                //End XML file Creation & Ftp Upload xml file
                            }

                        }
                        catch (Exception e)
                        {
                            //Handling the exception if XML file is not valid.
                            status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.9", "Warning - The XML file cannot be created or closed.", Convert.ToString(e.Message), sXmlFileName, xCBL.ScheduleID,xCBL.OrderNumber, xmlDoc, "Warning 24 - Create XML");
                            return GetMeridian_Status(status, xCBL.ScheduleID);
                        }
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if XML file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "3.10", "Warning - The Server path does not Exist while copying the files to FTP Server.", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Warning 25 -  XML Path");
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }
                }

                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
                return GetMeridian_Status(status, xCBL.ScheduleID);
            }
            catch (Exception e)
            {
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.3", "Error - The xCBL XML was not correctly formatted", Convert.ToString(e.Message), sCsvFileName, xCBL.ScheduleID, xCBL.OrderNumber, xmlDoc, "Error 7 - xCBL Parse");
                return GetMeridian_Status(status, xCBL.ScheduleID);
            }
        }

        /// <summary>
        /// Sets the ShippingSchedule Other Schedule Reference properties used to output the xCBL data
        /// </summary>
        /// <param name="referenceDescription">The Reference Description text to output</param>
        /// <param name="referenceType">The ShippingSchedule object that is set</param>
        /// <param name="otherScheduleReferenceIndex">The index of the Other Schedule Reference item</param>
        private void SetOtherScheduleReference(string referenceDescription, ref ShippingSchedule referenceType, int otherScheduleReferenceIndex)
        {
            switch (otherScheduleReferenceIndex)
            {
                case 0:
                    referenceType.Other_FirstStop = referenceDescription;
                    break;
                case 1:
                    referenceType.Other_Before7 = referenceDescription;
                    break;
                case 2:
                    referenceType.Other_Before9 = referenceDescription;
                    break;
                case 3:
                    referenceType.Other_Before12 = referenceDescription;
                    break;
                case 4:
                    referenceType.Other_SameDay = referenceDescription;
                    break;
                case 5:
                    referenceType.Other_OwnerOccupied = referenceDescription;
                    break;
                case 6:
                    referenceType.Other_7 = referenceDescription;
                    break;
                case 7:
                    referenceType.Other_8 = referenceDescription;
                    break;
                case 8:
                    referenceType.Other_9 = referenceDescription;
                    break;
                case 9:
                    referenceType.Other_10 = referenceDescription;
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// Sets the ShippingSchedule Contact Numbers properties used to output the xCBL data
        /// </summary>
        /// <param name="contactNumber">The Contact Number text</param>
        /// <param name="referenceType">The ShippingSchedule object that is set</param>
        /// <param name="contactNumberIndex">The index of the Contact Number item</param>
        private void SetContactNumbers(string contactNumber, ref ShippingSchedule referenceType, int contactNumberIndex)
        {
            switch (contactNumberIndex)
            {
                case 0:
                    referenceType.ContactNumber_1 = contactNumber;
                    break;
                case 1:
                    referenceType.ContactNumber_2 = contactNumber;
                    break;
                case 2:
                    referenceType.ContactNumber_3 = contactNumber;
                    break;
                case 3:
                    referenceType.ContactNumber_4 = contactNumber;
                    break;
                case 4:
                    referenceType.ContactNumber_5 = contactNumber;
                    break;
                case 5:
                    referenceType.ContactNumber_6 = contactNumber;
                    break;
                default:
                    break;
            }
        }
        /// <summary>
        /// This function will return the Success / Failure of the Action performed which tranferring the CSV file.
        /// </summary>
        /// <param name="status">string - Holds the Error Message - status</param>
        /// <param name="scheduleID">string - Unique id of the XCBL file which is to be uploaded</param>
        /// <returns></returns>
        private static String GetMeridian_Status(string status, string scheduleID)
        {
            StringBuilder messageResponse = new StringBuilder();
            messageResponse.AppendLine(MeridianGlobalConstants.XML_HEADER);
            messageResponse.AppendLine(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_OPEN_TAG);
            messageResponse.AppendLine(string.Format(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_OPEN_TAG + "{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_CLOSE_TAG, scheduleID));
            messageResponse.AppendLine(string.Format(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_OPEN_TAG + "{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_CLOSE_TAG, status));
            messageResponse.AppendLine(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG);
            return messageResponse.ToString();
        }

        /// <summary>
        /// This function will authenticate the User with Username and Password
        /// </summary>
        /// <param name="header">MessageHeaderInfo - Contains the Soap Credential Header</param>
        /// <param name="objXCBLUser">Object - Holds the user related information</param>
        /// <returns></returns>
        private bool Meridian_AuthenticateUser(MessageHeaderInfo header, int index, ref XCBL_User objXCBLUser)
        {
            try
            {
                string username = null;
                string password = null;
                string hashkey = null;


                // Retrieve the Credential header information
                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                if (header.Name == MeridianGlobalConstants.CREDENTIAL_HEADER)// && h.Namespace == MeridianGlobalConstants.CREDENTIAL_NAMESPACE)
                {
                    // read the value of that header
                    XmlReader xr = OperationContext.Current.IncomingMessageHeaders.GetReaderAtHeader(index);
                    while (xr.Read())
                    {
                        if (xr.IsStartElement())
                            if (xr.Name == MeridianGlobalConstants.CREDENTIAL_USERNAME)
                            {
                                if (xr.Read())
                                    username = xr.Value;
                            }
                            else if (xr.Name == MeridianGlobalConstants.CREDENTIAL_PASSWORD)
                            {
                                if (xr.Read())
                                    password = xr.Value;
                            }
                            else if (xr.Name == MeridianGlobalConstants.CREDENTIAL_HASHKEY)
                            {
                                if (xr.Read())
                                    hashkey = xr.Value;
                            }
                    }
                }

                if (username != null && password != null && hashkey != null)
                {
                    objXCBLUser.WebUsername = Encryption.Decrypt(username, hashkey);
                    objXCBLUser.WebPassword = Encryption.Decrypt(password, hashkey);
                    objXCBLUser = MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword(objXCBLUser);
                    return (objXCBLUser != null) ? true : false;
                }
                return false;

            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// This function will Upload CSV files to the FTP server
        /// </summary>
        /// <param name="ftpServer">string - Ftpserver URL</param>
        /// <param name="userName">string - FTP username</param>
        /// <param name="password">string - FTP Password</param>
        /// <param name="filename">string - Xcbl Filename</param>
        /// <param name="xCblServiceUser">Object - holds the user related information</param>
        /// <param name="scheduleID">string - which is unique id of the XCBL file which is to be uploaded</param>
        private static void Meridian_FTPUpload(string ftpServer, string userName, string password, string filename, XCBL_User xCblServiceUser, string scheduleID)
        {
            using (System.Net.WebClient client = new System.Net.WebClient())
            {
                client.Credentials = new System.Net.NetworkCredential(userName, password);
                client.UploadFile(string.Format("{0}/{1}", ftpServer, new FileInfo(filename).Name), "STOR", filename);
            }
        }
    }

    /// <summary>
    /// This class is used to store all the Shipping Schedule data that will be outputted to the csv file
    /// </summary>
    internal class ShippingSchedule
    {
        public string ScheduleID { get; set; }
        public string ScheduleIssuedDate { get; set; }
        public string OrderNumber { get; set; }
        public string SequenceNumber { get; set; }
        public string Other_FirstStop { get; set; }
        public string Other_Before7 { get; set; }
        public string Other_Before9 { get; set; }
        public string Other_Before12 { get; set; }
        public string Other_SameDay { get; set; }
        public string Other_OwnerOccupied { get; set; }
        public string Other_7 { get; set; }
        public string Other_8 { get; set; }
        public string Other_9 { get; set; }
        public string Other_10 { get; set; }
        public string PurposeCoded { get; set; }
        public string ScheduleType { get; set; }
        public string AgencyCoded { get; set; }
        public string Name1 { get; set; }
        public string Street { get; set; }
        public string StreetSupplement1 { get; set; }
        public string PostalCode { get; set; }
        public string City { get; set; }
        public string RegionCoded { get; set; }
        public string ContactName { get; set; }
        public string ContactNumber_1 { get; set; }
        public string ContactNumber_2 { get; set; }
        public string ContactNumber_3 { get; set; }
        public string ContactNumber_4 { get; set; }
        public string ContactNumber_5 { get; set; }
        public string ContactNumber_6 { get; set; }
        public string ShippingInstruction { get; set; }
        public string GPSSystem { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string LocationID { get; set; }
        public string EstimatedArrivalDate { get; set; }
    }
}
