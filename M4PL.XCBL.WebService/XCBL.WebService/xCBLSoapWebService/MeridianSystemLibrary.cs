﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              1/8/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The module contains Meridian System Library Methods for Database calls to SYST010MeridianXCBLService
//                                              The XCBL_User class is an object to store all the authentication information for the user and to assist in transaction logging
//
//==================================================================================================================================================== 
using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Xml;

namespace xCBLSoapWebService
{
    public static partial class MeridianSystemLibrary
    {
        #region Meridian SYST000XCBLService Database Methods

        /// <summary>
        /// This function will insert a record into the MER010TransactionLog table on the Meridian Development Server.
        /// </summary>
        /// <param name="webUser">string - The xCBL Web Service Username consuming the web service</param>
        /// <param name="ftpUser">string - The FTP Username currently assigned to the web username</param>
        /// <param name="methodName">string - The method name of where the transaction record is being called</param>
        /// <param name="messageNumber">string - The Message Number of the specific message to insert</param>
        /// <param name="messageDescription">string - The Message Description for the transaction record to provide more information or detail</param>
        /// <param name="microsoftDescription">string - The Exception Message supplied by Microsoft when an error is encountered</param>
        /// <param name="filename">string - The Filename of the xCBL file to upload</param>
        /// <param name="documentId">string - The Document ID assigned to the xCBL file</param>
        public static int LogTransaction(string webUser, string ftpUser, string methodName, string messageNumber, string messageDescription, string microsoftDescription, string filename, string documentId, string TranOrderNo, XmlDocument TranXMLData, string TranMessageCode)
        {
            try
            {
                // 
                if (webUser == null) webUser = string.Empty;
                if (ftpUser == null) ftpUser = string.Empty;


                //Set up a new StringReader populated with the XmlDocument object's outer Xml

                XmlNodeReader srObject = new XmlNodeReader(TranXMLData);

                using (SqlConnection sqlConnection = new SqlConnection(MeridianGlobalConstants.XCBL_DATABASE_SERVER_URL))
                {
                    sqlConnection.Open();

                    // Try to insert the record into the MER010TransactionLog table
                    using (SqlCommand sqlCommand = new SqlCommand(MeridianGlobalConstants.XCBL_SP_InsTransactionLog, sqlConnection))
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;
                        sqlCommand.Parameters.Add("@TransactionDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
                        sqlCommand.Parameters.Add("@TransactionWebUser", SqlDbType.NVarChar).Value = webUser;
                        sqlCommand.Parameters.Add("@TransactionFtpUser", SqlDbType.NVarChar).Value = ftpUser;
                        sqlCommand.Parameters.Add("@TransactionMethodName", SqlDbType.NVarChar).Value = methodName;
                        sqlCommand.Parameters.Add("@TransactionMessageNumber", SqlDbType.NVarChar).Value = messageNumber;
                        sqlCommand.Parameters.Add("@TransactionMessageDescription", SqlDbType.NVarChar).Value = messageDescription;
                        sqlCommand.Parameters.Add("@TransactionMSDescription", SqlDbType.NVarChar).Value = microsoftDescription;
                        sqlCommand.Parameters.Add("@TransactionWebFilename", SqlDbType.NVarChar).Value = filename;
                        sqlCommand.Parameters.Add("@TransactionWebDocumentID", SqlDbType.NVarChar).Value = documentId;
                        sqlCommand.Parameters.Add("@TranOrderNo", SqlDbType.NVarChar).Value = TranOrderNo;
                        sqlCommand.Parameters.Add("@TranXMLData", SqlDbType.Xml).Value = srObject;
                        sqlCommand.Parameters.Add("@TranMessageCode", SqlDbType.NVarChar).Value = TranMessageCode;
                        return sqlCommand.ExecuteNonQuery();
                    }
                }

            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        /// <summary>
        ///This function will retrieve the authentication information for a specified xCBL Web Service username and password found in MER000Authentication table if the user is enabled
        /// </summary>
        /// <param name="username">string - The username assigned to the xCBL web service credentials</param>
        /// <param name="password">string - The password assigned to the xCBL web service credentials</param>
        /// <returns>XCBL_User - XCBL_User class object that contains the authentication information for the record matching the username and password</returns>
        public static XCBL_User sysGetAuthenticationByUsernameAndPassword(string webUsername, string webPassword)
        {

            // If either the username or password are empty then return null for the method
            if (string.IsNullOrEmpty(webUsername) || string.IsNullOrEmpty(webPassword))
                return null;

            // Try to retrieve the authentication record based on the specified username and password
            try
            {
                DataSet dsRecords = new DataSet();

                using (SqlConnection sqlConnection = new SqlConnection(MeridianGlobalConstants.XCBL_DATABASE_SERVER_URL))
                {
                    sqlConnection.Open();
                    using (SqlCommand sqlCommand = new SqlCommand(MeridianGlobalConstants.XCBL_SP_GetXcblAuthenticationUser, sqlConnection))
                    {
                        sqlCommand.CommandType = CommandType.StoredProcedure;

                        sqlCommand.Parameters.Add("@webUsername", SqlDbType.NVarChar).Value = webUsername;
                        sqlCommand.Parameters.Add("@webPassword", SqlDbType.NVarChar).Value = webPassword;

                        // Fill the data adapter with the sql query results
                        using (SqlDataAdapter sdaAdapter = new SqlDataAdapter(sqlCommand))
                        {
                            sdaAdapter.Fill(dsRecords);
                        }
                    }
                }
                // Parse the authentication record to a XCBL_User class object
                XCBL_User user = new XCBL_User() { WebUsername = dsRecords.Tables[0].Rows[0].ItemArray[1].ToString(), WebPassword = dsRecords.Tables[0].Rows[0].ItemArray[2].ToString(), Hashkey = dsRecords.Tables[0].Rows[0].ItemArray[3].ToString(), FtpUsername = dsRecords.Tables[0].Rows[0].ItemArray[4].ToString(), FtpPassword = dsRecords.Tables[0].Rows[0].ItemArray[5].ToString(), FtpServerUrl = dsRecords.Tables[0].Rows[0].ItemArray[6].ToString(), WebContactName = dsRecords.Tables[0].Rows[0].ItemArray[7].ToString(), WebContactCompany = dsRecords.Tables[0].Rows[0].ItemArray[8].ToString(), WebContactEmail = dsRecords.Tables[0].Rows[0].ItemArray[9].ToString(), WebContactPhone1 = dsRecords.Tables[0].Rows[0].ItemArray[10].ToString(), WebContactPhone2 = dsRecords.Tables[0].Rows[0].ItemArray[11].ToString(), Enabled = Boolean.Parse(dsRecords.Tables[0].Rows[0].ItemArray[12].ToString()) };
                return user;
            }
            catch (Exception ex)
            {
                // If there was an error encountered in retrieving the authentication record then try to insert a record in MER010TransactionLog table to record the issue
                try
                {
                    LogTransaction(webUsername, "", "sysGetAuthenticationByUsername", "0.0", "Warning - Cannot retrieve record from MER000Authentication table", ex.InnerException.ToString(), "", "", "", new XmlDocument(), "Warning 26 - DB Connection");
                }
                catch
                {
                }
                return null;
            }
        }
        #endregion

        public static ProcessData GetNewProcessData(this XCBL_User xCblServiceUser)
        {
            var processData = new ProcessData
            {
                ScheduleID = "No Schedule Id",
                OrderNumber = "No Order Number",
                CsvFileName = string.Concat(MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT), MeridianGlobalConstants.XCBL_FILE_EXTENSION),
                XmlFileName = string.Concat(MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, DateTime.Now.ToString(MeridianGlobalConstants.XCBL_FILE_DATETIME_FORMAT), MeridianGlobalConstants.XCBL_XML_EXTENSION),
                ShippingSchedule = new ShippingSchedule(),
                WebUserName = xCblServiceUser.WebUsername,
                FtpUserName = xCblServiceUser.FtpUsername
            };
            return processData;
        }

        /// <summary>
        /// This function will return the Success / Failure of the Action performed which tranferring the CSV file.
        /// </summary>
        /// <param name="status">string - Holds the Error Message - status</param>
        /// <param name="scheduleID">string - Unique id of the XCBL file which is to be uploaded</param>
        /// <returns></returns>
        public static string GetMeridian_Status(string status, string scheduleID)
        {
            StringBuilder messageResponse = new StringBuilder();
            messageResponse.AppendLine(MeridianGlobalConstants.XML_HEADER);
            messageResponse.AppendLine(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_OPEN_TAG);
            messageResponse.AppendLine(string.Format(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_OPEN_TAG + "{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_CLOSE_TAG, scheduleID));
            messageResponse.AppendLine(string.Format(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_OPEN_TAG + "{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_CLOSE_TAG, status));
            messageResponse.AppendLine(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG);
            return messageResponse.ToString();
        }

        public static XmlNode GetNodeByNameAndLogWarningTrans(this XmlNode fromNode, XmlNamespaceManager nsMgr, string nodeName, string warningNumber, ProcessData processData, string methodName = "")
        {
            try
            {
                XmlNode foundNode = fromNode.SelectSingleNode(nodeName, nsMgr);
                if (foundNode == null)
                    LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("2.{0}", warningNumber), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Warning {0} - Issue with node {1}.", "GetNodeByNameAndLogWarningTrans", nodeName));
                return foundNode;
            }
            catch (Exception e)
            {
                LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("2.{0}", warningNumber), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), Convert.ToString(e.Message), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Warning {0} - Issue with node {1}.", "GetNodeByNameAndLogWarningTrans", nodeName));
                return null;
            }
        }

        public static XmlNode GetNodeByNameAndInnerTextLogWarningTrans(this XmlNode fromNode, XmlNamespaceManager nsMgr, string nodeName, string warningNumber, ProcessData processData, string methodName = "")
        {
            try
            {                
                XmlNode foundNode = fromNode.SelectSingleNode(nodeName, nsMgr);
                if (foundNode == null || string.IsNullOrEmpty(foundNode.InnerText))
                    LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("2.{0}", warningNumber), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Warning {0} - Issue with node {1}.", "GetNodeByNameAndInnerTextLogWarningTrans", nodeName));
                return foundNode;
            }
            catch (Exception e)
            {
                LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("2.{0}", warningNumber), string.Format("Warning - There was an exception retrieving {0} xml node or tag.", nodeName), Convert.ToString(e.Message), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Warning {0} - Issue with node {1}.", "GetNodeByNameAndInnerTextLogWarningTrans", nodeName));
                return null;
            }
        }

        public static XmlNode GetNodeByNameAndLogErrorTrans(this XmlNode fromNode, XmlNamespaceManager nsMgr, string nodeName, string errorNumber, ProcessData processData, string methodName = "")
        {
            try
            {

                XmlNode foundNode = fromNode.SelectSingleNode(nodeName, nsMgr);//
                if (foundNode == null || string.IsNullOrEmpty(foundNode.InnerText))
                    LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("3.{0}", errorNumber), string.Format("Error - There was an exception retrieving {0} xml node or tag or empty.", nodeName), string.Format("Error - There was an exception retrieving {0} xml node or tag or empty.", nodeName), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Error {0} - Issue with node {1}.", "GetNodeByNameAndLogErrorTrans", nodeName));
                return foundNode;
            }
            catch (Exception e)
            {
                LogTransaction(processData.WebUserName, processData.FtpUserName, !string.IsNullOrEmpty(methodName) ? methodName : "ValidateScheduleShippingXmlDocument", string.Format("3.{0}", errorNumber), string.Format("Error - There was an exception retrieving {0} xml node or tag or empty.", nodeName), Convert.ToString(e.Message), processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, string.Format("Error {0} - Issue with node {1}.", "GetNodeByNameAndLogErrorTrans", nodeName));
                return null;
            }
        }

        /// <summary>
        /// Sets the ShippingSchedule Other Schedule Reference properties used to output the xCBL data
        /// </summary>
        /// <param name="referenceDescription">The Reference Description text to output</param>
        /// <param name="shippingSchedule">The ShippingSchedule object that is set</param>
        /// <param name="otherScheduleReferenceIndex">The index of the Other Schedule Reference item</param>
        //private void SetOtherScheduleReference(string referenceDescription, ref ShippingSchedule referenceType, int otherScheduleReferenceIndex)
        public static void SetOtherScheduleReferenceDesc(this ShippingSchedule shippingSchedule, string referenceTypeCodedOther, string referenceDescription)
        {
            string referenceTypeCoded = string.Format("Other_{0}", referenceTypeCodedOther).ToLower().Trim();

            switch (referenceTypeCoded)
            {
                case "other_firststop":
                    shippingSchedule.Other_FirstStop = referenceDescription;
                    break;
                case "other_before7":
                    shippingSchedule.Other_Before7 = referenceDescription;
                    break;
                case "other_before9":
                    shippingSchedule.Other_Before9 = referenceDescription;
                    break;
                case "other_before12":
                    shippingSchedule.Other_Before12 = referenceDescription;
                    break;
                case "other_sameday":
                    shippingSchedule.Other_SameDay = referenceDescription;
                    break;
                case "other_homeowneroccupied":
                    shippingSchedule.Other_OwnerOccupied = referenceDescription;
                    break;
                case "other_workordernumber":
                    shippingSchedule.WorkOrderNumber = referenceDescription;
                    shippingSchedule.Other_7 = referenceDescription;
                    break;
                case "other_ssid":
                    shippingSchedule.SSID = referenceDescription;
                    shippingSchedule.Other_8 = referenceDescription;
                    break;
                case "other_7":
                    shippingSchedule.Other_7 = referenceDescription;
                    break;
                case "other_8":
                    shippingSchedule.Other_8 = referenceDescription;
                    break;
                case "other_9":
                    shippingSchedule.Other_9 = referenceDescription;
                    break;
                case "other_10":
                    shippingSchedule.Other_10 = referenceDescription;
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// Sets the ShippingSchedule Contact Numbers properties used to output the xCBL data
        /// </summary>
        /// <param name="contactNumber">The Contact Number text</param>
        /// <param name="shippingSchedule">The ShippingSchedule object that is set</param>
        /// <param name="contactNumberIndex">The index of the Contact Number item</param>
        public static void SetContactNumbers(this ShippingSchedule shippingSchedule, string contactNumber, int contactNumberIndex)
        {
            switch (contactNumberIndex)
            {
                case 0:
                    shippingSchedule.ContactNumber_1 = contactNumber;
                    break;
                case 1:
                    shippingSchedule.ContactNumber_2 = contactNumber;
                    break;
                case 2:
                    shippingSchedule.ContactNumber_3 = contactNumber;
                    break;
                case 3:
                    shippingSchedule.ContactNumber_4 = contactNumber;
                    break;
                case 4:
                    shippingSchedule.ContactNumber_5 = contactNumber;
                    break;
                case 5:
                    shippingSchedule.ContactNumber_6 = contactNumber;
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// The function which replaces the special characters (Comma, Carriage return and Line Feed) to space found in the xml String
        /// </summary>
        /// <param name="value">Xml Data</param>
        public static string ReplaceSpecialCharsWithSpace(this string value)
        {
            try
            {
                if (!string.IsNullOrEmpty(value))
                {
                    char charLineFeed = (char)10;
                    char charCarriageReturn = (char)13;
                    char charComma = (char)44;

                    if (value.IndexOf(charCarriageReturn) != -1)
                        value = value.Replace(charCarriageReturn.ToString(), " ");

                    if (value.IndexOf(charLineFeed) != -1)
                        value = value.Replace(charLineFeed.ToString(), " ");

                    if (value.IndexOf(charComma) != -1)
                        value = value.Replace(charComma.ToString(), " ");
                }
                return value;
            }
            catch
            {
                return value;
            }
        }
    }


}