using System;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Xml;

namespace xCBLSoapWebService
{
    public class CommonProcess
    {
        /// <summary>
        /// To authenticate request whether it has valid credential to proceed
        /// </summary>
        /// <param name="xCblServiceUser">Service User</param>
        /// <param name="operationContext">Current OperationContext</param>
        /// <returns></returns>
        internal static bool IsAuthenticatedRequest(OperationContext operationContext, ref XCBL_User xCblServiceUser)
        {
            try
            {
                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                int index = operationContext.IncomingMessageHeaders.FindHeader("Credentials", "");

                // Retrieve the first soap headers, this should be the Credentials tag
                MessageHeaderInfo messageHeaderInfo = operationContext.IncomingMessageHeaders[index];

                xCblServiceUser = Meridian_AuthenticateUser(operationContext.IncomingMessageHeaders, messageHeaderInfo, index);
                if (xCblServiceUser == null || string.IsNullOrEmpty(xCblServiceUser.WebUsername) || string.IsNullOrEmpty(xCblServiceUser.FtpUsername))
                {
                    MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "03.01", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction("No WebUser", "No FTPUser", "IsAuthenticatedRequest", "03.01", "Error - New SOAP Request not authenticated", "UnAuthenticated Request", "No FileName", "No Schedule ID", "No Order Number", null, "Error");
                return false;
            }
        }

        /// <summary>
        /// This function will authenticate the User with Username and Password
        /// </summary>
        /// <param name="messageHeaders">SOAP MessageHeaders </param>
        /// <param name="messageHeaderInfo">MessageHeaderInfo - Contains the Soap Credential Header</param>
        /// <param name="objXCBLUser">Object - Holds the user related information</param>
        /// <returns></returns>
        private static XCBL_User Meridian_AuthenticateUser(MessageHeaders messageHeaders, MessageHeaderInfo messageHeaderInfo, int index)
        {
            try
            {
                string username = string.Empty;
                string password = string.Empty;
                string hashkey = string.Empty;

                // Retrieve the Credential header information
                // If a separate namespace is needed for the Credentials tag use the global const CREDENTIAL_NAMESPACE that is commented below
                if (messageHeaderInfo.Name == MeridianGlobalConstants.CREDENTIAL_HEADER)// && h.Namespace == MeridianGlobalConstants.CREDENTIAL_NAMESPACE)
                {
                    // read the value of that header
                    XmlReader xr = messageHeaders.GetReaderAtHeader(index);
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

        /// <summary>
        /// To Delete created file
        /// </summary>
        /// <param name="filePath">File Path</param>
        /// <param name="processData">Process Data</param>
        /// <returns></returns>
        internal static bool DeleteFile(string filePath, MeridianResult meridianResult)
        {
            bool result = false;
            try
            {
                if (File.Exists(filePath))
                {
                    string fileName = Path.GetFileName(filePath);
                    string ext = Path.GetExtension(filePath);
                    File.Delete(filePath);
                    result = true;
                    MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "DeleteFile", "01.07", string.Format("Success - Deleted CSV file {0} after ftp upload: {0}", fileName), string.Format("Deleted CSV file: {0}", fileName), fileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Success");
                }
                result = true;
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "DeleteFile", "03.09", "Error - Delete CSV File", string.Format("Error - While deleting local CSV file: {0} with error {1}", meridianResult.FileName, ex.Message), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 09 - While deleting local CSV file");
                result = false;
            }
            return result;
        }

        /// <summary>
        /// To Create file if not exist and on catch safer side: if first call created file but on write got issue so deleting that fine so that for next createfile call it creates again and close. 
        /// </summary>
        /// <param name="filePath">File Path </param>
        /// <param name="content">Content want to write</param>
        /// <param name="processData">Process Data</param>
        /// <returns></returns>
        internal static bool CreateFile(string content, MeridianResult meridianResult)
        {
            try
            {
                var filePath = meridianResult.LocalFilePath + meridianResult.FileName;
                string fileName = Path.GetFileName(filePath);
                string ext = Path.GetExtension(filePath);
                DeleteFile(filePath, meridianResult);// Safer side 
                File.Create(filePath).Close();
                File.WriteAllText(filePath, content);
                MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "CreateFile", "01.04", "Success - Created CSV File", "CSV File Created", meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Success");
                return true;
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "CreateFile", "03.12", "Error - Created Local CSV File", string.Format("Error - While creating local CSV file: {0} with error {1}", meridianResult.FileName, ex.Message), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 12 - While creating local CSV file");
                return false;
            }
        }
    }
}