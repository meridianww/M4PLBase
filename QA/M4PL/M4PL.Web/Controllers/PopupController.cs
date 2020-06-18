/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Popup Controller
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Popup
//Purpose:                                      Contains Actions to handle and maintain generic data required for a popup
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Utilities;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;

namespace M4PL.Web.Controllers
{
    public class PopupController : MvcBaseController
    {
        public PopupController(ICommonCommands commonCommands)
        {
            _commonCommands = commonCommands;
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (SessionProvider == null || SessionProvider.ActiveUser == null)
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "controller", "Account" }, { "action", MvcConstants.ActionIndex }, { "area", string.Empty } });
            else
            {
                if (!filterContext.ActionDescriptor.ActionName.Equals("GetLastCallDateTime"))
                    SessionProvider.ActiveUser.LastAccessDateTime = DateTime.Now;

                _commonCommands.ActiveUser = SessionProvider.ActiveUser;
            }
            base.OnActionExecuting(filterContext);
        }

        public PartialViewResult RecordPopupControl(string strRoute)
        {
            MvcRoute route = null;
            if (!string.IsNullOrWhiteSpace(strRoute))
                route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if ((route != null) && (_commonCommands.Tables.ContainsKey(route.Entity)))
            {
                var tableRef = _commonCommands.Tables[route.Entity];
                ViewData[WebApplicationConstants.EntityImage] = tableRef.TblIcon.ConvertByteToString();
            }
            if (Request.Params[WebApplicationConstants.StrDropdownViewModel] != null)
                ViewData[WebApplicationConstants.StrDropdownViewModel] = Convert.ToString(Request.Params[WebApplicationConstants.StrDropdownViewModel]);
            else
                ViewData[WebApplicationConstants.StrDropdownViewModel] = null;

            return PartialView(MvcConstants.ViewRecordPopupControl, route);
        }

        public PartialViewResult RecordSubPopupControl(string strRoute, string strByteArray = "")
        {
            MvcRoute route = null;
            if (!string.IsNullOrWhiteSpace(strRoute))
                route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            if ((route != null) && (_commonCommands.Tables.ContainsKey(route.Entity)))
            {
                var tableRef = _commonCommands.Tables[route.Entity];
                ViewData[WebApplicationConstants.EntityImage] = tableRef.TblIcon.ConvertByteToString();
            }
            if (route != null && !string.IsNullOrWhiteSpace(strByteArray))
                ViewData[WebApplicationConstants.ByteArray] = JsonConvert.DeserializeObject<ByteArray>(strByteArray);

            if (Request.Params[WebApplicationConstants.StrDropdownViewModel] != null)
                ViewData[WebApplicationConstants.StrDropdownViewModel] = Convert.ToString(Request.Params[WebApplicationConstants.StrDropdownViewModel]);
            else
                ViewData[WebApplicationConstants.StrDropdownViewModel] = null;

            return PartialView(MvcConstants.ViewRecordSubPopupControl, route);
        }

        public PartialViewResult DisplayMessageControl(string strDisplayMessage)
        {
            DisplayMessage displayMessage = null;
            if (!string.IsNullOrWhiteSpace(strDisplayMessage))
                displayMessage = JsonConvert.DeserializeObject<DisplayMessage>(strDisplayMessage);
            if (displayMessage != null)
            {

                if (!string.IsNullOrWhiteSpace(displayMessage.MessageType) && displayMessage.MessageType.ToEnum<MessageTypeEnum>() > 0)
                {
                    var disMessage = _commonCommands.GetDisplayMessageByCode(displayMessage.MessageType.ToEnum<MessageTypeEnum>(), displayMessage.Code);
                    if (displayMessage.HeaderIcon == null)
                        displayMessage.HeaderIcon = disMessage.HeaderIcon;
                    if (displayMessage.MessageTypeIcon == null)
                        displayMessage.MessageTypeIcon = disMessage.MessageTypeIcon;

                    ViewData[WebApplicationConstants.EntityImage] = disMessage.MessageTypeIcon.ConvertByteToString();
                }

                if (displayMessage.Operations.Count == 1)
                {
                    var OkOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Ok.ToString()));
                    if (OkOperation != null && string.IsNullOrEmpty(OkOperation.ClickEvent))
                        OkOperation.ClickEvent = JsConstants.CloseDisplayMessage;
                }

                if (displayMessage.Code.Equals(DbConstants.WarningTimeOut))
                {
                    displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.WarningTimeOut);
                    displayMessage.Description += "<div class=\'time-remaining\'>Time remaining <span id=\"CountDownHolder\"></span></div>";
                    ViewData[WebApplicationConstants.EntityImage] = displayMessage.MessageTypeIcon.ConvertByteToString();
                }

                if (displayMessage.Code.Equals(DbConstants.NoAccess))
                    displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.NoAccess);

				if (displayMessage.Code.Equals(DbConstants.JobDocumentReport))
					displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.JobDocumentReport);

				if (displayMessage.Code.Equals(DbConstants.JobDocumentPresent))
                    displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.JobDocumentPresent);

                if (displayMessage.Code.Equals(DbConstants.JobPODUploaded))
                    displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.JobPODUploaded);

				if (displayMessage.Code.Equals(DbConstants.JobPriceCodeMissing))
					displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.JobPriceCodeMissing);

				if (displayMessage.Code.Equals(DbConstants.JobCostCodeMissing))
					displayMessage = GetDisplayMessage(MessageTypeEnum.Warning, DbConstants.JobCostCodeMissing);


				if (displayMessage.Code.Equals(DbConstants.WarningIgnoreChanges))
                {
                    displayMessage = new DisplayMessage(_commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.WarningIgnoreChanges));

                    var saveOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Save.ToString()));
                    saveOperation.ClickEvent = string.Format("function(s, e) {{ {0}; }}", JsConstants.SaveChangesOnConfirmClick);

                    var doNotSaveOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.DoNotSave.ToString()));
                    doNotSaveOperation.ClickEvent = string.Format("function(s, e) {{ {0}; }}", JsConstants.IgnoreChangesClick);

                    var cancelOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Cancel.ToString()));
                    cancelOperation.ClickEvent = JsConstants.CloseConfirmationMessage;

                    ViewData[WebApplicationConstants.EntityImage] = displayMessage.MessageTypeIcon.ConvertByteToString();
                }

            }
            return PartialView(MvcConstants.ViewDisplayPopupControl, displayMessage);
        }

        private DisplayMessage GetDisplayMessage(MessageTypeEnum messageTypeEnum, string dbConstants)
        {
            var displayMessage = new DisplayMessage(_commonCommands.GetDisplayMessageByCode(messageTypeEnum, dbConstants));
            var OkOperation = displayMessage.Operations.FirstOrDefault(x => x.SysRefName.Equals(MessageOperationTypeEnum.Ok.ToString()));
            if (messageTypeEnum == MessageTypeEnum.Warning && dbConstants == DbConstants.WarningTimeOut)
                OkOperation.ClickEvent = string.Format("function(s, e) {{ {0}; {1}; }}", JsConstants.UpdateSessionTimeClick, JsConstants.UpdateSessionTimeClick);
            else
                OkOperation.ClickEvent = "function(s, e){ DisplayMessageControl.Hide(); }";
            return displayMessage;
        }
    }
}