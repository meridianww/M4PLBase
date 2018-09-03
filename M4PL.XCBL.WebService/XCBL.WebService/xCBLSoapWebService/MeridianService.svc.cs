﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              2/6/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The web service allows the CDATA tag to not be included for AWC requirements and no WS-A addressing as requested 
//Modified by Programmer:                       Akhil Chauhan
//Date Programmed:                              3/9/2018
//Purpose:                                      Rewrited and Segregated methods and optimized logic and put more diagnostic for application 
//==================================================================================================================================================== 
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    public class MeridianService : IMeridianService
    {
        /// <summary>
        /// Soap Method to pass xCBL XML data to the web serivce
        /// </summary>
        /// <param name="ShippingSchedule">XmlElement the xCBL XML data to parse</param>
        /// <returns>XElement - XML Message Acknowledgement response indicating Success or Failure</returns>
        public XElement SubmitDocument()
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            XCBL_User xCblServiceUser = new XCBL_User();
            MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "SubmitDocument", "1.1", "Success - New SOAP Request Received", "Submit Document Process", "No FileName", "No Schedule ID", "No Order Number", null, "Success");
            if (IsAuthenticatedRequest(ref xCblServiceUser))
            {
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "IsAuthenticatedRequest", "1.2", "Success - Authenticated request", "Submit Document Process", "No FileName", "No Schedule ID", "No Order Number", null, "Success");
                IList<ProcessData> processShippingSchedules = ValidateScheduleShippingXmlDocument(OperationContext.Current.RequestContext.RequestMessage, xCblServiceUser);
                if (processShippingSchedules != null && processShippingSchedules.Count > 0)
                {
                    foreach (var processData in processShippingSchedules)
                    {
                        try
                        {
                            MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateScheduleShippingXmlDocument", "1.3", string.Format("Success - Parsed requested xml for CSV file {0}", processData.ScheduleID), "Submit Document Process", processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Success");
                            CreateAndUploadCSVFile(processData, xCblServiceUser);
                        }
                        catch (Exception csvException)
                        {
                            status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "SubmitDocument", "3.0", "Error - To Process csv file", csvException.Message, processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error");
                        }
                        try
                        {
                            MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateScheduleShippingXmlDocument", "1.3", string.Format("Success - Parsed requested for xml file {0}", processData.ScheduleID), "Submit Document Process", processData.XmlFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Success");
                            CreateAndUploadXmlFile(processData, xCblServiceUser);
                        }
                        catch (Exception xmlException)
                        {
                            status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "SubmitDocument", "3.0", "Error - To Process xml  file", xmlException.Message, processData.XmlFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error");
                        }
                    }
                }
            }
            else
                MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "3.1", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");

            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(status, string.Empty));
        }

        /// <summary>
        /// To authenticate request whether it has valid credential to proceed
        /// </summary>
        /// <param name="xCblServiceUser">Service User</param>
        /// <returns></returns>
        private bool IsAuthenticatedRequest(ref XCBL_User xCblServiceUser)
        {
            try
            {
                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                int index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Credentials", "");

                // Retrieve the first soap headers, this should be the Credentials tag
                MessageHeaderInfo header = OperationContext.Current.IncomingMessageHeaders[index];

                xCblServiceUser = Meridian_AuthenticateUser(header, index);
                if (xCblServiceUser == null || !string.IsNullOrEmpty(xCblServiceUser.WebUsername) || !string.IsNullOrEmpty(xCblServiceUser.FtpUsername))
                {
                    MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "3.1", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "3.1", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");
                return false;
            }
        }

        /// <summary>
        /// To Parse sent SOAP XML and make list of Process data
        /// </summary>
        /// <param name="request"> SOAP Message Request</param>
        /// <param name="xCblServiceUser">Service User</param>
        /// <returns>List of process data</returns>
        private IList<ProcessData> ValidateScheduleShippingXmlDocument(Message request, XCBL_User xCblServiceUser)
        {
            var requestMessage = request.ToString().ReplaceSpecialCharsWithSpace();
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(requestMessage);

            XmlNamespaceManager xmlNsManager = new XmlNamespaceManager(xmlDoc.NameTable);
            xmlNsManager.AddNamespace("default", "rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd");
            xmlNsManager.AddNamespace("core", "rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd");

            XmlNodeList shippingElement = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER);



            //Find the Shipping schedule tag and getting the Inner Xml of its Node
            XmlNodeList shippingScheduleNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Http);//Http Request creating this tag
            if (shippingScheduleNode_xml.Count == 0)
            {
                shippingScheduleNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Https);//Https Request creating this tag
            }

            IList<ProcessData> shippingSchedules = new List<ProcessData>();

            if (shippingElement != null)
            {
                // There should only be one element in the Shipping Schedule request, but this should handle multiple ones
                foreach (XmlNode element in shippingElement)
                {
                    var processData = xCblServiceUser.GetNewProcessData();
                    processData.XmlDocument = xmlDoc;

                    var scheduleId = element.GetNodeByNameAndLogErrorTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_ID, "3", processData);
                    var scheduleIssuedDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_ISSUED_DATE, "1", processData);

                    //Schedule Header Information --start
                    if (scheduleId != null && !string.IsNullOrEmpty(scheduleId.InnerText))
                    {
                        processData.ScheduleID = scheduleId.InnerText.ReplaceSpecialCharsWithSpace();
                        processData.ShippingSchedule.ScheduleID = processData.ScheduleID;

                        if (scheduleIssuedDate != null && !string.IsNullOrEmpty(scheduleIssuedDate.InnerText))
                            processData.ShippingSchedule.ScheduleIssuedDate = scheduleIssuedDate.InnerText.ReplaceSpecialCharsWithSpace();


                        XmlNode xnScheduleReferences = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_REFERENCES, "2", processData);

                        if (xnScheduleReferences != null)
                            GetPurchaseOrderReference(xmlNsManager, xnScheduleReferences, processData);
                        else if (string.IsNullOrEmpty(processData.ShippingSchedule.OrderNumber))
                            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "ValidateScheduleShippingXmlDocument", "3.4", "Error - Schedule References XML tag missing or incorrect to get seller order number", "Exception - Seller order number", processData.CsvFileName, processData.ScheduleID, "No Order Number", processData.XmlDocument, "Error 4 - Seller order number not found");

                        if (string.IsNullOrEmpty(processData.ShippingSchedule.ScheduleID) || string.IsNullOrEmpty(processData.ShippingSchedule.OrderNumber))
                            break;

                        else
                        {
                            GetOtherScheduleReferences(xmlNsManager, xnScheduleReferences, processData);

                            GetPurposeScheduleTypeCodeAndParty(xmlNsManager, element, processData);

                            GetListOfContactNumber(xmlNsManager, element, processData);

                            GetListOfTransportRouting(xmlNsManager, element, processData);

                            shippingSchedules.Add(processData);
                        }
                    }
                }
            }
            else
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateScheduleShippingXmlDocument", "3.2", "Error - Shipping Schedule Header XML tag missing or incorrect", "Exception - Invalid request xml", "No file Name", "No Schedule Id", "No Order Number", xmlDoc, "Error 1 - Invalid request xml");
            return shippingSchedules;
        }

        /// <summary>
        /// To get seller order number and sequence
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="xnScheduleReferences">ScheduleReferences xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetPurchaseOrderReference(XmlNamespaceManager xmlNsManager, XmlNode xnScheduleReferences, ProcessData processData)
        {
            XmlNode xnPurchaseOrderReferences = xnScheduleReferences.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE, "4", processData, "GetPurchaseOrderReference");
            if (xnPurchaseOrderReferences != null)
            {
                XmlNodeList xnlPurchaseOrderReferences = xnPurchaseOrderReferences.ChildNodes;
                for (int iPurchaseOrderIndex = 0; iPurchaseOrderIndex < xnlPurchaseOrderReferences.Count; iPurchaseOrderIndex++)
                {
                    if (xnlPurchaseOrderReferences[iPurchaseOrderIndex].Name.Contains(MeridianGlobalConstants.XCBL_SELLER_ORDER_NUMBER))
                    {
                        processData.OrderNumber = xnlPurchaseOrderReferences[iPurchaseOrderIndex].InnerText.ReplaceSpecialCharsWithSpace();
                        processData.ShippingSchedule.OrderNumber = processData.OrderNumber;
                    }

                    if (xnlPurchaseOrderReferences[iPurchaseOrderIndex].Name.Contains(MeridianGlobalConstants.XCBL_CHANGE_ORDER_SEQUENCE_NUMBER))
                        processData.ShippingSchedule.SequenceNumber = xnlPurchaseOrderReferences[iPurchaseOrderIndex].InnerText.ReplaceSpecialCharsWithSpace();
                }
            }
        }

        /// <summary>
        /// To get Other schedule references
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="xnScheduleReferences">ScheduleReferences xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetOtherScheduleReferences(XmlNamespaceManager xmlNsManager, XmlNode xnScheduleReferences, ProcessData processData)
        {
            XmlNode xnOtherScheduleReferences = xnScheduleReferences.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_OTHER_SCHEDULE_REFERENCES, "5", processData, "GetOtherScheduleReferences");
            if (xnOtherScheduleReferences != null)
            {
                XmlNodeList xnReferenceCoded = xnOtherScheduleReferences.ChildNodes; // 8Nodes
                for (int iReferenceCodedIndex = 0; iReferenceCodedIndex < xnReferenceCoded.Count; iReferenceCodedIndex++)
                {
                    XmlNodeList xnReferences = xnReferenceCoded[iReferenceCodedIndex].ChildNodes;
                    if (xnReferences.Count == 3
                        && xnReferences[1].Name.Trim().Equals(string.Format("core:{0}", MeridianGlobalConstants.XCBL_REFERENCE_TypeCode_Other), StringComparison.OrdinalIgnoreCase)
                        && xnReferences[2].Name.Trim().Equals(string.Format("core:{0}", MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION), StringComparison.OrdinalIgnoreCase))
                        processData.ShippingSchedule.SetOtherScheduleReferenceDesc(xnReferences[1].InnerText, xnReferences[2].InnerText.ReplaceSpecialCharsWithSpace());
                }
            }
        }

        /// <summary>
        /// To get single node value
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="element">Main xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetPurposeScheduleTypeCodeAndParty(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            string methodName = "GetPurposeScheduleTypeCodeAndParty";
            XmlNode purposeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURPOSE_CODED, "3", processData, methodName);
            if (purposeCoded != null)
                processData.ShippingSchedule.PurposeCoded = purposeCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode scheduleTypeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED, "4", processData, methodName);
            if (scheduleTypeCoded != null)
                processData.ShippingSchedule.ScheduleType = scheduleTypeCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode agencyCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_AGENCY_CODED, "5", processData, methodName);
            if (agencyCoded != null)
                processData.ShippingSchedule.AgencyCoded = agencyCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode name1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_NAME, "6", processData, methodName);
            if (name1 != null)
                processData.ShippingSchedule.Name1 = name1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode street = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_STREET, "7", processData, methodName);
            if (street != null)
                processData.ShippingSchedule.Street = street.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode streetSupplement1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_STREET_SUPPLEMENT, "8", processData, methodName);
            if (streetSupplement1 != null)
                processData.ShippingSchedule.StreetSupplement1 = streetSupplement1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode postalCode = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_POSTAL_CODE, "9", processData, methodName);
            if (postalCode != null)
                processData.ShippingSchedule.PostalCode = postalCode.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode city = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_CITY, "10", processData, methodName);
            if (city != null)
                processData.ShippingSchedule.City = city.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode regionCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REGION_CODED, "11", processData, methodName);
            if (regionCoded != null)
                processData.ShippingSchedule.RegionCoded = regionCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode contactName = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_CONTACT_NAME, "12", processData, methodName);
            if (contactName != null)
                processData.ShippingSchedule.ContactName = contactName.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();
        }

        /// <summary>
        /// To get List of contacts
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="element">Main xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetListOfContactNumber(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            var lisOfContactNumber = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBERS, "13", processData, "GetListOfContactNumber");
            if (lisOfContactNumber != null && lisOfContactNumber.ChildNodes != null)
            {
                XmlNodeList xnlContactNames = lisOfContactNumber.ChildNodes;
                for (int iContactNameIndex = 0; iContactNameIndex < xnlContactNames.Count; iContactNameIndex++)
                {
                    XmlNodeList xnlContactValues = xnlContactNames[iContactNameIndex].ChildNodes;
                    for (int iContactValuesIndex = 0; iContactValuesIndex < xnlContactValues.Count; iContactValuesIndex++)
                        if (xnlContactValues[iContactValuesIndex].Name.Contains(MeridianGlobalConstants.XCBL_CONTACT_VALUE))
                            processData.ShippingSchedule.SetContactNumbers(xnlContactValues[iContactValuesIndex].InnerText.ReplaceSpecialCharsWithSpace(), iContactNameIndex);
                }
            }
            else if (lisOfContactNumber.ChildNodes == null)
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "GetListOfContactNumber", "14", "Warning - The Contact Number Not Found.", "Warning - Contact Number", processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, null, "Warning 14 - Contact Name Not Found");

        }

        /// <summary>
        /// To get transportion data
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="element">Main xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetListOfTransportRouting(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {

            XmlNode shippingInstruction = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SHIPPING_INSTRUCTIONS, "15", processData);
            if (shippingInstruction != null)
                processData.ShippingSchedule.ShippingInstruction = shippingInstruction.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode gpsSystem = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_GPS_SYSTEM, "16", processData);
            if (gpsSystem != null)
                processData.ShippingSchedule.GPSSystem = gpsSystem.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode latitude = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LATITUDE, "17", processData);
            if (latitude != null)
            {
                double dLatitude;
                double.TryParse(latitude.InnerText.ReplaceSpecialCharsWithSpace(), out dLatitude);
                processData.ShippingSchedule.Latitude = dLatitude;

            }

            XmlNode longitude = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LONGITUDE, "18", processData);
            if (longitude != null)
            {
                double dLongitude;
                double.TryParse(longitude.InnerText.ReplaceSpecialCharsWithSpace(), out dLongitude);
                processData.ShippingSchedule.Longitude = dLongitude;
            }

            XmlNode locationID = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LOCATION_ID, "19", processData);
            if (locationID != null)
                processData.ShippingSchedule.LocationID = locationID.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode estimatedArrivalDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_ESTIMATED_ARRIVAL_DATE, "20", processData);
            if (estimatedArrivalDate != null)
                processData.ShippingSchedule.EstimatedArrivalDate = estimatedArrivalDate.InnerText.ReplaceSpecialCharsWithSpace();

        }

        /// <summary>
        /// To create CSV file and upload to ft
        /// </summary>
        /// <param name="processData">Process data</param>
        ///  <param name="user">Service user </param>  
        /// <returns></returns>
        private string CreateAndUploadCSVFile(ProcessData processData, XCBL_User user)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            StringBuilder csvOutput = new StringBuilder();
            var shippingSchedule = processData.ShippingSchedule;
            csvOutput.AppendLine(MeridianGlobalConstants.CSV_HEADER_NAMES);

            var record = string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35}",
               shippingSchedule.ScheduleID, shippingSchedule.ScheduleIssuedDate, shippingSchedule.OrderNumber, shippingSchedule.SequenceNumber,
               shippingSchedule.Other_FirstStop, shippingSchedule.Other_Before7, shippingSchedule.Other_Before9, shippingSchedule.Other_Before12, shippingSchedule.Other_SameDay, shippingSchedule.Other_OwnerOccupied, shippingSchedule.Other_7, shippingSchedule.Other_8, shippingSchedule.Other_9, shippingSchedule.Other_10,
               shippingSchedule.PurposeCoded, shippingSchedule.ScheduleType, shippingSchedule.AgencyCoded, shippingSchedule.Name1, shippingSchedule.Street, shippingSchedule.StreetSupplement1, shippingSchedule.PostalCode, shippingSchedule.City, shippingSchedule.RegionCoded,
               shippingSchedule.ContactName, shippingSchedule.ContactNumber_1, shippingSchedule.ContactNumber_2, shippingSchedule.ContactNumber_3, shippingSchedule.ContactNumber_4, shippingSchedule.ContactNumber_5, shippingSchedule.ContactNumber_6,
               shippingSchedule.ShippingInstruction, shippingSchedule.GPSSystem, shippingSchedule.Latitude.ToString(), shippingSchedule.Longitude.ToString(), shippingSchedule.LocationID, shippingSchedule.EstimatedArrivalDate);

            csvOutput.AppendLine(record);
            string filePath = string.Format("{0}\\{1}", System.Configuration.ConfigurationManager.AppSettings["CsvPath"].ToString(), processData.CsvFileName);
            try
            {
                if (!File.Exists(filePath))
                    File.Create(filePath).Close();
                File.WriteAllText(filePath, csvOutput.ToString());
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateAndUploadCSVFile", "1.4", "Success - Created CSV File", "CSV File Created", processData.CsvFileName, shippingSchedule.ScheduleID, shippingSchedule.OrderNumber, processData.XmlDocument, "Success");
                UploadFileToFTP(MeridianGlobalConstants.FTP_SERVER_CSV_URL, filePath, processData, user);
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateAndUploadCSVFile", "3.6", "Error - Creating CSV File", ex.Message, processData.CsvFileName, shippingSchedule.ScheduleID, shippingSchedule.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;

            }
            return status;
        }

        /// <summary>
        /// To create Xml file and upload to ft
        /// </summary>
        /// <param name="processData">Process data</param>
        ///  param name="user">Service user </param>
        /// <returns></returns>
        private string CreateAndUploadXmlFile(ProcessData processData, XCBL_User user)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            XmlNodeList shippingScheduleNode_xml = processData.XmlDocument.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Http);
            string filePath = string.Format("{0}\\{1}", System.Configuration.ConfigurationManager.AppSettings["XmlPath"].ToString(), processData.XmlFileName);
            try
            {
                if (!File.Exists(filePath))
                    File.Create(filePath).Close();
                File.WriteAllText(filePath, shippingScheduleNode_xml[0].InnerText.ReplaceSpecialCharsWithSpace());
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateAndUploadXmlFile", "1.5", "Success - Created Xml File ", "Xml File Created", processData.XmlFileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, processData.XmlDocument, "Success");
                UploadFileToFTP(MeridianGlobalConstants.FTP_SERVER_XML_URL, filePath, processData, user);

            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateAndUploadXmlFile", "3.7", "Error - Creating Xml File", ex.Message, processData.XmlFileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, processData.XmlDocument, "Error 7- Creating XML File");
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;

            }
            return status;
        }

        /// <summary>
        /// To upload file to ftp and delete from system once upload successfully.
        /// </summary>
        /// <param name="ftpServer">FTP server URL</param>
        /// <param name="filePath">Uploading file path</param>
        /// <param name="processData">Process data</param>
        /// <param name="user">Service user</param>
        /// <returns></returns>
        private bool UploadFileToFTP(string ftpServer, string filePath, ProcessData processData, XCBL_User user)
        {
            bool result = true;
            string fileName = Path.GetFileName(filePath);
            try
            {
                FtpWebRequest ftpRequest = (FtpWebRequest)FtpWebRequest.Create(ftpServer + fileName);
                ftpRequest.Credentials = new NetworkCredential(user.FtpUsername, user.FtpPassword);

                ftpRequest.Method = WebRequestMethods.Ftp.UploadFile;
                ftpRequest.UseBinary = true;
                ftpRequest.UsePassive = true;
                byte[] data = File.ReadAllBytes(filePath);
                ftpRequest.ContentLength = data.Length;
                using (Stream stream = ftpRequest.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                    stream.Close();
                }
                FtpWebResponse ftpResponse = (FtpWebResponse)ftpRequest.GetResponse();
                string status = ftpResponse.StatusDescription;
                ftpResponse.Close();
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFTP", "1.6", string.Format("Success - Uploaded file: {0}", fileName), string.Format("Uploaded file: {0} on {1}", fileName, status), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");

                try
                {
                    File.Delete(filePath);
                    MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFTP", "1.7", string.Format("Success - Deleted file {0} after ftp upload: {0}", fileName), string.Format("Deleted file: {0} -  {1}", fileName, status), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");
                }
                catch (Exception exFileDelete)
                {
                    result = false;
                    MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFTP", "3.9", "Error - While Deleting file", exFileDelete.Message, fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 9 - While deleting file");
                }

            }
            catch (Exception ex)
            {
                result = false;
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFTP", "3.8", "Error - While uploading file", ex.Message, fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 10 - While uploading file");
            }

            return result;
        }

        /// <summary>
        /// This function will authenticate the User with Username and Password
        /// </summary>
        /// <param name="header">MessageHeaderInfo - Contains the Soap Credential Header</param>
        /// <param name="objXCBLUser">Object - Holds the user related information</param>
        /// <returns></returns>
        private XCBL_User Meridian_AuthenticateUser(MessageHeaderInfo header, int index)
        {
            try
            {
                string username = string.Empty;
                string password = string.Empty;
                string hashkey = string.Empty;

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

                if (!string.IsNullOrEmpty(username) && !string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(hashkey))
                {
                    username = Encryption.Decrypt(username, hashkey);
                    password = Encryption.Decrypt(password, hashkey);
                    return MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword(username, password);
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}