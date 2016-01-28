//===============================================================================================================
//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//===============================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Ramkumar Muthyalu
//Date Programmed:                              12/17/2015
//Program Name:                                 Meridian Shipping ScheduleMessage
//Purpose:                                      The module contains functions that are used in Meridian XCBL Web service will take the Xml file as input and 
//                                              The module’s functions converts the XML file to CSV file and copies it to FTP server
//
//=============================================================================================================== 

using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.Xml;
using System.Xml.Linq;

namespace XCBL.WebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    public class MeridianService : IMeridianService
    {

        // Use the XCBL_User object throughout the web service. Populate the object by calling the sysGetAuthenticationByUsernameAndPassword method in the MeridianSystemLibrary class
        // Example: xCblServiceUser = MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword("MeridanUser1", "Meridan123");
        // This will populate with object which can be used throughout the web service, especially inserting transaction records during exceptions
        XCBL_User xCblServiceUser = null;

        /// <summary>
        /// This function will return the Success / Failure of the Action performed which tranferring the CSV file.
        /// </summary>
        /// <param name="xmldoc">Object - XCBL file which is uploaded to Service</param>
        /// <returns></returns>
        public string Meridian_SendScheduleMessage(XCBLService xmldoc)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            string filePath = string.Empty;
            string scheduleID = string.Empty;

            xCblServiceUser = xmldoc.XCBLUser;

            try
            {
                

                //// http headers Readers
                //WebHeaderCollection headers = WebOperationContext.Current.IncomingRequest.Headers;
                //UserInfo username = Newtonsoft.Json.JsonConvert.DeserializeObject<UserInfo>(headers["UserName"]);
                //var password = headers["Password"];



                //Validate the User Credentials if the User is Authenticated or not
                if (Meridian_AuthenticateUser(ref xCblServiceUser))
                {

                    //byte[] xdoc = xmldoc.XCBLDocument;
                    IncomingWebRequestContext context = WebOperationContext.Current.IncomingRequest;

                    //string XslFilename = System.Text.Encoding.Default.GetString(xdoc);
                    string XslFilename = xmldoc.XCBLDocument;

                    StringReader SR = new StringReader(XslFilename);

                    DataSet ds = new DataSet();
                    //Read the XCBL file passed from the Client Call
                    ds.ReadXml(SR);
                    StringBuilder csvoutput = new StringBuilder();
                    csvoutput.AppendLine(MeridianGlobalConstants.CSV_HEADER_NAMES);

                    scheduleID = ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_ID].ToString();

                    string Other_FirstStop = string.Empty, Other_Before7 = string.Empty, Other_Before9 = string.Empty, Other_Before12 = string.Empty, Other_SameDay = string.Empty, Other_OwnerOccupied = string.Empty;
                    string PurposeCoded = ds.Tables[MeridianGlobalConstants.XCBL_PURPOSE].Select(MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID + "=" + ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID].ToString()).CopyToDataTable().Rows[0][MeridianGlobalConstants.XCBL_PURPOSE_CODED].ToString();
                    string ScheduleTypeCoded = string.Empty;
                    try
                    {
                        ScheduleTypeCoded = ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Select(MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID + "=" + ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID].ToString()).CopyToDataTable().Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED].ToString();
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if ScheduleTypeCoded in xCBL file is blank.
                        ScheduleTypeCoded = "";
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.0", "Warning - The Select Statement for the ScheduleTypeCoded is Empty", Convert.ToString(e.InnerException), xmldoc.XCBL_FileName, scheduleID);
                    }
                    string ContactNumber_1 = string.Empty, ContactNumber_2 = string.Empty;
                    DataTable dtTelphone = null;


                    // Reading all column values from xCBL file and writing into csv file.
                    for (int i = 0; i < ds.Tables[MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE].Rows.Count; i++)
                    {
                        dtTelphone = ds.Tables[MeridianGlobalConstants.XCBL_CONTACT_NUMBER].Select(MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBER_ID + "=" + i).CopyToDataTable();
                        if (dtTelphone.Rows.Count > 0)
                        {
                            ContactNumber_1 = dtTelphone.Rows[0][MeridianGlobalConstants.XCBL_CONTACT_NUMBER_VALUE].ToString();
                            try
                            {
                                ContactNumber_2 = dtTelphone.Rows[1][MeridianGlobalConstants.XCBL_CONTACT_NUMBER_VALUE].ToString();
                            }
                            catch (Exception e)
                            {
                                //Handling the exception if ContactNumber_2 in xCBL file is blank.
                                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.1", "Error - The Contact Number are incorrect", Convert.ToString(e.InnerException), xmldoc.XCBL_FileName, scheduleID);
                            }
                        }

                        dtTelphone = ds.Tables[MeridianGlobalConstants.XCBL_REFERENCE_CODED].Select(MeridianGlobalConstants.XCBL_OTHER_SCHEDULE_REFERENCES_ID + "=" + i).CopyToDataTable();
                        if (dtTelphone.Rows.Count > 0)
                        {
                            Other_FirstStop = dtTelphone.Rows[0][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                            Other_Before7 = dtTelphone.Rows[1][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                            Other_Before9 = dtTelphone.Rows[2][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                            Other_Before12 = dtTelphone.Rows[3][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                            Other_SameDay = dtTelphone.Rows[4][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                            Other_OwnerOccupied = dtTelphone.Rows[5][MeridianGlobalConstants.XCBL_REFERENCE_DESCRIPTION].ToString();
                        }

                        // preparing string builder data which needs to be written to CSV file.
                        csvoutput.AppendLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35}", ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_ID], ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_ISSUED_DATE]
                            , ds.Tables[MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE].Rows[i][MeridianGlobalConstants.XCBL_SELLER_ORDER_NUMBER], ds.Tables[MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE].Rows[i][MeridianGlobalConstants.XCBL_CHANGE_ORDER_SEQUENCE_NUMBER]
                            , Other_FirstStop, Other_Before7, Other_Before9, Other_Before12, Other_SameDay, Other_OwnerOccupied, "", "", "", "", PurposeCoded, ScheduleTypeCoded
                            , ds.Tables[MeridianGlobalConstants.XCBL_AGENCY].Rows[i][MeridianGlobalConstants.XCBL_AGENCY_CODED], ds.Tables[MeridianGlobalConstants.XCBL_NAME_ADDRESS].Rows[i][MeridianGlobalConstants.XCBL_NAME].ToString().Replace(",", ";"), ds.Tables[MeridianGlobalConstants.XCBL_NAME_ADDRESS].Rows[i][MeridianGlobalConstants.XCBL_STREET].ToString().Replace(',', ';'), ds.Tables[MeridianGlobalConstants.XCBL_NAME_ADDRESS].Rows[i][MeridianGlobalConstants.XCBL_STREET_SUPPLEMENT], ds.Tables[MeridianGlobalConstants.XCBL_NAME_ADDRESS].Rows[i][MeridianGlobalConstants.XCBL_POSTAL_CODE], ds.Tables[MeridianGlobalConstants.XCBL_NAME_ADDRESS].Rows[i][MeridianGlobalConstants.XCBL_CITY]
                            , ds.Tables[MeridianGlobalConstants.XCBL_REGION].Rows[i][MeridianGlobalConstants.XCBL_REGION_CODED], ds.Tables[MeridianGlobalConstants.XCBL_PRIMARY_CONTACT].Rows[i][MeridianGlobalConstants.XCBL_CONTACT_NAME].ToString().Replace(",", ";"), ContactNumber_1, ContactNumber_2, "", "", "", "", ds.Tables[MeridianGlobalConstants.XCBL_TRANSPORT_ROUTING].Rows[i][MeridianGlobalConstants.XCBL_SHIPPING_INSTRUCTIONS]
                            , ds.Tables[MeridianGlobalConstants.XCBL_GPS_COORDINATES].Rows[i][MeridianGlobalConstants.XCBL_GPS_SYSTEM], ds.Tables[MeridianGlobalConstants.XCBL_GPS_COORDINATES].Rows[i][MeridianGlobalConstants.XCBL_LATITUDE], ds.Tables[MeridianGlobalConstants.XCBL_GPS_COORDINATES].Rows[i][MeridianGlobalConstants.XCBL_LONGITUDE], ds.Tables[MeridianGlobalConstants.XCBL_LOCATION].Rows[i][MeridianGlobalConstants.XCBL_LOCATION_ID], ds.Tables[MeridianGlobalConstants.XCBL_END_TRANSPORT_LOCATION].Rows[i][MeridianGlobalConstants.XCBL_ESTIMATED_ARRIVAL_DATE]
                            ));

                    }

                    //Creating the CSV file on the Server Desktop - (Webservice hosted)
                    string pathDesktop = System.Configuration.ConfigurationManager.AppSettings["CsvPath"].ToString();

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
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if CSV file is not valid.
                        status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.2", "Error - The CSV file cannot be created or closed.", Convert.ToString(e.InnerException), xmldoc.XCBL_FileName, scheduleID);
                        return GetMeridian_Status(status, scheduleID);
                    }


                    // This should be updated to use the XCBL_User xCblServiceUser variable that contains the FTP server url, FTP username, and FTP password
                    // Make sure the xCblServiceUser object is not null for the FTP credentials
                    try
                    {
                        Meridian_FTPUpload(MeridianGlobalConstants.FTP_SERVER_URL, xCblServiceUser.FtpUsername, xCblServiceUser.FtpPassword, filePath, xCblServiceUser, scheduleID);
                    }
                    catch (Exception e)
                    {
                        //Handling the exception if any FTP Error occurs while transferring the CSV file.
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "1.1", "Error - The FTP Error while transferring the CSV file.", Convert.ToString(e.InnerException), xmldoc.XCBL_FileName, scheduleID);
                        return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, scheduleID);
                    }

                    status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
                    return GetMeridian_Status(status, scheduleID);
                }
                else
                {
                    //Handling the exception if FTP Username/Password is invalid.
                    status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                    MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_AuthenticateUser", "1.1", "Error - The Incorrect Username /  Password", "", xmldoc.XCBL_FileName, scheduleID);

                    return GetMeridian_Status(status, scheduleID);

                }
            }
            catch (Exception e)
            {
                //Handling the exception if the XML Document cannot be parsed.
                status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.1", "Error - The XML Document cannot be parsed", Convert.ToString(e.InnerException), xmldoc.XCBL_FileName, scheduleID);
                return GetMeridian_Status(status, scheduleID);
            }
        }
        
        /// <summary>
        /// This function will return the Success / Failure of the Action performed which tranferring the CSV file.
        /// </summary>
        /// <param name="status">string - holds the Error Message - status</param>
        /// <param name="scheduleID">string which is unique id of the XCBL file which is to be uploaded</param>
        /// <returns></returns>
        private static String GetMeridian_Status(string status, string scheduleID)
        {
            StringBuilder messageResponse = new StringBuilder();
            messageResponse.AppendLine(MeridianGlobalConstants.XML_HEADER + Environment.NewLine);
            messageResponse.AppendLine(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_OPEN_TAG);
            messageResponse.AppendLine(string.Format("{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_OPEN_TAG + "{1}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG, Environment.NewLine, scheduleID));
            messageResponse.AppendLine(string.Format("{0}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_OPEN_TAG + "{1}" + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_NOTE_CLOSE_TAG, Environment.NewLine, status));
            messageResponse.AppendLine(Environment.NewLine + MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG);
            return messageResponse.ToString();
        }

        /// <summary>
        /// This function will authenticate the User with Username and Password
        /// </summary>
        /// <param name="objXCBLUser">Object - holds the user related information</param>
        /// <returns></returns>
        private bool Meridian_AuthenticateUser(ref XCBL_User objXCBLUser)
        {
            try
            {
                int count = 0;
                int index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Username", "");
                string username="", password="", hashkey=""; 
                if (index >= 0)
                {
                     username = OperationContext.Current.IncomingMessageHeaders.GetHeader<string>("Username", "");
                    count++;
                    //  XCBL_User username1 = Newtonsoft.Json.JsonConvert.DeserializeObject<XCBL_User>(value);
                }

              
                index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Password", "");
                if (index >= 0)
                {
                     password = OperationContext.Current.IncomingMessageHeaders.GetHeader<string>("Password", "");
                    count++;
                }

                index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Hashkey", "");
                if (index >= 0)
                {
                    hashkey = OperationContext.Current.IncomingMessageHeaders.GetHeader<string>("Hashkey", "");
                    count++;
                }


                if (count == 3)
                {
                    objXCBLUser.WebUsername = Encryption.Decrypt(username, hashkey);
                    objXCBLUser.WebPassword = Encryption.Decrypt(password, hashkey);
                    objXCBLUser = MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword(objXCBLUser);
                    return (objXCBLUser != null) ? true : false ;               
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
                client.UploadFile(ftpServer + "/" + new FileInfo(filename).Name, "STOR", filename);
            }
        }

        /// <summary>
        /// This function will Encrypt the WebUsername and WebPassword with Hashkey password
        /// </summary>
        /// <param name="xmldoc">object - XCBL file which is uploaded to Service</param>
        public void Meridian_EncrpytCredentials(ref XCBLService xmldoc)
        {
            XCBL_User objuser = xmldoc.XCBLUser;
            xmldoc.XCBLUser = MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword(xmldoc.XCBLUser);
            if (xmldoc.XCBLUser != null)
            {
                xmldoc.XCBLUser.WebUsername = Encryption.Encrypt(xmldoc.XCBLUser.WebUsername, xmldoc.XCBLUser.Hashkey);
                xmldoc.XCBLUser.WebPassword = Encryption.Encrypt(xmldoc.XCBLUser.WebPassword, xmldoc.XCBLUser.Hashkey);
            }
            else xmldoc.XCBLUser = objuser;

            return;
        }
    }
}

