#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kamal
//Date Programmed:                              12/11/2020
//Program Name:                                 UserGuideUploadController
//Purpose:                                      Contains Actions to render view on Administration's User Guide Upload page
//====================================================================================================================================================*/

using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class UserGuideUploadController : BaseController<UserGuidUploadView>
    {
        private readonly IUserGuideUploadCommands _userGuideUploadCommands;
        public static IUserGuideUploadCommands _userGuideUploadStaticCommands;
        public static ICommonCommands _commonStaticCommands;
        /// <summary>
        /// UserGuideUploadController
        /// </summary>
        /// <param name="userGuideUploadCommands"></param>
        /// <param name="commonCommands"></param>
        public UserGuideUploadController(IUserGuideUploadCommands userGuideUploadCommands, ICommonCommands commonCommands) : base(userGuideUploadCommands)
        {
            _commonCommands = commonCommands;
            _userGuideUploadCommands = userGuideUploadCommands;
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            if (SessionProvider.ViewPagedDataSession.Count() > 0
            && SessionProvider.ViewPagedDataSession.ContainsKey(route.Entity)
            && SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo != null)
            {
                SessionProvider.ViewPagedDataSession[route.Entity].PagedDataInfo.IsDataView = false;
            }

            if (_formResult.Record is SysRefModel)
            {
                (_formResult.Record as SysRefModel).ArbRecordId = (_formResult.Record as SysRefModel).Id == 0
                    ? new Random().Next(-1000, 0) :
                    (_formResult.Record as SysRefModel).Id;
            }

            _formResult.IsPopUp = true;

            _userGuideUploadStaticCommands = _userGuideUploadCommands;
            _commonStaticCommands = _commonCommands;
            _formResult.Record = new UserGuidUploadView();
            _formResult.Record.Id = route.RecordId;
            return PartialView(_formResult);
        }
        [HttpPost]
        public ActionResult ImportUserGuide([ModelBinder(typeof(DragAndDropSupportDemoBinder))] IEnumerable<UploadedFile> ucDragAndDropGateway, long ParentId = 0)
        {
            return null;
        }

        public class DragAndDropSupportDemoBinder : DevExpressEditorsBinder
        {
            public DragAndDropSupportDemoBinder()
            {
                UploadControlBinderSettings.FileUploadCompleteHandler = ucDragAndDrop_FileUploadComplete;
            }
        }
        public static void ucDragAndDrop_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            var displayMessage = _commonStaticCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.UserGuidePDFDocument);
            if (e.UploadedFile != null && e.UploadedFile.IsValid && e.UploadedFile.FileBytes != null)
            {
                UserGuidUploadView userGuidUploadView = new UserGuidUploadView();
                var isFileUploaded = false;
                Stream fs = e.UploadedFile.FileContent;
                BinaryReader br = new BinaryReader(fs);
                userGuidUploadView.FileContent = br.ReadBytes((Int32)fs.Length);
                userGuidUploadView.DocumentName = e.UploadedFile.FileName;
                isFileUploaded = _userGuideUploadStaticCommands.UploadUserGuide(userGuidUploadView);
                if (isFileUploaded)
                {
                    string url = System.Web.HttpContext.Current.Request.Url.Authority;                    
                    userGuidUploadView.Url = "https://" + url + ".com";
                    bool result = _userGuideUploadStaticCommands.GenerateKnowledgeDetail(userGuidUploadView);
                    if (!result)
                        displayMessage.Description = "Due to internal server issue file is not uploaded successfully";
                }
                else
                    displayMessage.Description = "Due to internal server issue file is not uploaded successfully";
            }
            else
                displayMessage.Description = "Please select a PDF file for upload.";

            e.CallbackData = JsonConvert.SerializeObject(displayMessage);
        }
    }
}