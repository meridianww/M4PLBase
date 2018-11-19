//Copyright (2018) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              2/6/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The web service allows the CDATA tag to not be included for AWC requirements and no WS-A addressing as requested 
//Modified by Programmer:                       Akhil Chauhan
//Date Programmed:                              3/9/2018
//Purpose:                                      Rewrited and Segregated methods and optimized logic also put more diagnostic for application 
//==================================================================================================================================================== 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Timers;
using System.Xml;
using System.Xml.Linq;
using System.Collections.Concurrent;
using System.Web.Hosting;
using System.Threading;

namespace xCBLSoapWebService
{
    /// <summary>
    /// Meridian Service 
    /// </summary>
    [ServiceBehavior(AddressFilterMode = AddressFilterMode.Any)]
    public class MeridianService : IMeridianService
    {
        /// <summary>
        /// First time configure method for Service
        /// </summary>
        /// <param name="config">service configuration to load</param>
        public static void Configure(ServiceConfiguration config)
        {
            string webConfigPath = string.Format("{0}web.config", HostingEnvironment.ApplicationPhysicalPath);
            config.LoadFromConfiguration(ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = webConfigPath }, ConfigurationUserLevel.None));
        }

        #region Useful code for XML to Create, Upload and Delete files with 5 times try
        ///// <summary>
        ///// To create Xml file and upload to ft
        ///// </summary>
        ///// <param name="processData">Process data</param>
        /////  param name="user">Service user </param>
        ///// <returns></returns>
        //private bool CreateLocalXmlFile(ProcessData processData, XCBL_User user)
        //{
        //    bool result = false;
        //    XmlNodeList shippingScheduleNode_xml = processData.XmlDocument.GetElementsByTagName(MeridianGlobalConstants.XCBL_ShippingScheule_XML_Http);
        //    string filePath = string.Format("{0}\\{1}", System.Configuration.ConfigurationManager.AppSettings["XmlPath"].ToString(), processData.XmlFileName);
        //    for (int i = 0; i < 5; i++)
        //    {
        //        if (CreateFile(filePath, shippingScheduleNode_xml[0].InnerXml, processData))
        //        {
        //            result = true;
        //            break;
        //        }
        //        if (i == 4)
        //            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalXmlFile", "3.07", "Error - Creating Xml File", string.Format("Error - Creating Xml File {0}", processData.XmlFileName), processData.XmlFileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, processData.XmlDocument, "Error 7- Creating XML File");
        //    }

        //    return result;
        //}

        ///// <summary>
        ///// To Create file if not exist and on catch safer side: if first call created file but on write got issue so deleting that fine so that for next createfile call it creates again and close. 
        ///// </summary>
        ///// <param name="filePath">File Path </param>
        ///// <param name="content">Content want to write</param>
        ///// <param name="processData">Process Data</param>
        ///// <returns></returns>
        //private bool CreateFile(string filePath, string content, ProcessData processData)
        //{
        //    try
        //    {
        //        string fileName = Path.GetFileName(filePath);
        //        string ext = Path.GetExtension(filePath);
        //        using (var fs = File.Open(filePath, FileMode.OpenOrCreate, FileAccess.Write))
        //        {
        //            byte[] info = new UTF8Encoding(true).GetBytes(content);
        //            fs.Write(info, 0, info.Length);
        //            fs.Close();
        //        }
        //        if (ext.Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        //            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "1.04", "Success - Created CSV File", "CSV File Created", processData.CsvFileName, processData.ScheduleID, processData.OrderNumber, null, "Success");
        //        else
        //            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CreateLocalCsvFile", "1.05", "Success - Created Xml File", "Xml File Created", processData.XmlFileName, processData.ScheduleID, processData.OrderNumber, null, "Success");
        //        return true;
        //    }
        //    catch
        //    {
        //        return false;
        //    }
        //}

        /////// <summary>
        /////// To Upload created xml or csv file to ftp 
        /////// </summary>
        /////// <param name="ftpServer">FTP server path</param>
        /////// <param name="filePath">File Path</param>
        /////// <param name="processData">Process data </param>
        /////// <returns>Status code</returns>
        ////private async Task<bool> UploadFileToFtp(string ftpServer, string filePath, ProcessData processData)
        ////{
        ////    bool result = false;
        ////    string fileName = Path.GetFileName(filePath);
        ////    string ext = Path.GetExtension(filePath);
        ////    try
        ////    {
        ////        FtpWebRequest ftpRequest = (FtpWebRequest)FtpWebRequest.Create(ftpServer + fileName);
        ////        ftpRequest.Credentials = new NetworkCredential(processData.FtpUserName, processData.FtpPassword);
        ////        ftpRequest.Method = WebRequestMethods.Ftp.UploadFile;
        ////        ftpRequest.UseBinary = true;
        ////        ftpRequest.Timeout = System.Threading.Timeout.Infinite;
        ////        byte[] buffer = new byte[8092];
        ////        using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
        ////        {
        ////            int read = 0;
        ////            using (Stream requestStream = await ftpRequest.GetRequestStreamAsync())
        ////            {
        ////                while ((read = fs.Read(buffer, 0, buffer.Length)) != 0)
        ////                {
        ////                    requestStream.Write(buffer, 0, read);
        ////                }
        ////                requestStream.Flush();
        ////            }
        ////            fs.Close();
        ////        }

        ////        if (ext.Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        ////        {
        ////            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFtp", "1.06", string.Format("Success - Uploaded CSV file: {0}", fileName), string.Format("Uploaded CSV file: {0} on ftp server successfully", fileName), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");
        ////            CheckFileExistsOnFtpServer(ftpRequest, filePath, processData);
        ////        }
        ////        else
        ////        {
        ////            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFtp", "1.07", string.Format("Success - Uploaded XML file: {0}", fileName), string.Format("Uploaded XML file: {0} on ftp server successfully", fileName), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");
        ////            CheckFileExistsOnFtpServer(ftpRequest, filePath, processData);
        ////        }
        ////        result = true;
        ////    }
        ////    catch (Exception ex)
        ////    {

        ////        if (Path.GetExtension(filePath).Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        ////            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFtp", "3.08", "Error - While CSV uploading file", string.Format("Error - While uploading CSV file: {0} with error {1}", fileName, ex.Message), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 10 - While uploading CSV file");
        ////        else
        ////            MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "UploadFileToFtp", "3.09", "Error - While XML uploading file", string.Format("Error - While uploading XML file: {0} with error {1}", fileName, ex.Message), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 10 - While uploading XML file");

        ////    }
        ////    return result;
        ////}

        ///// <summary>
        ///// To read data from created xml or csv file
        ///// </summary>
        ///// <param name="filePath">File Path</param>
        ///// <returns>Status code</returns>
        //private async Task<bool> TryToUploadFileOnFtp(string filePath, FtpWebRequest ftpRequest, byte[] fileContents)
        //{
        //    try
        //    {
        //        if (File.Exists(filePath))
        //        {
        //            using (Stream requestStream = await ftpRequest.GetRequestStreamAsync())
        //            {
        //                await requestStream.WriteAsync(fileContents, 0, fileContents.Length);
        //                requestStream.Flush();
        //                return true;
        //            }
        //        }
        //        return false;
        //    }
        //    catch
        //    {
        //        return false;
        //    }

        //}

        ///// <summary>
        ///// To check uploaded file is present on ftp server or not 
        ///// </summary>
        ///// <param name="ftpServer">FTP server path</param>
        ///// <param name="filePath">File Path</param>
        ///// <param name="processData">Process data</param>
        ///// <returns></returns>
        //private bool CheckFileExistsOnFtpServer(FtpWebRequest ftpRequest, string filePath, ProcessData processData)
        //{
        //    string fileName = Path.GetFileName(filePath);
        //    bool result = false;
        //    for (int i = 0; i < 10; i++)
        //    {
        //        if (CheckIfFileExistsOnServer(ftpRequest, processData))
        //        {
        //            DeleteLocalFile(processData, filePath);
        //            result = true;
        //            break;
        //        }
        //        if (i == 9)
        //            if (Path.GetExtension(filePath).Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CheckFileExistsOnFtpServer", "3.09", "Error - Uploaded CSV file missing on server", string.Format("Error - Uploaded CSV file {0} missing on server: {0}", fileName), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 11 - Uploaded CSV file missing on server");
        //            else
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "CheckFileExistsOnFtpServer", "3.10", "Error - Uploaded XML file missing on server", string.Format("Error - Uploaded XML file {0} missing on server: {0}", fileName), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 11 - Uploaded XML file missing on server");
        //    }
        //    return result;
        //}

        ///// <summary>
        ///// To check uploaded file is present on ftp server or not 
        ///// </summary>
        ///// <param name="ftpServer">FTP server path</param>
        ///// <param name="filePath">File Path</param>
        ///// <param name="user">Service user</param>
        ///// <returns></returns>
        //private bool CheckIfFileExistsOnServer(FtpWebRequest ftpRequest, ProcessData processData)
        //{
        //    try
        //    {
        //        using (FtpWebResponse response = (FtpWebResponse)ftpRequest.GetResponse())
        //            return true;
        //    }
        //    catch (WebException ex)
        //    {
        //        FtpWebResponse response = (FtpWebResponse)ex.Response;
        //        if (response.StatusCode == FtpStatusCode.ActionNotTakenFileUnavailable)
        //            return false;
        //    }
        //    return false;
        //}

        ///// <summary>
        ///// To Delete created files and try 5 times to delete
        ///// </summary>
        ///// <param name="processData">process data</param>
        ///// <param name="filePath">File Path</param>
        ///// <returns></returns>
        //private bool DeleteLocalFile(ProcessData processData, string filePath)
        //{
        //    string fileName = Path.GetFileName(filePath);
        //    bool result = false;

        //    for (int i = 0; i < 5; i++)
        //    {
        //        if (DeleteFile(filePath, processData))
        //        {

        //            result = true;
        //            break;
        //        }
        //        if (i == 4)
        //            if (Path.GetExtension(filePath).Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "DeleteLocalFile", "3.10", "Error - While Deleting CSV file", string.Format("Error - While CSV Deleting file {0}", fileName), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 10 - While CSV deleting file");
        //            else
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "DeleteLocalFile", "3.11", "Error - While Deleting XML file", string.Format("Error - While XML Deleting file {0}", fileName), fileName, processData.ScheduleID, processData.OrderNumber, processData.XmlDocument, "Error 10 - While XML deleting file");

        //    }
        //    return result;
        //}

        ///// <summary>
        ///// To Delete created file
        ///// </summary>
        ///// <param name="filePath">File Path</param>
        ///// <param name="processData">Process Data</param>
        ///// <returns></returns>
        //private bool DeleteFile(string filePath, ProcessData processData)
        //{
        //    bool result = false;
        //    try
        //    {
        //        if (File.Exists(filePath))
        //        {
        //            string fileName = Path.GetFileName(filePath);
        //            string ext = Path.GetExtension(filePath);
        //            File.Delete(filePath);
        //            result = true;
        //            if (ext.Equals(MeridianGlobalConstants.XCBL_FILE_EXTENSION, StringComparison.OrdinalIgnoreCase))
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "DeleteLocalFile", "1.08", string.Format("Success - Deleted CSV file {0} after ftp upload: {0}", fileName), string.Format("Deleted CSV file: {0}", fileName), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");
        //            else
        //                MeridianSystemLibrary.LogTransaction(processData.WebUserName, processData.FtpUserName, "DeleteLocalFile", "1.09", string.Format("Success - Deleted XML file {0} after ftp upload: {0}", fileName), string.Format("Deleted XML file: {0}", fileName), fileName, processData.ShippingSchedule.ScheduleID, processData.ShippingSchedule.OrderNumber, null, "Success");
        //        }
        //        result = true;
        //    }
        //    catch
        //    {
        //        result = false;
        //    }
        //    return result;
        //}

        #endregion

        /// <summary>
        /// This function will call the ProcessDocument Method internally and will make async result compelted
        /// </summary>
        /// <param name="state">current MeridianAsyncResult </param>
        /// <returns></returns>
        private void CompleteProcess(object state)
        {
            var meridianAsyncResult = state as MeridianAsyncResult;
            ProcessShippingSchedule objProcessShippingSchedule = new ProcessShippingSchedule();
            meridianAsyncResult.Result = objProcessShippingSchedule.ProcessDocument(meridianAsyncResult.CurrentOperationContext);
            meridianAsyncResult.Completed();
        }

        /// <summary>
        /// This function will call the ProcessRequisitionDocument Method internally and will make async result compelted
        /// </summary>
        /// <param name="state">current MeridianAsyncResult </param>
        /// <returns></returns>
        private void CompleteRequisitionProcess(object state)
        {
            var meridianAsyncResult = state as MeridianAsyncResult;
            ProcessRequisition objProcessRequisition = new ProcessRequisition();
            meridianAsyncResult.Result = objProcessRequisition.ProcessRequisitionDocument(meridianAsyncResult.CurrentOperationContext);
            meridianAsyncResult.Completed();
        }

        /// <summary>
        /// This function will call the ProcessShippingScheduleResponseRequest Method internally and will make async result compelted
        /// </summary>
        /// <param name="state">current MeridianAsyncResult </param>
        /// <returns></returns>
        private void CompleteShippingScheduleResponseProcess(object state)
        {
            var meridianAsyncResult = state as MeridianAsyncResult;
            ProcessShippingScheduleResponse objProcess = new ProcessShippingScheduleResponse();
            meridianAsyncResult.Result = objProcess.ProcessShippingScheduleResponseRequest(meridianAsyncResult.CurrentOperationContext);
            meridianAsyncResult.Completed();
        }

        /// <summary>
        /// To upload file to FTP from MeridianResult.
        /// </summary>
        private async Task<bool> SendFileToFTP(MeridianResult meridianResult)
        {
            if ((meridianResult != null) && !string.IsNullOrWhiteSpace(meridianResult.FileName))
            {
                try
                {
                    FtpWebRequest ftpRequest = (FtpWebRequest)FtpWebRequest.Create(meridianResult.FtpServerUrl + meridianResult.FileName);
                    ftpRequest.Credentials = new NetworkCredential(meridianResult.FtpUserName, meridianResult.FtpPassword);
                    ftpRequest.Method = WebRequestMethods.Ftp.UploadFile;
                    ftpRequest.UseBinary = true;
                    ftpRequest.KeepAlive = false;
                    ftpRequest.Timeout = Timeout.Infinite;
                    using (Stream requestStream = await ftpRequest.GetRequestStreamAsync())
                    {
                        requestStream.Write(meridianResult.Content, 0, meridianResult.Content.Length);
                        requestStream.Flush();
                    }
                    using (FtpWebResponse response = (FtpWebResponse)ftpRequest.GetResponse())
                        if (response.StatusCode == FtpStatusCode.ClosingData)
                        {
                            MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, (MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX + "- Successfully completed request"), "01.06", string.Format("{0} - Successfully completed request for {1}", MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, meridianResult.UniqueID), string.Format("Uploaded CSV file: {0} on ftp server successfully for {1}", meridianResult.FileName, meridianResult.UniqueID), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Success");
                            return true;
                        }
                        else
                        {
                            MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "UploadFileToFtp", "03.08", "Error - While CSV uploading file", string.Format("Error - While uploading CSV file: {0} with error", meridianResult.FileName), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 10 - While uploading CSV file");
                            return false;
                        }
                }
                catch (Exception ex)
                {
                    MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "UploadFileToFtp", "03.08", "Error - While CSV uploading file", string.Format("Error - While uploading CSV file: {0} with error {1}", meridianResult.FileName, ex.Message), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 10 - While uploading CSV file");
                    return false;
                }
            }
            return false;
        }

        #region Async Method implementation

        /// <summary>
        /// To get transportion data
        /// </summary>
        /// <param name="callback"> delegate that references a method that is called when the asynchronous operation completes </param>
        /// <param name="asyncState">user-defined object can be used to pass application-specific state information to the method invoked when the asynchronous operation completes </param>
        public IAsyncResult BeginShipmentOrder(AsyncCallback callback, object asyncState)
        {
            var meridianAsyncResult = new MeridianAsyncResult(OperationContext.Current, callback, asyncState);
            ThreadPool.QueueUserWorkItem(CompleteProcess, meridianAsyncResult);
            return meridianAsyncResult;
        }

        /// <summary>
        /// To return processed data i.e. XElement
        /// </summary>
        /// <param name="asyncResult"> object of IAsyncResult which will hold the result of current processing</param>
        public XElement EndShipmentOrder(IAsyncResult asyncResult)
        {
            var meridianAsyncResult = asyncResult as MeridianAsyncResult;
            meridianAsyncResult.AsyncWait.WaitOne();
            var uploadResult = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult();
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = uploadResult ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(meridianAsyncResult.Result.Status, meridianAsyncResult.Result.UniqueID, meridianAsyncResult.Result.IsSchedule));
        }

        /// <summary>
        /// To get transportion data
        /// </summary>
        /// <param name="callback"> delegate that references a method that is called when the asynchronous operation completes </param>
        /// <param name="asyncState">user-defined object can be used to pass application-specific state information to the method invoked when the asynchronous operation completes </param>
        public IAsyncResult BeginRequisition(AsyncCallback callback, object asyncState)
        {
            var meridianAsyncResult = new MeridianAsyncResult(OperationContext.Current, callback, asyncState);
            ThreadPool.QueueUserWorkItem(CompleteRequisitionProcess, meridianAsyncResult);
            return meridianAsyncResult;
        }

        /// <summary>
        /// To return processed data i.e. XElement
        /// </summary>
        /// <param name="asyncResult"> object of IAsyncResult which will hold the result of current processing</param>
        public XElement EndRequisition(IAsyncResult asyncResult)
        {
            var meridianAsyncResult = asyncResult as MeridianAsyncResult;
            meridianAsyncResult.AsyncWait.WaitOne();
            var uploadResult = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult();
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = uploadResult ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(meridianAsyncResult.Result.Status, meridianAsyncResult.Result.UniqueID, meridianAsyncResult.Result.IsSchedule));
        }

        /// <summary>
        /// To get transportion data
        /// </summary>
        /// <param name="callback"> delegate that references a method that is called when the asynchronous operation completes </param>
        /// <param name="asyncState">user-defined object can be used to pass application-specific state information to the method invoked when the asynchronous operation completes </param>
        public IAsyncResult BeginShippingScheduleResponse(AsyncCallback callback, object asyncState)
        {
            var meridianAsyncResult = new MeridianAsyncResult(OperationContext.Current, callback, asyncState);
            ThreadPool.QueueUserWorkItem(CompleteShippingScheduleResponseProcess, meridianAsyncResult);
            return meridianAsyncResult;
        }

        /// <summary>
        /// To return processed data i.e. XElement
        /// </summary>
        /// <param name="asyncResult"> object of IAsyncResult which will hold the result of current processing</param>
        public XElement EndShippingScheduleResponse(IAsyncResult asyncResult)
        {
            var meridianAsyncResult = asyncResult as MeridianAsyncResult;
            meridianAsyncResult.AsyncWait.WaitOne();
            var uploadResult = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult();
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = uploadResult ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(meridianAsyncResult.Result.Status, meridianAsyncResult.Result.UniqueID, meridianAsyncResult.Result.IsSchedule));
        }

        #endregion Async Method implementation
    }

}
