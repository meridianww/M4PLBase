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

                string xml = request.ToString();
                XmlDocument xmlDoc = new XmlDocument();
                xCblServiceUser = new XCBL_User();

                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                int index = OperationContext.Current.IncomingMessageHeaders.FindHeader("Credentials", "");//MeridianGlobalConstants.CREDENTIAL_NAMESPACE);

                // Retrieve the first soap headers, this should be the Credentials tag
                MessageHeaderInfo header = OperationContext.Current.IncomingMessageHeaders[0];

                // Authenticate the user credentials and process the xCBL data
                if (Meridian_AuthenticateUser(header, ref xCblServiceUser))
                {
                    xmlDoc.LoadXml(xml);

                    string xmlResponse;
                    xmlResponse = xcblProcessXML(xmlDoc);
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
        /// This is the function that will parse the xCBL Shipping Schedule XML data from the web request
        /// </summary>
        /// <param name="xmlDoc">XmlDocument - xCBL Shipping Schedule Data</param>
        /// <returns>String - Returns the string Message Acknowledgement</returns>
        private string xcblProcessXML(XmlDocument xmlDoc)
        {
            string status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            string filePath = string.Empty;
            string scheduleID = string.Empty;

            StringBuilder csvoutput = new StringBuilder();
            csvoutput.AppendLine(MeridianGlobalConstants.CSV_HEADER_NAMES);

            XmlNodeList shippingElement = xmlDoc.GetElementsByTagName("ShippingSchedule");

            DataSet ds = new DataSet();
            string XslFilename = shippingElement[0].InnerXml;

            StringReader SR = new StringReader(XslFilename);
            //Read the XCBL file passed from the Client Call
            ds.ReadXml(SR);

            scheduleID = ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_ID].ToString();

            string Other_FirstStop = string.Empty, Other_Before7 = string.Empty, Other_Before9 = string.Empty, Other_Before12 = string.Empty, Other_SameDay = string.Empty, Other_OwnerOccupied = string.Empty;
            string PurposeCoded = ds.Tables[MeridianGlobalConstants.XCBL_PURPOSE].Select(string.Format("{0}={1}", MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID, ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID])).CopyToDataTable().Rows[0][MeridianGlobalConstants.XCBL_PURPOSE_CODED].ToString();
            string ScheduleTypeCoded = string.Empty;
            try
            {
                ScheduleTypeCoded = ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Select(string.Format("{0}={1}", MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID, ds.Tables[MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER].Rows[0][MeridianGlobalConstants.XCBL_SHIPPING_SCHEDULE_HEADER_ID])).CopyToDataTable().Rows[0][MeridianGlobalConstants.XCBL_SCHEDULE_TYPE_CODED].ToString();
            }
            catch (Exception e)
            {
                //Handling the exception if ScheduleTypeCoded in xCBL file is blank.
                ScheduleTypeCoded = "";
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.0", "Warning - The Select Statement for the ScheduleTypeCoded is Empty", Convert.ToString(e.InnerException), "", scheduleID);
            }
            string ContactNumber_1 = string.Empty, ContactNumber_2 = string.Empty;
            DataTable dtTelphone = null;

            // Reading all column values from xCBL file and writing into csv file.
            for (int i = 0; i < ds.Tables[MeridianGlobalConstants.XCBL_PURCHASE_ORDER_REFERENCE].Rows.Count; i++)
            {
                dtTelphone = ds.Tables[MeridianGlobalConstants.XCBL_CONTACT_NUMBER].Select(string.Format("{0}={1}", MeridianGlobalConstants.XCBL_LIST_OF_CONTACT_NUMBER_ID, i)).CopyToDataTable();
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
                        MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.1", "Error - The Contact Number are incorrect", Convert.ToString(e.InnerException), "", scheduleID);
                    }
                }

                dtTelphone = ds.Tables[MeridianGlobalConstants.XCBL_REFERENCE_CODED].Select(string.Format("{0}={1}", MeridianGlobalConstants.XCBL_OTHER_SCHEDULE_REFERENCES_ID, i)).CopyToDataTable();
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
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_SendScheduleMessage", "1.2", "Error - The CSV file cannot be created or closed.", Convert.ToString(e.InnerException), "", scheduleID);
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
                MeridianSystemLibrary.sysInsertTransactionRecord(xCblServiceUser.WebUsername, xCblServiceUser.FtpUsername, "Meridian_FTPUpload", "1.3", "Error - The FTP Error while transferring the CSV file.", Convert.ToString(e.InnerException), "", scheduleID);
                return GetMeridian_Status(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, scheduleID);
            }

            status = MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS;
            return GetMeridian_Status(status, scheduleID);
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
        private bool Meridian_AuthenticateUser(MessageHeaderInfo header, ref XCBL_User objXCBLUser)
        {
            try
            {
                string username = null;
                string password = null;
                string hashkey = null;

                MessageHeaderInfo h = OperationContext.Current.IncomingMessageHeaders[0];

                // Retrieve the Credential header information
                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                if (h.Name == MeridianGlobalConstants.CREDENTIAL_HEADER)// && h.Namespace == MeridianGlobalConstants.CREDENTIAL_NAMESPACE)
                {
                    // Ram - See if there is a better solution to retrieving and parsing the Credential header information.
                    // read the value of that header
                    XmlReader xr = OperationContext.Current.IncomingMessageHeaders.GetReaderAtHeader(0);
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
                client.UploadFile(ftpServer + "/" + new FileInfo(filename).Name, "STOR", filename);
            }
        }
    }
}
