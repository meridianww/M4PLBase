using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Text;
using System.Timers;
using System.Web;
using System.Xml;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    public class ProcessShippingSchedule
    {
        private MeridianResult _meridianResult = null;

        #region Shipping Schedule Request

        /// <summary>
        /// Method to pass xCBL XML data to the web serivce
        /// </summary>
        /// <param name="currentOperationContext">Operation context inside this XmlElement the xCBL XML data to parse</param>
        /// <returns>XElement - XML Message Acknowledgement response indicating Success or Failure</returns>
        internal MeridianResult ProcessDocument(OperationContext currentOperationContext)
        {
            _meridianResult = new MeridianResult();
            _meridianResult.Status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;

            XCBL_User xCblServiceUser = new XCBL_User();
            MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "ProcessDocument", "01.01", "Success - New SOAP Request Received", "Shipping Schedule Process", "No FileName", "No Schedule ID", "No Order Number", null, "Success");
            if (CommonProcess.IsAuthenticatedRequest(currentOperationContext, ref xCblServiceUser))
            {
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "IsAuthenticatedRequest", "01.02", "Success - Authenticated request", "Shipping Schedule Process", "No FileName", "No Schedule ID", "No Order Number", null, "Success");
                ProcessData processData = ProcessRequestAndCreateFiles(currentOperationContext, xCblServiceUser);
                if (processData == null || string.IsNullOrEmpty(processData.ScheduleID) || string.IsNullOrEmpty(processData.OrderNumber))
                    _meridianResult.Status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                else
                {
                    processData.FtpUserName = xCblServiceUser.FtpUsername;
                    processData.FtpPassword = xCblServiceUser.FtpPassword;

                    bool csvResult = CreateLocalCsvFile(processData);
                    if (csvResult == false)
                        _meridianResult.Status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                    _meridianResult.UniqueID = processData.ScheduleID;
                    return _meridianResult;
                }
            }
            else
            {
                _meridianResult.Status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "03.01", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");
            }
            return _meridianResult;
        }

        /// <summary>
        /// To Process request and create csv and xml files.
        /// </summary>
        /// <param name="operationContext">Current OperationContext</param>
        /// <returns></returns>
        private ProcessData ProcessRequestAndCreateFiles(OperationContext operationContext, XCBL_User xCblServiceUser)
        {
            try
            {
                ProcessData processData = ValidateScheduleShippingXmlDocument(operationContext.RequestContext, xCblServiceUser);
                if (processData != null && !string.IsNullOrEmpty(processData.ScheduleID)
                    && !string.IsNullOrEmpty(processData.OrderNumber)
                   && !string.IsNullOrEmpty(processData.CsvFileName))

                {
                    MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ProcessRequestAndCreateFiles", "01.03", string.Format("Success - Parsed requested xml for CSV file {0}", processData.ScheduleID), "Submit Document Process", processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Success");
                    return processData;
                }
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateScheduleShippingXmlDocument", "03.02", "Error - Incorrect request ", string.Format("Exception - Invalid request xml {0}", ex.Message), "No file Name", "No Schedule Id", "No Order Number", null, "Error 2 - Invalid request xml");
            }

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

                    if (!string.IsNullOrEmpty(processData.CsvFileName) && length > 40)
                    {
                        _meridianResult.FtpUserName = processData.FtpUserName;
                        _meridianResult.FtpPassword = processData.FtpPassword;
                        _meridianResult.FtpServerUrl = MeridianGlobalConstants.FTP_SERVER_CSV_URL;
                        _meridianResult.WebUserName = processData.WebUserName;
                        _meridianResult.UniqueID = processData.ScheduleID;
                        _meridianResult.OrderNumber = processData.OrderNumber;
                        _meridianResult.FileName = processData.CsvFileName;
                        _meridianResult.Content = content;

                        result = true;
                    }
                    else
                    {
                        MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "03.06", ("Error - Creating CSV File because of Stream " + length), string.Format("Error - Creating CSV File {0} with error of Stream", processData.CsvFileName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
                    }
                }
                else
                {
                    MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "03.06", "Error - Creating CSV File because of Process DATA", string.Format("Error - Creating CSV File {0} with error of Process DATA", processData.CsvFileName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
                }
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "03.06", "Error - Creating CSV File", string.Format("Error - Creating CSV File {0} with error {1}", processData.CsvFileName, ex.Message), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 6- Creating CSV File");
            }

            return result;
        }


        #region XML Parsing

        /// <summary>
        /// To Parse sent SOAP XML and make list of Process data
        /// </summary>
        /// <param name="requestContext"> Current OperationContext's RequestContext</param>
        /// <param name="xCblServiceUser">Service User</param>
        /// <returns>List of process data</returns>
        private ProcessData ValidateScheduleShippingXmlDocument(RequestContext requestContext, XCBL_User xCblServiceUser)
        {
            var requestMessage = requestContext.RequestMessage.ToString().ReplaceSpecialCharsWithSpace();
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

            if (shippingElement != null)
            {
                // There should only be one element in the Shipping Schedule request, but this should handle multiple ones
                foreach (XmlNode element in shippingElement)
                {
                    var processData = xCblServiceUser.GetNewProcessData();
                    processData.XmlDocument = xmlDoc;

                    var scheduleId = element.GetNodeByNameAndLogErrorTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_ID, "03", processData, processData.ScheduleID);
                    var scheduleIssuedDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_ISSUED_DATE, "01", processData, processData.ScheduleID);

                    //Schedule Header Information --start
                    if (scheduleId != null && !string.IsNullOrEmpty(scheduleId.InnerText))
                    {
                        processData.ScheduleID = scheduleId.InnerText.ReplaceSpecialCharsWithSpace();
                        processData.ShippingSchedule.ScheduleID = processData.ScheduleID;

                        if (scheduleIssuedDate != null && !string.IsNullOrEmpty(scheduleIssuedDate.InnerText))
                            processData.ShippingSchedule.ScheduleIssuedDate = scheduleIssuedDate.InnerText.ReplaceSpecialCharsWithSpace();


                        XmlNode xnScheduleReferences = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_REFERENCES, "02", processData, processData.ScheduleID);

                        if (xnScheduleReferences != null)
                            GetPurchaseOrderReference(xmlNsManager, xnScheduleReferences, processData);
                        else if (string.IsNullOrEmpty(processData.ShippingSchedule.OrderNumber))
                            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "ValidateScheduleShippingXmlDocument", "03.04", "Error - Schedule References XML tag missing or incorrect to get seller order number", "Exception - Seller order number", processData.CsvFileName, processData.ScheduleID, "No Order Number", processData.XmlDocument, "Error 4 - Seller order number not found");

                        if (string.IsNullOrEmpty(processData.ShippingSchedule.ScheduleID) || string.IsNullOrEmpty(processData.ShippingSchedule.OrderNumber))
                            break;

                        else
                        {
                            GetOtherScheduleReferences(xmlNsManager, xnScheduleReferences, processData);

                            GetPurposeScheduleTypeCodeAndParty(xmlNsManager, element, processData);

                            GetListOfContactNumber(xmlNsManager, element, processData);

                            GetListOfTransportRouting(xmlNsManager, element, processData);

                            return processData;
                        }
                    }
                }
            }
            else
                MeridianSystemLibrary.LogTransaction(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "ValidateScheduleShippingXmlDocument", "03.02", "Error - Shipping Schedule Header XML tag missing or incorrect", "Exception - Invalid request xml", "No file Name", "No Schedule Id", "No Order Number", xmlDoc, "Error 1 - Invalid request xml");
            return new ProcessData();
        }

        /// <summary>
        /// To get seller order number and sequence
        /// </summary>
        /// <param name="xmlNsManager"> XmlNamespaceManager </param>
        /// <param name="xnScheduleReferences">ScheduleReferences xml node from requested data </param>
        /// <param name="processData">Process data</param>
        private void GetPurchaseOrderReference(XmlNamespaceManager xmlNsManager, XmlNode xnScheduleReferences, ProcessData processData)
        {
            XmlNode xnPurchaseOrderReferences = xnScheduleReferences.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE, "04", processData, processData.ScheduleID, "GetPurchaseOrderReference");
            if (xnPurchaseOrderReferences != null)
            {
                XmlNodeList xnlPurchaseOrderReferences = xnPurchaseOrderReferences.ChildNodes;
                for (int iPurchaseOrderIndex = 0; iPurchaseOrderIndex < xnlPurchaseOrderReferences.Count; iPurchaseOrderIndex++)
                {
                    if (xnlPurchaseOrderReferences[iPurchaseOrderIndex].Name.Contains(MeridianGlobalConstants.XCBL_SELLER_ORDER_NUMBER))
                    {
                        processData.OrderNumber = xnlPurchaseOrderReferences[iPurchaseOrderIndex].InnerText.ReplaceSpecialCharsWithSpace();
                        processData.ShippingSchedule.OrderNumber = processData.OrderNumber;

                        string formattedOrderNumber = processData.OrderNumber.ReplaceSpecialCharsWithSpace().Replace(" ", "");
                        string fileNameFormat = DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT);
                        processData.CsvFileName = string.Concat(MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, fileNameFormat, formattedOrderNumber, MeridianGlobalConstants.XCBL_FILE_EXTENSION);
                        processData.XmlFileName = string.Concat(MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, fileNameFormat, formattedOrderNumber, MeridianGlobalConstants.XCBL_XML_EXTENSION);
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
            XmlNode xnOtherScheduleReferences = xnScheduleReferences.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_OTHER_SCHEDULE_REFERENCES, "05", processData, processData.ScheduleID, "GetOtherScheduleReferences");
            if (xnOtherScheduleReferences != null)
            {
                XmlNodeList xnReferenceCoded = xnOtherScheduleReferences.ChildNodes; // 8Nodes
                for (int iReferenceCodedIndex = 0; iReferenceCodedIndex < xnReferenceCoded.Count; iReferenceCodedIndex++)
                {
                    XmlNodeList xnReferences = xnReferenceCoded[iReferenceCodedIndex].ChildNodes;
                    if (xnReferences.Count == 3
                        && xnReferences[1].Name.Trim().Equals(string.Format("core:{0}", MeridianGlobalConstants.XCBL_REFERENCE_TYPECODE_OTHER), StringComparison.OrdinalIgnoreCase)
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
            XmlNode purposeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_PURPOSE_CODED, "03", processData, processData.ScheduleID, methodName);
            if (purposeCoded != null)
                processData.ShippingSchedule.PurposeCoded = purposeCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode scheduleTypeCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED, "04", processData, processData.ScheduleID, methodName);
            if (scheduleTypeCoded != null)
                processData.ShippingSchedule.ScheduleType = scheduleTypeCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode agencyCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_AGENCY_CODED, "05", processData, processData.ScheduleID, methodName);
            if (agencyCoded != null)
                processData.ShippingSchedule.AgencyCoded = agencyCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode name1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_NAME, "06", processData, processData.ScheduleID, methodName);
            if (name1 != null)
                processData.ShippingSchedule.Name1 = name1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode street = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_STREET, "07", processData, processData.ScheduleID, methodName);
            if (street != null)
                processData.ShippingSchedule.Street = street.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode streetSupplement1 = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_STREET_SUPPLEMENT, "08", processData, processData.ScheduleID, methodName);
            if (streetSupplement1 != null)
                processData.ShippingSchedule.StreetSupplement1 = streetSupplement1.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode postalCode = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_POSTAL_CODE, "09", processData, processData.ScheduleID, methodName);
            if (postalCode != null)
                processData.ShippingSchedule.PostalCode = postalCode.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode city = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_CITY, "10", processData, processData.ScheduleID, methodName);
            if (city != null)
                processData.ShippingSchedule.City = city.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode regionCoded = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_REGION_CODED, "11", processData, processData.ScheduleID, methodName);
            if (regionCoded != null)
                processData.ShippingSchedule.RegionCoded = regionCoded.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode contactName = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_CONTACT_NAME, "12", processData, processData.ScheduleID, methodName);
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
            var lisOfContactNumber = element.GetNodeByNameAndLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBERS, "13", processData, processData.ScheduleID, "GetListOfContactNumber");
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

            XmlNode shippingInstruction = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_SHIPPING_INSTRUCTIONS, "15", processData, processData.ScheduleID);
            if (shippingInstruction != null)
                processData.ShippingSchedule.ShippingInstruction = shippingInstruction.InnerText.Replace(",", "").ReplaceSpecialCharsWithSpace();

            XmlNode gpsSystem = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_GPS_SYSTEM, "16", processData, processData.ScheduleID);
            if (gpsSystem != null)
                processData.ShippingSchedule.GPSSystem = gpsSystem.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode latitude = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LATITUDE, "17", processData, processData.ScheduleID);
            if (latitude != null)
            {
                double dLatitude;
                double.TryParse(latitude.InnerText.ReplaceSpecialCharsWithSpace(), out dLatitude);
                processData.ShippingSchedule.Latitude = dLatitude;

            }

            XmlNode longitude = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LONGITUDE, "18", processData, processData.ScheduleID);
            if (longitude != null)
            {
                double dLongitude;
                double.TryParse(longitude.InnerText.ReplaceSpecialCharsWithSpace(), out dLongitude);
                processData.ShippingSchedule.Longitude = dLongitude;
            }

            XmlNode locationID = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_LOCATION_ID, "19", processData, processData.ScheduleID);
            if (locationID != null)
                processData.ShippingSchedule.LocationID = locationID.InnerText.ReplaceSpecialCharsWithSpace();

            XmlNode estimatedArrivalDate = element.GetNodeByNameAndInnerTextLogWarningTrans(xmlNsManager, MeridianGlobalConstants.XCBL_ESTIMATED_ARRIVAL_DATE, "20", processData, processData.ScheduleID);
            if (estimatedArrivalDate != null)
                processData.ShippingSchedule.EstimatedArrivalDate = estimatedArrivalDate.InnerText.ReplaceSpecialCharsWithSpace();

        }

        #endregion XML Parsing
        #endregion Shipping Schedule Request

    }
}