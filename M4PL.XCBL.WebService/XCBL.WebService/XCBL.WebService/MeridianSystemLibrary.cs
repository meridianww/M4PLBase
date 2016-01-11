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
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace XCBL.WebService
{
    public static partial class MeridianSystemLibrary
    {
        #region Meridian SYST000XCBLService Database Methods
        // Get the database connection to the SYST010MeridianXCBLService Database on Meridian Development Server
        private static SqlConnection scDatabaseConnection = new SqlConnection(MeridianGlobalConstants.XCBL_DATABASE_SERVER_URL);

        /// <summary>
        /// Insert a record into the MER010TransactionLog table on the Meridian Development Server.
        /// </summary>
        /// <param name="webUser">String - The xCBL Web Service Username consuming the web service</param>
        /// <param name="ftpUser">String - The FTP Username currently assigned to the web username</param>
        /// <param name="methodName">String - The method name of where the transaction record is being called</param>
        /// <param name="messageNumber">String - The Message Number of the specific message to insert</param>
        /// <param name="messageDescription">String - The Message Description for the transaction record to provide more information or detail</param>
        /// <param name="microsoftDescription">String - The Exception Message supplied by Microsoft when an error is encountered</param>
        /// <param name="filename">String - The Filename of the xCBL file to upload</param>
        /// <param name="documentId">String - The Document ID assigned to the xCBL file</param>
        public static void sysInsertTransactionRecord(String webUser, String ftpUser, String methodName, String messageNumber, String messageDescription, String microsoftDescription, String filename, String documentId)
        {
            try
            {
                // Try to insert the record into the MER010TransactionLog table
                SqlCommand scInsertTransactionRecord = new SqlCommand(@"INSERT INTO MER010TransactionLog ([TranDatetime],[TranWebUser],[TranFtpUser],[TranWebMethod],[TranWebMessageNumber],[TranWebMessageDescription],
                        [TranWebMicrosoftDescription],[TranWebFilename],[TranWebDocumentID]) VALUES (@TransactionDate,@TransactionWebUser,@TransactionFtpUser,@TransactionMethodName,@TransactionMessageNumber,
                        @TransactionMessageDescription,@TransactionMSDescription,@TransactionWebFilename,@TransactionWebDocumentID)", scDatabaseConnection);

                scInsertTransactionRecord.Parameters.Add("@TransactionDate", SqlDbType.DateTime).Value = DateTime.Now.ToString();
                scInsertTransactionRecord.Parameters.Add("@TransactionWebUser", SqlDbType.NVarChar).Value = webUser;
                scInsertTransactionRecord.Parameters.Add("@TransactionFtpUser", SqlDbType.NVarChar).Value = ftpUser;
                scInsertTransactionRecord.Parameters.Add("@TransactionMethodName", SqlDbType.NVarChar).Value = methodName;
                scInsertTransactionRecord.Parameters.Add("@TransactionMessageNumber", SqlDbType.NVarChar).Value = messageNumber;
                scInsertTransactionRecord.Parameters.Add("@TransactionMessageDescription", SqlDbType.NVarChar).Value = messageDescription;
                scInsertTransactionRecord.Parameters.Add("@TransactionMSDescription", SqlDbType.NVarChar).Value = microsoftDescription;
                scInsertTransactionRecord.Parameters.Add("@TransactionWebFilename", SqlDbType.NVarChar).Value = filename;
                scInsertTransactionRecord.Parameters.Add("@TransactionWebDocumentID", SqlDbType.NVarChar).Value = documentId;

                scDatabaseConnection.Open();
                scInsertTransactionRecord.ExecuteNonQuery();
                scDatabaseConnection.Close();
            }
            catch
            {
            }
        }

        /// <summary>
        /// Retrieve the authentication information for a specified xCBL Web Service username and password found in MER000Authentication table if the user is enabled
        /// </summary>
        /// <param name="username">String - The username assigned to the xCBL web service credentials</param>
        /// <param name="password">String - The password assigned to the xCBL web service credentials</param>
        /// <returns>XCBL_User - XCBL_User class object that contains the authentication information for the record matching the username and password</returns>
        public static XCBL_User sysGetAuthenticationByUsernameAndPassword(String username, String password)
        {


            // If either the username or password are empty then return null for the method
            if (String.IsNullOrEmpty(username) || String.IsNullOrEmpty(password))
                return null;

            // Try to retrieve the authentication record based on the specified username and password
            try
            {
                System.Data.DataSet dsRecords = new System.Data.DataSet();
                SqlCommand sqlQuery = new SqlCommand("SELECT [ID],[WebUsername],[WebPassword],[WebHashKey],[FtpUsername],[FtpPassword],[FtpServerUrl],[WebContactName],[WebContactCompany],[WebContactEmail],"
                    + "[WebContactPhone1],[WebContactPhone2],[Enabled] FROM MER000Authentication WHERE [WebUsername] = @webUsername AND [WebPassword] = @WebPassword AND [Enabled] = 1", scDatabaseConnection);
                sqlQuery.Parameters.Add("webUsername", SqlDbType.NVarChar).Value = username;
                sqlQuery.Parameters.Add("webPassword", SqlDbType.NVarChar).Value = password;

                // Fill the data adapter with the sql query results
                using (System.Data.SqlClient.SqlDataAdapter sdaAdapter = new SqlDataAdapter(sqlQuery))
                {
                    sdaAdapter.Fill(dsRecords);
                }

                // Parse the authentication record to a XCBL_User class object
                XCBL_User user = new XCBL_User();

                user.WebUsername = dsRecords.Tables[0].Rows[0].ItemArray[1].ToString();
                user.WebPassword = dsRecords.Tables[0].Rows[0].ItemArray[2].ToString();
                user.Hashkey = dsRecords.Tables[0].Rows[0].ItemArray[3].ToString();
                user.FtpUsername = dsRecords.Tables[0].Rows[0].ItemArray[4].ToString();
                user.FtpPassword = dsRecords.Tables[0].Rows[0].ItemArray[5].ToString();
                user.FtpServerUrl = dsRecords.Tables[0].Rows[0].ItemArray[6].ToString();
                user.WebContactName = dsRecords.Tables[0].Rows[0].ItemArray[7].ToString();
                user.WebContactCompany = dsRecords.Tables[0].Rows[0].ItemArray[8].ToString();
                user.WebContactEmail = dsRecords.Tables[0].Rows[0].ItemArray[9].ToString();
                user.WebContactPhone1 = dsRecords.Tables[0].Rows[0].ItemArray[10].ToString();
                user.WebContactPhone2 = dsRecords.Tables[0].Rows[0].ItemArray[11].ToString();
                user.Enabled = Boolean.Parse(dsRecords.Tables[0].Rows[0].ItemArray[12].ToString());

                return user;
            }
            catch (Exception ex)
            {
                // If there was an error encountered in retrieving the authentication record then try to insert a record in MER010TransactionLog table to record the issue
                try
                {
                    sysInsertTransactionRecord(username, "", "sysGetAuthenticationByUsername", "0.0", "Error - Cannot retrieve record from MER000Authentication table", ex.InnerException.ToString(), "", "");
                }
                catch
                {
                }
                return null;
            }
        }
        #endregion
    }        

    #region XCBL_User Class
    /// <summary>
    /// The XCBL_User class is an class object to store the authentication credentials retrieve from MER000Authentication table and used throughout the project for transaction logging
    /// </summary>
    public class XCBL_User
    {
        private String m_webUsername, m_webPassword, m_haskhey, m_ftpUsername, m_ftpPassword, m_ftpServerUrl, m_webContactName, m_webContactCompany, m_webContactEmail, m_webContactPhone1, m_webContactPhone2;
        private Boolean m_enabled;

        public XCBL_User()
        {
        }

        public XCBL_User(String webUsername, String webPassword, String hashkey, String ftpUsername, String ftpPassword, String ftpServerUrl, String webContactName, String webContactCompany, String webContactEmail, String webContactPhone1, String webContactPhone2, Boolean enabled)
        {
            m_webUsername = webUsername;
            m_webPassword = webPassword;
            m_haskhey = hashkey;
            m_ftpUsername = ftpUsername;
            m_ftpPassword = ftpPassword;
            m_ftpServerUrl = ftpServerUrl;
            m_webContactName = webContactName;
            m_webContactCompany = webContactCompany;
            m_webContactEmail = webContactEmail;
            m_webContactPhone1 = webContactPhone1;
            m_webContactPhone2 = webContactPhone2;
            m_enabled = enabled;
        }

        /// <summary>
        /// The xCBL Web Service Username 
        /// </summary>
        public String WebUsername
        {
            get
            {
                return m_webUsername;
            }
            set
            {
                m_webUsername = value;
            }
        }

        /// <summary>
        /// The xCBL Web Service Password
        /// </summary>
        public String WebPassword
        {
            get
            {
                return m_webPassword;
            }
            set
            {
                m_webPassword = value;
            }
        }

        /// <summary>
        /// The xCBL Web Service Hashkey for the User
        /// </summary>
        public String Hashkey
        {
            get
            {
                return m_haskhey;
            }
            set
            {
                m_haskhey = value;
            }
        }

        /// <summary>
        /// The FTP Username to upload CSV files
        /// </summary>
        public String FtpUsername
        {
            get
            {
                return m_ftpUsername;
            }
            set
            {
                m_ftpUsername = value;
            }
        }

        /// <summary>
        /// The FTP Password to upload CSV files
        /// </summary>
        public String FtpPassword
        {
            get
            {
                return m_ftpPassword;
            }
            set
            {
                m_ftpPassword = value;
            }
        }

        /// <summary>
        /// The FTP Server URL
        /// </summary>
        public String FtpServerUrl
        {
            get
            {
                return m_ftpServerUrl;
            }
            set
            {
                m_ftpServerUrl = value;
            }
        }

        /// <summary>
        /// The Contact Name for the Web Service to contact if an issue is encountered
        /// </summary>
        public String WebContactName
        {
            get
            {
                return m_webContactName;
            }
            set
            {
                m_webContactName = value;
            }
        }

        /// <summary>
        /// The Company name of the Contact 
        /// </summary>
        public String WebContactCompany
        {
            get
            {
                return m_webContactCompany;
            }
            set
            {
                m_webContactCompany = value;
            }
        }

        /// <summary>
        /// The Email address of the Contact
        /// </summary>
        public String WebContactEmail
        {
            get
            {
                return m_webContactEmail;
            }
            set
            {
                m_webContactEmail = value;
            }
        }

        /// <summary>
        /// The first Phone Number option of the Contact
        /// </summary>
        public String WebContactPhone1
        {
            get
            {
                return m_webContactPhone1;
            }
            set
            {
                m_webContactPhone1 = value;
            }
        }

        /// <summary>
        /// The second Phone Number option of the contact
        /// </summary>
        public String WebContactPhone2
        {
            get
            {
                return m_webContactPhone2;
            }
            set
            {
                m_webContactPhone2 = value;
            }
        }

        /// <summary>
        /// If the user record is enabled or disabled
        /// </summary>
        public Boolean Enabled
        {
            get
            {
                return m_enabled;
            }
            set
            {
                m_enabled = value;
            }
        }
    }
    #endregion
}