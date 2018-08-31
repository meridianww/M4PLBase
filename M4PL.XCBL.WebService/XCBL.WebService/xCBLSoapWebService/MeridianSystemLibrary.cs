//Copyright (2016) Meridian Worldwide Transportation Group
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
using System.IO;
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
        public static int sysInsertTransactionRecord(string webUser, string ftpUser, string methodName, string messageNumber, string messageDescription, string microsoftDescription, string filename, string documentId, string TranOrderNo, XmlDocument TranXMLData, string TranMessageCode)
        {
            try
            {
                // 
                if (webUser == null) webUser = string.Empty;
                if (ftpUser == null) ftpUser = string.Empty;


                //Set up a new StringReader populated with the XmlDocument object's outer Xml
                XmlNodeReader srObject = new XmlNodeReader(TranXMLData);
                //string insertQuery = @"INSERT INTO MER010TransactionLog ([TranDatetime],[TranWebUser],[TranFtpUser],[TranWebMethod],[TranWebMessageNumber],[TranWebMessageDescription],
                //        [TranWebMicrosoftDescription],[TranWebFilename],[TranWebDocumentID],[TranOrderNo],[TranXMLData],[TranMessageCode]) VALUES (@TransactionDate,@TransactionWebUser,@TransactionFtpUser,@TransactionMethodName,@TransactionMessageNumber,
                //        @TransactionMessageDescription,@TransactionMSDescription,@TransactionWebFilename,@TransactionWebDocumentID,@TranOrderNo,@TranXMLData,@TranMessageCode)";

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
            catch
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
        public static XCBL_User sysGetAuthenticationByUsernameAndPassword(XCBL_User objXCBLUser)
        {

            // If either the username or password are empty then return null for the method
            if (string.IsNullOrEmpty(objXCBLUser.WebUsername) || string.IsNullOrEmpty(objXCBLUser.WebPassword))
                return null;

            // Try to retrieve the authentication record based on the specified username and password
            try
            {
                DataSet dsRecords = new DataSet();
                string selectQuery = @"SELECT [ID],[WebUsername],[WebPassword],[WebHashKey],[FtpUsername],[FtpPassword],[FtpServerUrl],[WebContactName],[WebContactCompany],[WebContactEmail],"
                        + "[WebContactPhone1],[WebContactPhone2],[Enabled] FROM MER000Authentication WHERE [WebUsername] = @webUsername AND [WebPassword] = @WebPassword AND [Enabled] = 1";

                using (SqlConnection sqlConnection = new SqlConnection(MeridianGlobalConstants.XCBL_DATABASE_SERVER_URL))
                {
                    sqlConnection.Open();
                    using (SqlCommand sqlCommand = new SqlCommand(selectQuery, sqlConnection))
                    {
                        sqlCommand.Parameters.Add("webUsername", SqlDbType.NVarChar).Value = objXCBLUser.WebUsername;
                        sqlCommand.Parameters.Add("webPassword", SqlDbType.NVarChar).Value = objXCBLUser.WebPassword;

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
                    sysInsertTransactionRecord(objXCBLUser.WebUsername, "", "sysGetAuthenticationByUsername", "0.0", "Warning - Cannot retrieve record from MER000Authentication table", ex.InnerException.ToString(), "", "", "", null, "Warning 26 - DB Connection");
                }
                catch
                {
                }
                return null;
            }
        }
        #endregion


        /// <summary>
        /// The function which replaces the special characters (Comma, Carriage return and Line Feed) to space found in the xml String
        /// </summary>
        /// <param name="value">string value</param>
        public static string HandleSpecialChars(this string value)
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
    
    #region XCBL_User Class
    /// <summary>
    /// The XCBL_User class is an class object to store the authentication credentials retrieve from MER000Authentication table and used throughout the project for transaction logging
    /// </summary>

    public class XCBL_User
    {
        /// <summary>
        /// The xCBL Web Service Username 
        /// </summary>

        public string WebUsername { get; set; }

        /// <summary>
        /// The xCBL Web Service Password
        /// </summary>

        public string WebPassword { get; set; }

        /// <summary>
        /// The xCBL Web Service Hashkey for the User
        /// </summary>

        public string Hashkey { get; set; }

        /// <summary>
        /// The FTP Username to upload CSV files
        /// </summary>

        public string FtpUsername { get; set; }

        /// <summary>
        /// The FTP Password to upload CSV files
        /// </summary>

        public string FtpPassword { get; set; }

        /// <summary>
        /// The FTP Server URL
        /// </summary>

        public string FtpServerUrl { get; set; }

        /// <summary>
        /// The Contact Name for the Web Service to contact if an issue is encountered
        /// </summary>

        public string WebContactName { get; set; }

        /// <summary>
        /// The Company name of the Contact 
        /// </summary>

        public string WebContactCompany { get; set; }

        /// <summary>
        /// The Email address of the Contact
        /// </summary>

        public string WebContactEmail { get; set; }

        /// <summary>
        /// The first Phone Number option of the Contact
        /// </summary>

        public string WebContactPhone1 { get; set; }

        /// <summary>
        /// The second Phone Number option of the contact
        /// </summary>

        public string WebContactPhone2 { get; set; }

        /// <summary>
        /// If the user record is enabled or disabled
        /// </summary>

        public Boolean Enabled { get; set; }

    }
    #endregion
}