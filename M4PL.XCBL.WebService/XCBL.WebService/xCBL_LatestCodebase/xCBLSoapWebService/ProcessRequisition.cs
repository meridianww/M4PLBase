using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    public class ProcessRequisition
    {
        /// <summary>
        /// Dictionary to hold files to upload
        /// </summary>
        private static ConcurrentDictionary<string, FileToSend> CsvFileToUpload;

        #region Requisition Request

        /// <summary>
        /// Method to pass xCBL XML data to the web serivce
        /// </summary>
        /// <param name="currentOperationContext">Operation context inside this XmlElement the xCBL XML data to parse</param>
        /// <returns>XElement - XML Message Acknowledgement response indicating Success or Failure</returns>
        internal XElement ProcessRequisitionDocument(OperationContext currentOperationContext)
        {
            //var currentOperationContext = OperationContext.Current;
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            XCBL_User xCblServiceUser = new XCBL_User();
            MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "ProcessRequisitionDocument", "1.01", "Success - New SOAP Request Received", "Requisition Document Process", "No FileName", "No Requisition ID", "No Order Number", null, "Success");
            if (CommonProcess.IsAuthenticatedRequest(currentOperationContext, ref xCblServiceUser))
            {
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "IsAuthenticatedRequest", "1.02", "Success - Authenticated request", "Requisition Document Process", "No FileName", "No Requisition ID", "No Order Number", null, "Success");
                ProcessData processData = ProcessRequisitionRequestAndCreateFiles(currentOperationContext, xCblServiceUser);
                if (processData == null || string.IsNullOrEmpty(processData.RequisitionID) || string.IsNullOrEmpty(processData.OrderNumber))
                    status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                else
                {
                    processData.FtpUserName = xCblServiceUser.FtpUsername;
                    processData.FtpPassword = xCblServiceUser.FtpPassword;

                    bool csvResult = CreateLocalCsvFile(processData);
                    if (csvResult == false)
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                    return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(status, processData.RequisitionID, false));
                }
            }
            else
            {
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "3.01", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Requisition ID", "No Order Number", null, "Error");
            }
            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(status, string.Empty, false));
        }

        /// <summary>
        /// To Process request and create csv and xml files.
        /// </summary>
        /// <param name="operationContext">Current OperationContext</param>
        /// <returns></returns>
        private ProcessData ProcessRequisitionRequestAndCreateFiles(OperationContext operationContext, XCBL_User xCblServiceUser)
        {
            try
            {
                ProcessData processData = ValidateRequisitionXmlDocument(operationContext.RequestContext, xCblServiceUser);
                if (processData != null && !string.IsNullOrEmpty(processData.RequisitionID)
                    && !string.IsNullOrEmpty(processData.OrderNumber)
                   && !string.IsNullOrEmpty(processData.CsvFileName))

                {
                    MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ProcessRequestAndCreateFiles", "1.03", string.Format("Success - Parsed requested xml for CSV file {0}", processData.RequisitionID), "Requisition Document Process", processData.CsvFileName, processData.RequisitionID, processData.OrderNumber, processData.XmlDocument, "Success");
                    return processData;
                }
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateRequisitionXmlDocument", "3.02", "Error - Incorrect request ", string.Format("Exception - Invalid request xml {0}", ex.Message), "No file Name", "No Requisition Id", "No Order Number", null, "Error 2 - Invalid request xml");
            }

            return new ProcessData();
        }

        /// <summary>
        /// To Parse sent SOAP XML and make list of Process data
        /// </summary>
        /// <param name="requestContext"> Current OperationContext's RequestContext</param>
        /// <param name="xCblServiceUser">Service User</param>
        /// <returns>List of process data</returns>
        private ProcessData ValidateRequisitionXmlDocument(RequestContext requestContext, XCBL_User xCblServiceUser)
        {
            var requestMessage = requestContext.RequestMessage.ToString().ReplaceSpecialCharsWithSpace();
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(requestMessage);

            XmlNamespaceManager xmlNsManager = new XmlNamespaceManager(xmlDoc.NameTable);
            xmlNsManager.AddNamespace("default", "rrn:org.xcbl:schemas/xcbl/v4_0/applicationintegration/v1_0/applicationintegration.xsd");
            xmlNsManager.AddNamespace("core", "rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd");

            XmlNodeList requisitionElement = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_REQUISITION_HEADER);



            //Find the Requisition tag and getting the Inner Xml of its Node
            XmlNodeList requisitionNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_Requisition_XML_Http);//Http Request creating this tag
            if (requisitionNode_xml.Count == 0)
            {
                requisitionNode_xml = xmlDoc.GetElementsByTagName(MeridianGlobalConstants.XCBL_Requisition_XML_Https);//Https Request creating this tag
            }

            if (requisitionElement != null)
            {
                // There should only be one element in the Requisition request, but this should handle multiple ones
                foreach (XmlNode element in requisitionElement)
                {
                    var processData = xCblServiceUser.GetNewProcessData();
                    processData.XmlDocument = xmlDoc;

                    var requisitionId = element.GetNodeByNameAndLogErrorTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_NUMBER, "03", processData, processData.RequisitionID, "ValidateRequisitionXmlDocument");
                    var requisitionIssuedDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_ISSUE_DATE, "01", processData, processData.RequisitionID, "ValidateRequisitionXmlDocument");

                    //Requisition Header Information --start
                    if (requisitionId != null && !string.IsNullOrEmpty(requisitionId.InnerText))
                    {
                        processData.RequisitionID = requisitionId.InnerText.ReplaceSpecialCharsWithSpace();
                        processData.Requisition.ReqNumber = processData.RequisitionID;

                        if (requisitionIssuedDate != null && !string.IsNullOrEmpty(requisitionIssuedDate.InnerText))
                            processData.Requisition.RequisitionIssueDate = requisitionIssuedDate.InnerText.ReplaceSpecialCharsWithSpace();


                        if (string.IsNullOrEmpty(processData.Requisition.ReqNumber))
                            break;
                        else
                        {
                            GetRequisitionTypes(xmlNsManager, element, processData);
                            GetPurposes(xmlNsManager, element, processData);
                            GetRequestedShipByDate(xmlNsManager, element, processData);
                            GetRequisitionParty(xmlNsManager, element, processData);
                            return processData;
                        }
                    }
                }
            }
            else
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateRequisitionXmlDocument", "3.02", "Error - Requisition Header XML tag missing or incorrect", "Exception - Invalid request xml", "No file Name", "No Requisition Number", "No Order Number", xmlDoc, "Error 1 - Invalid request xml");
            return new ProcessData();
        }

        /// <summary>
        /// To create CSV file
        /// </summary>
        /// <param name="processData">Process data</param>
        /// <returns></returns>
        private bool CreateLocalCsvFile(ProcessData processData)
        {
            bool result = false;
            try
            {
                if (processData != null && !string.IsNullOrEmpty(processData.ScheduleID)
                     && !string.IsNullOrEmpty(processData.OrderNumber)
                    && !string.IsNullOrEmpty(processData.CsvFileName))
                {
                    var record = string.Format(MeridianGlobalConstants.CSV_HEADER_NAMES_FORMAT,
                       processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.ScheduleIssuedDate, processData.ShippingSchedule.OrderNumber, processData.ShippingSchedule.SequenceNumber,
                       processData.ShippingSchedule.Other_FirstStop, processData.ShippingSchedule.Other_Before7, processData.ShippingSchedule.Other_Before9, processData.ShippingSchedule.Other_Before12, processData.ShippingSchedule.Other_SameDay, processData.ShippingSchedule.Other_OwnerOccupied, processData.ShippingSchedule.Other_7, processData.ShippingSchedule.Other_8, processData.ShippingSchedule.Other_9, processData.ShippingSchedule.Other_10,
                       processData.ShippingSchedule.PurposeCoded, processData.ShippingSchedule.ScheduleType, processData.ShippingSchedule.AgencyCoded, processData.ShippingSchedule.Name1, processData.ShippingSchedule.Street, processData.ShippingSchedule.StreetSupplement1, processData.ShippingSchedule.PostalCode, processData.ShippingSchedule.City, processData.ShippingSchedule.RegionCoded,
                       processData.ShippingSchedule.ContactName, processData.ShippingSchedule.ContactNumber_1, processData.ShippingSchedule.ContactNumber_2, processData.ShippingSchedule.ContactNumber_3, processData.ShippingSchedule.ContactNumber_4, processData.ShippingSchedule.ContactNumber_5, processData.ShippingSchedule.ContactNumber_6,
                       processData.ShippingSchedule.ShippingInstruction, processData.ShippingSchedule.GPSSystem, processData.ShippingSchedule.Latitude.ToString(), processData.ShippingSchedule.Longitude.ToString(), processData.ShippingSchedule.LocationID, processData.ShippingSchedule.EstimatedArrivalDate);
                    StringBuilder strBuilder = new StringBuilder(MeridianGlobalConstants.CSV_HEADER_NAMES);
                    strBuilder.AppendLine();
                    strBuilder.AppendLine(record);
                    string csvContent = strBuilder.ToString();
                    byte[] content = Encoding.UTF8.GetBytes(csvContent);
                    int length = content.Length;

                    if (CsvFileToUpload == null)
                    {
                        CsvFileToUpload = new ConcurrentDictionary<string, FileToSend>();
                    }
                    if (!CsvFileToUpload.ContainsKey(processData.CsvFileName) && !string.IsNullOrEmpty(processData.CsvFileName) && length > 40)
                    {
                        CsvFileToUpload.GetOrAdd(processData.CsvFileName,
                            new FileToSend
                            {
                                FtpUserName = processData.FtpUserName,
                                FtpPassword = processData.FtpPassword,
                                FtpServerUrl = MeridianGlobalConstants.FTP_SERVER_CSV_URL,
                                WebUserName = processData.WebUserName,
                                ScheduleID = processData.ScheduleID,
                                OrderNumber = processData.OrderNumber,
                                FileName = processData.CsvFileName,
                                Content = content
                            });
                        //timer.Enabled = true;
                        result = true;
                    }
                    else
                    {
                        MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "3.06", ("Error - Creating CSV File because of Stream " + length), string.Format("Error - Creating CSV File {0} with error of Stream", processData.CsvFileName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
                    }
                }
                else
                {
                    MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "3.06", "Error - Creating CSV File because of Process DATA", string.Format("Error - Creating CSV File {0} with error of Process DATA", processData.CsvFileName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
                }
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "3.06", "Error - Creating CSV File", string.Format("Error - Creating CSV File {0} with error {1}", processData.CsvFileName, ex.Message), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
            }

            return result;
        }

        #region XML Parsing

        private void GetRequisitionTypes(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            string methodName = "GetRequisitionTypes";
            XmlNode requisitionType = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_TYPE, "14", processData, processData.RequisitionID, methodName);

            if (requisitionType != null)
            {
                XmlNode requisitionTypeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_TYPE_CODED, "15", processData, processData.RequisitionID, methodName);
                if (requisitionTypeCoded != null)
                    processData.Requisition.RequisitionTypeCoded = requisitionTypeCoded.InnerText.ReplaceSpecialCharsWithSpace();
                XmlNode requisitionTypeCodedOther = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_TYPE_CODED_OTHER, "16", processData, processData.RequisitionID, methodName);
                if (requisitionTypeCodedOther != null)
                    processData.Requisition.RequisitionTypeCodedOther = requisitionTypeCodedOther.InnerText.ReplaceSpecialCharsWithSpace();
            }
        }

        private void GetPurposes(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            string methodName = "GetPurposes";
            XmlNode purposeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURPOSE_CODED, "03", processData, processData.RequisitionID, methodName);
            if (purposeCoded != null)
                processData.Requisition.PurposeCoded = purposeCoded.InnerText.ReplaceSpecialCharsWithSpace();
            XmlNode purposeCodedOther = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURPOSE_CODED_OTHER, "17", processData, processData.RequisitionID, methodName);
            if (purposeCodedOther != null)
                processData.Requisition.PurposeCodedOther = purposeCodedOther.InnerText.ReplaceSpecialCharsWithSpace();
        }

        private void GetRequestedShipByDate(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            string methodName = "GetRequestedShipByDate";
            XmlNode requisitionDate = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_DATES, "18", processData, processData.RequisitionID, methodName);

            if (requisitionDate != null)
            {
                XmlNode requestedShipByDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUESTED_SHIP_BY_DATE, "19", processData, processData.RequisitionID, methodName);
                if (requestedShipByDate != null)
                    processData.Requisition.RequestedShipByDate = requestedShipByDate.InnerText.ReplaceSpecialCharsWithSpace();
            }
        }

        private void GetRequisitionParty(XmlNamespaceManager xmlNsManager, XmlNode element, ProcessData processData)
        {
            string methodName = "GetRequisitionParty";
            XmlNode requisitionParty = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_PARTY, "20", processData, processData.RequisitionID, methodName);
            if (requisitionParty != null)
            {
                XmlNode shipToParty = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY, "20", processData, processData.RequisitionID, methodName);
                if (shipToParty != null)
                {
                    XmlNode requestedShipToPartyNameAddress = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS, "21", processData, processData.RequisitionID, methodName);
                    if (requestedShipToPartyNameAddress != null)
                    {
                        XmlNode requestedShipToPartyNameAddressName1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_NAME1, "22", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressName1 != null)
                            processData.Requisition.ShipToParty_Name1 = requestedShipToPartyNameAddressName1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipToPartyNameAddressStreet = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_STREET, "23", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressStreet != null)
                            processData.Requisition.ShipToParty_Street = requestedShipToPartyNameAddressStreet.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipToPartyNameAddressStreetSpplement = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_STREET_SUPPLEMENT1, "24", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressStreetSpplement != null)
                            processData.Requisition.ShipToParty_StreetSupplement1 = requestedShipToPartyNameAddressStreetSpplement.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipToPartyNameAddressPostalCode = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_POSTAL_CODE, "25", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressPostalCode != null)
                            processData.Requisition.ShipToParty_PostalCode = requestedShipToPartyNameAddressPostalCode.InnerText.ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipToPartyNameAddressCity = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_CITY, "26", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressCity != null)
                            processData.Requisition.ShipToParty_City = requestedShipToPartyNameAddressCity.InnerText.ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipToPartyNameAddressRegion = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_REGION, "27", processData, processData.RequisitionID, methodName);
                        if (requestedShipToPartyNameAddressRegion != null)
                        {
                            XmlNode requestedShipToPartyNameAddressRegionCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_REGION_REGIONCODED, "28", processData, processData.RequisitionID, methodName);
                            if (requestedShipToPartyNameAddressRegionCoded != null)
                                processData.Requisition.ShipToParty_RegionCoded = requestedShipToPartyNameAddressRegionCoded.InnerText.ReplaceSpecialCharsWithSpace();
                        }
                    }
                }

                XmlNode shipFromParty = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY, "29", processData, processData.RequisitionID, methodName);
                if (shipFromParty != null)
                {
                    XmlNode requestedShipFromPartyNameAddress = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS, "30", processData, processData.RequisitionID, methodName);
                    if (requestedShipFromPartyNameAddress != null)
                    {
                        XmlNode requestedShipFromPartyNameAddressName1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_NAME1, "31", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressName1 != null)
                            processData.Requisition.ShipFromParty_Name1 = requestedShipFromPartyNameAddressName1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipFromPartyNameAddressStreet = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_STREET, "32", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressStreet != null)
                            processData.Requisition.ShipFromParty_Street = requestedShipFromPartyNameAddressStreet.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipFromPartyNameAddressStreetSpplement = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_STREET_SUPPLEMENT1, "33", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressStreetSpplement != null)
                            processData.Requisition.ShipFromParty_StreetSupplement1 = requestedShipFromPartyNameAddressStreetSpplement.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipFromPartyNameAddressPostalCode = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_POSTAL_CODE, "34", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressPostalCode != null)
                            processData.Requisition.ShipFromParty_PostalCode = requestedShipFromPartyNameAddressPostalCode.InnerText.ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipFromPartyNameAddressCity = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_CITY, "35", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressCity != null)
                            processData.Requisition.ShipFromParty_City = requestedShipFromPartyNameAddressCity.InnerText.ReplaceSpecialCharsWithSpace();

                        XmlNode requestedShipFromPartyNameAddressRegion = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_REGION, "36", processData, processData.RequisitionID, methodName);
                        if (requestedShipFromPartyNameAddressRegion != null)
                        {
                            XmlNode requestedShipFromPartyNameAddressRegionCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_REGION_REGIONCODED, "37", processData, processData.RequisitionID, methodName);
                            if (requestedShipFromPartyNameAddressRegionCoded != null)
                                processData.Requisition.ShipFromParty_RegionCoded = requestedShipFromPartyNameAddressRegionCoded.InnerText.ReplaceSpecialCharsWithSpace();
                        }
                    }
                }

            }
        }

        #endregion XML Parsing

        #endregion Requisition Request
    }
}