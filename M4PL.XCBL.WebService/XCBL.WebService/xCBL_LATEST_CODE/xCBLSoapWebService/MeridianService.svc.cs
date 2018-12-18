﻿//Copyright (2018) Meridian Worldwide Transportation Group
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
using System.Text;
using System.Threading.Tasks;
using System.Timers;
using System.Xml.Linq;
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
        /// Global timer
        /// </summary>
        private static System.Timers.Timer _pbsFtpTimer = new System.Timers.Timer(MeridianGlobalConstants.TIMER_INTERVAL);

        /// <summary>
        /// First time configure method for Service
        /// </summary>
        /// <param name="config">service configuration to load</param>
        public static void Configure(ServiceConfiguration config)
        {
            string webConfigPath = string.Format("{0}web.config", HostingEnvironment.ApplicationPhysicalPath);
            config.LoadFromConfiguration(ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = webConfigPath }, ConfigurationUserLevel.None));
            _pbsFtpTimer.AutoReset = true;
            _pbsFtpTimer.Enabled = false;
            _pbsFtpTimer.Elapsed += new ElapsedEventHandler(CheckPBSFTPFolder);
            _pbsFtpTimer.Start();
        }

        /// <summary>
        /// To Check the PBS FTP folder and if any file available then Process it and send Shipping Schedule Response Request to AWC.
        /// </summary>
        /// <param name="sender">timer</param>
        /// <param name="e">elasped event args</param>
        private static void CheckPBSFTPFolder(object sender, ElapsedEventArgs e)
        {
            _pbsFtpTimer.Stop();
            try
            {
                var currentUser = MeridianSystemLibrary.sysGetAuthenticationByUsernameAndPassword(MeridianGlobalConstants.CONFIG_USER_NAME, MeridianGlobalConstants.CONFIG_PASSWORD);
                if (currentUser != null)
                {
                    WebRequest request = WebRequest.Create(currentUser.FtpServerOutFolderPath);
                    request.Method = WebRequestMethods.Ftp.ListDirectory;
                    request.Credentials = new NetworkCredential(currentUser.FtpUsername, currentUser.FtpPassword);
                    using (var response = (FtpWebResponse)request.GetResponse())
                    {
                        StreamReader streamReader = new StreamReader(response.GetResponseStream());

                        List<string> directories = new List<string>();

                        string line = streamReader.ReadLine();

                        while (!string.IsNullOrEmpty(line))
                        {
                            directories.Add(line);
                            line = streamReader.ReadLine();
                        }
                        streamReader.Close();

                        using (WebClient ftpClient = new WebClient())
                        {
                            ftpClient.Credentials = new NetworkCredential(currentUser.FtpUsername, currentUser.FtpPassword);
                            for (int i = 0; i <= (directories.Count - 1); i++)
                            {
                                if (directories[i].Contains("."))
                                {
                                    var currentFileName = directories[i].ToString();
                                    string path = currentUser.FtpServerOutFolderPath + currentFileName;
                                    byte[] currentFileData = ftpClient.DownloadData(path);
                                    var shouldDeleteCurrentFile = CommonProcess.SendShippingScheduleResponseRequestFromPBSFTP(currentUser, currentFileName, currentFileData);

                                    if (shouldDeleteCurrentFile)
                                    {
                                        /*After process completion delete the file so that will not process that particular file*/
                                        FtpWebRequest ftpRequest = (FtpWebRequest)FtpWebRequest.Create(path);
                                        ftpRequest.Credentials = new NetworkCredential(currentUser.FtpUsername, currentUser.FtpPassword);
                                        ftpRequest.Method = WebRequestMethods.Ftp.DeleteFile;
                                        ftpRequest.UseBinary = true;
                                        ftpRequest.KeepAlive = false;
                                        ftpRequest.Timeout = Timeout.Infinite;
                                        FtpWebResponse ftpResponse = (FtpWebResponse)ftpRequest.GetResponse();
                                        ftpResponse.Close();
                                        ftpRequest = null;
                                    }
                                }
                            }
                            _pbsFtpTimer.Start();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MeridianSystemLibrary.LogTransaction(MeridianGlobalConstants.CONFIG_USER_NAME, string.Empty, "CheckPBSFTPFolder", "06.04", "Error - While checing FTP folder - Inside CATCH block", string.Format("Error - While checing FTP folder: {0} with error - Inside Catch Block - ", ex.Message), string.Empty, string.Empty, string.Empty, null, "Error 06.04 - While checing FTP folder");
                _pbsFtpTimer.Start();
            }
        }

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
                    FtpWebRequest ftpRequest = (FtpWebRequest)FtpWebRequest.Create(meridianResult.FtpServerInFolderPath + meridianResult.FileName);
                    ftpRequest.Credentials = new NetworkCredential(meridianResult.FtpUserName, meridianResult.FtpPassword);
                    ftpRequest.Method = WebRequestMethods.Ftp.UploadFile;
                    ftpRequest.UseBinary = true;
                    ftpRequest.KeepAlive = false;
                    ftpRequest.Timeout = Timeout.Infinite;

                    if (meridianResult.UploadFromLocalPath)
                    {
                        using (StreamReader sourceStream = new StreamReader(meridianResult.LocalFilePath + meridianResult.FileName))
                            meridianResult.Content = Encoding.UTF8.GetBytes(sourceStream.ReadToEnd());
                    }

                    using (Stream requestStream = await ftpRequest.GetRequestStreamAsync())
                    {
                        requestStream.Write(meridianResult.Content, 0, meridianResult.Content.Length);
                        requestStream.Flush();
                    }
                    using (FtpWebResponse response = (FtpWebResponse)ftpRequest.GetResponse())
                        if (response.StatusCode == FtpStatusCode.ClosingData)
                        {
                            MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, (MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX + "- Successfully completed request"), "01.06", string.Format("{0} - Successfully completed request for {1}", MeridianGlobalConstants.XCBL_AWC_FILE_PREFIX, meridianResult.UniqueID), string.Format("Uploaded CSV file: {0} on ftp server successfully for {1}", meridianResult.FileName, meridianResult.UniqueID), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Success");
                            if (meridianResult.IsSchedule)
                                CommonProcess.SendShippingScheduleResponse(meridianResult);
                            return true;
                        }
                        else
                        {
                            MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "UploadFileToFtp", "03.08", "Error - While CSV uploading file - Inside TRY block", string.Format("Error - While uploading CSV file: {0} with error - Inside TRY block - ", meridianResult.FileName), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 08 - While uploading CSV file");
                            return false;
                        }
                }
                catch (Exception ex)
                {
                    MeridianSystemLibrary.LogTransaction(meridianResult.WebUserName, meridianResult.FtpUserName, "UploadFileToFtp", "03.08", "Error - While CSV uploading file - Inside CATCH block", string.Format("Error - While uploading CSV file: {0} with error {1} - Inside CATCH block - ", meridianResult.FileName, ex.Message), meridianResult.FileName, meridianResult.UniqueID, meridianResult.OrderNumber, null, "Error 08 - While uploading CSV file");
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
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult() ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
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
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult() ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
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
            if (!meridianAsyncResult.Result.Status.Equals(MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE, StringComparison.OrdinalIgnoreCase))
                meridianAsyncResult.Result.Status = SendFileToFTP(meridianAsyncResult.Result).GetAwaiter().GetResult() ? MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_SUCCESS : MeridianGlobalConstants.MESSAGE_ACKNOWLEDGEMENT_FAILURE;
            return XElement.Parse(MeridianSystemLibrary.GetMeridian_Status(meridianAsyncResult.Result.Status, meridianAsyncResult.Result.UniqueID, meridianAsyncResult.Result.IsSchedule));
        }

        #endregion Async Method implementation
    }

}
