#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using DevExpress.Web;
using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using M4PL.Web.Providers;
using Microsoft.Ajax.Utilities;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavRateController : BaseController<NavRateView>
    {
        public INavRateCommands _navRateCommands;

        public static INavRateCommands _navRateStaticCommand;

        public static ICommonCommands _commonStaticCommands;
        public static long _ProgramId = 0;
        public static string _ImportType = string.Empty;

        /// <summary>
        /// Interacts with the interfaces to get the Nav Customer details and renders to the page
        /// </summary>
        /// <param name="navRateCommands">navCustomerCommands</param>
        /// <param name="commonCommands"></param>
        public NavRateController(INavRateCommands navRateCommands, ICommonCommands commonCommands)
                : base(navRateCommands)
        {
            _commonCommands = commonCommands;
            _navRateCommands = navRateCommands;
        }

        public override ActionResult FormView(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            ////_formResult.Record = route.RecordId > 0 ? _currentEntityCommands.Get(route.RecordId) : new NavRateView();

            //_formResult.SetupFormResult(_commonCommands, route);
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
            //_formResult.CallBackRoute = SessionProvider.ActiveUser.LastRoute;
            _formResult.IsPopUp = true;

            _navRateStaticCommand = _navRateCommands;
            _commonStaticCommands = _commonCommands;
            _formResult.Record = new NavRateView();
            _formResult.Record.Id = route.RecordId;
            _ProgramId = route.RecordId;
            _formResult.CallBackRoute = route;
            if (route.Location != null && route.Location.Count == 1)
            {
                _ImportType = route.Location[0];
            }
            return PartialView(_formResult);
        }

        public ActionResult ImportOrder(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            _formResult.SessionProvider = SessionProvider;
            ////_formResult.Record = new JobView();

            _formResult.IsPopUp = true;
            _formResult.SetupFormResult(_commonCommands, route);
            return PartialView("ImportOrder", _formResult);
        }

        [HttpPost]
        public ActionResult ImportOrderPost([ModelBinder(typeof(DragAndDropSupportDemoBinder))] IEnumerable<UploadedFile> ucDragAndDrop, long ParentId = 0)
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
            string test = _ImportType;
            var displayMessage = _commonStaticCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCostCode);
            if (e.UploadedFile != null && e.UploadedFile.IsValid && e.UploadedFile.FileBytes != null)
            {
                byte[] uploadedFileData = e.UploadedFile.FileBytes;

                switch (_ImportType)
                {
                    case "Price/Cost Code":
                        string navRateUploadColumns = ConfigurationManager.AppSettings["NavRateUploadColumns"];
                        displayMessage = WebExtension.ImportCSVToProgram(displayMessage, uploadedFileData,
                            _ImportType, navRateUploadColumns,
                            _ProgramId, _navRateStaticCommand, _commonStaticCommands);
                        break;

                    case "Reason Code":
                        string reasonCodeUploadColumns = ConfigurationManager.AppSettings["ReasonCodeUploadColumns"];
                        displayMessage = WebExtension.ImportCSVToProgram(displayMessage, uploadedFileData,
                           _ImportType, reasonCodeUploadColumns,
                           _ProgramId, _navRateStaticCommand, _commonStaticCommands);
                        break;

                    case "Appointment Code":
                        string appointmentCodeUploadColumns = ConfigurationManager.AppSettings["AppointmentCodeUploadColumns"];
                        displayMessage = WebExtension.ImportCSVToProgram(displayMessage, uploadedFileData,
                           _ImportType, appointmentCodeUploadColumns,
                           _ProgramId, _navRateStaticCommand, _commonStaticCommands);
                        break;

                    case "Vendor":
                        //to do
                        break;
                }
            }
            else
                displayMessage.Description = "Please select a CSV file for upload.";

            e.CallbackData = JsonConvert.SerializeObject(displayMessage);
        }


    }
}