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
        /// <summary>
        /// Soap Method to pass xCBL XML data to the web serivce
        /// </summary>
        /// <param name="ShippingSchedule">XmlElement the xCBL XML data to parse</param>
        /// <returns>XElement - XML Message Acknowledgement response indicating Success or Failure</returns>
        public XElement SubmitDocument()
        {
            try
            {

                // Get the entire Soap request text to parse the xCBL XML ShippingSchedule 
                Message request = OperationContext.Current.RequestContext.RequestMessage;

                xml = request.ToString();
                XmlDocument xmlDoc = new XmlDocument();
                xCblServiceUser = new XCBL_User();
                xmlDoc.LoadXml(xml);
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.1", "SOAP Request Received", "Process Information", "", "");

                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                int index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Credentials", "");//MeridianGlobalConstants.CREDENTIAL_NAMESPACE);

                // Retrieve the first soap headers, this should be the Credentials tag
                MessageHeaderInfo header = OperationContext.Current.IncomingMessageHeaders[index];

                // Authenticate the user credentials and process the xCBL data
                if (Meridian_AuthenticateUser(header, index, ref xCblServiceUser))
                {
                    //Meridian_ReplaceSpecialCharacters
                    xml =  Meridian_ReplaceSpecialCharacters(xml);
                    xmlDoc.LoadXml(xml);
                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.3", "Reading XCBL File  - Success", "Process Information", "", "");


                    string xmlResponse;
                    xmlResponse = xcblProcessXML(xmlDoc);

                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.4", "Reading XCBL File  - Success", "Process Information", "", "");
                    return XElement.Parse(xmlResponse);

                }
                else
                {
                    //Handling the exception if Web Username/Password is invalid.
                    String status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_AuthenticateUser", "1.4", "Error - The Incorrect Username /  Password", "", "", "");

                    return XElement.Parse(GetMeridian_Status(status, string.Empty));
                }
            }
            catch
            {
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_AuthenticateUser", "1.7", "Error - The Soap Request was invalid", "", "", "");
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
        private string xcblProcessXML(XmlDocument xmlDoc)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            string filePath = string.Empty;

            StringBuilder csvoutput = new StringBuilder();
            csvoutput.AppendLine(MeridianGlobalConstants.CSV_HEADER_NAMES);
            ShippingSchedule xCBL = new ShippingSchedule();

            XmlNamespaceManager nsMgr = new XmlNamespaceManager(xmlDoc.NameTable);
            nsMgr.AddNamespace("default", "rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd");
            nsMgr.AddNamespace("core", "rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd");

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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.11", "Error - The SCHEDULE_ID not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.12", "Error - The XCBL_SCHEDULE_ISSUED_DATE not found.", "Custom Exception", "", "");
                        }
                    }


                    XmlNode xnScheduleReferences = element.SelectSingleNode(MeridianGlobalConstants.XCBL_SCHEDULE_REFERENCES, nsMgr);

                    if (xnScheduleReferences == null)
                    {
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.9", "Error - The SCHEDULE_REFERENCES not found.", "Custom Exception", "", xCBL.ScheduleID);
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.6", "Error - There was an exception retrieving the Purchase Order References.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.5", "Error - There was an exception retrieving the Reference Codes.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.13", "Error - The XCBL_PURPOSE_CODED not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.14", "Error - The XCBL_SCHEDULE_TYPE_CODED not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.15", "Error - The XCBL_AGENCY_CODED not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.16", "Error - The XCBL_NAME not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.17", "Error - The XCBL_STREET not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.18", "Error - The XCBL_STREET_SUPPLEMENT not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.19", "Error - The XCBL_POSTAL_CODE not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.20", "Error - The XCBL_CITY not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.21", "Error - The XCBL_REGION_CODED not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.22", "Error - The XCBL_CONTACT_NAME not found.", "Custom Exception", "", "");
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
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.8", "Warning - The Contact Names not found.", "Custom Exception", "", xCBL.ScheduleID);
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
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.4", "Error - There was an exception retrieving the contact nubmers.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.22", "Error - The XCBL_SHIPPING_INSTRUCTIONS not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.23", "Error - The XCBL_GPS_SYSTEM not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.23", "Error - The XCBL_LATITUDE not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.24", "Error - The XCBL_LONGITUDE not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.25", "Error - The XCBL_LOCATION_ID not found.", "Custom Exception", "", "");
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.26", "Error - The XCBL_ESTIMATED_ARRIVAL_DATE not found.", "Custom Exception", "", "");
                        }
                    }


                    // preparing string builder data which needs to be written to CSV file.
                    csvoutput.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35}",
                        Meridian_ReplaceSpecialCharacters(xCBL.ScheduleID), Meridian_ReplaceSpecialCharacters(xCBL.ScheduleIssuedDate), Meridian_ReplaceSpecialCharacters(xCBL.OrderNumber), Meridian_ReplaceSpecialCharacters(xCBL.SequenceNumber), Meridian_ReplaceSpecialCharacters(xCBL.Other_FirstStop), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before7), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before9), Meridian_ReplaceSpecialCharacters(xCBL.Other_Before12), Meridian_ReplaceSpecialCharacters(xCBL.Other_SameDay), Meridian_ReplaceSpecialCharacters(xCBL.Other_OwnerOccupied),
                        Meridian_ReplaceSpecialCharacters(xCBL.Other_7), Meridian_ReplaceSpecialCharacters(xCBL.Other_8), Meridian_ReplaceSpecialCharacters(xCBL.Other_9), Meridian_ReplaceSpecialCharacters(xCBL.Other_10), Meridian_ReplaceSpecialCharacters(xCBL.PurposeCoded), Meridian_ReplaceSpecialCharacters(xCBL.ScheduleType), Meridian_ReplaceSpecialCharacters(xCBL.AgencyCoded), Meridian_ReplaceSpecialCharacters(xCBL.Name1), Meridian_ReplaceSpecialCharacters(xCBL.Street), Meridian_ReplaceSpecialCharacters(xCBL.StreetSupplement1), Meridian_ReplaceSpecialCharacters(xCBL.PostalCode), Meridian_ReplaceSpecialCharacters(xCBL.City), Meridian_ReplaceSpecialCharacters(xCBL.RegionCoded),
                        Meridian_ReplaceSpecialCharacters(xCBL.ContactName), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_1), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_2), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_3), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_4), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_5), Meridian_ReplaceSpecialCharacters(xCBL.ContactNumber_6), Meridian_ReplaceSpecialCharacters(xCBL.ShippingInstruction), Meridian_ReplaceSpecialCharacters(xCBL.GPSSystem), xCBL.Latitude.ToString(),
                        xCBL.Longitude.ToString(), Meridian_ReplaceSpecialCharacters(xCBL.LocationID), Meridian_ReplaceSpecialCharacters(xCBL.EstimatedArrivalDate)));

                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.5", "SOAP Request Parsed Successfully", "Process Information", "", "");

                    string pathDesktop = string.Empty;
                    try
                    {
                        //Creating the CSV file on the Server Desktop - (Webservice hosted)
                        pathDesktop = System.Configuration.ConfigurationManager.AppSettings["CsvPath"].ToString();
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if CSV file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.10", "Error - The Server path does not Exist while copying the files to FTP Server.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }

                    filePath = string.Format("{0}\\{1}{2}{3}", pathDesktop, MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT), MeridianGlobalConstants.XCBL_FILE_EXTENSION);
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

                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.6", "Creating CSV File - Success", "Process Information", "", "");
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if CSV file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.2", "Error - The CSV file cannot be created or closed.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }

                    // This should be updated to use the XCBL_User xCblServiceUser variable that contains the FTP server url, FTP username, and FTP password
                    // Make sure the xCblServiceUser object is not null for the FTP credentials
                    try
                    {
                        Meridian_FTPUpload(MeridianGlobalConstants.FTP_SERVER_CSV_URL, xCblServiceUser.FtpUsername, xCblServiceUser.FtpPassword, filePath, xCblServiceUser, xCBL.ScheduleID);
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.7", "Uploaded CSV File to FTP Site", "Process Information", "", "");

                    }
                    catch (Exception e)
                    {
                        //Handling the exception if any FTP Error occurs while transferring the CSV file.
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "1.8", "Error - The FTP Error while transferring the CSV file.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, xCBL.ScheduleID);
                    }



                    try
                    {
                        //Creating the CSV file on the Server Desktop - (Webservice hosted)
                        pathDesktop = System.Configuration.ConfigurationManager.AppSettings["CsvPath"].ToString();
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if CSV file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.10", "Error - The Server path does not Exist while copying the files to FTP Server.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }


                    //Start XML file Creation & Ftp Upload xml file
                    //Added by  Ramkumar on June-20-16 for XML file Generation after removing the Special characters
                    string xmlFilePath = string.Format("{0}\\{1}{2}{3}", pathDesktop, MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT), MeridianGlobalConstants.XCBL_XML_EXTENSION);
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
                            MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.8", "Creating XML File - Success", "Process Information", "", "");
                        }
                        else
                        {
                        
                        }
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if XML file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.9", "Error - The XML file cannot be created or closed.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(status, xCBL.ScheduleID);
                    }

                    // This should be updated to use the XCBL_User xCblServiceUser variable that contains the FTP server url, FTP username, and FTP password
                    // Make sure the xCblServiceUser object is not null for the FTP credentials
                    try
                    {
                        Meridian_FTPUpload(MeridianGlobalConstants.FTP_SERVER_XML_URL, xCblServiceUser.FtpUsername, xCblServiceUser.FtpPassword, xmlFilePath, xCblServiceUser, xCBL.ScheduleID);
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "2.9", "Uploaded XML File to FTP Site", "Process Information", "", "");
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if any FTP Error occurs while transferring the XML file.
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "1.10", "Error - The FTP Error while transferring the XML file.", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
                        return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, xCBL.ScheduleID);
                    }
                    //End XML file Creation & Ftp Upload xml file



                }

                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
                return GetMeridian_Status(status, xCBL.ScheduleID);
            }
            catch (Exception e)
            {
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "xcblProcessXML", "1.3", "Error - The xCBL XML was not correctly formatted", Convert.ToString(e.InnerException), "", xCBL.ScheduleID);
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
