/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 FormResult
//Purpose:                                      Represents description for Form results of the system
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    public class FormResult<TView> : ViewResult
    {
        private string _formId;

        public string FormId
        {
            get
            {
                if (string.IsNullOrEmpty(_formId))
                    return CallBackRoute.Controller + "Form";//This formName dependent on _NavigationPanePartial's 'SaveRecordPopup' ItemClick Method.
                return _formId;
            }
            set { _formId = value; }
        }

        private string _submitClick;

        private string _cancelClick;

        public string SubmitClick
        {
            get
            {
                if (string.IsNullOrEmpty(_submitClick))
                    return string.Format(JsConstants.FormSubmitClick, FormId, ControlNameSuffix, Newtonsoft.Json.JsonConvert.SerializeObject(CallBackRoute));
                return _submitClick;
            }
            set { _submitClick = value; }
        }

        public string CancelClick
        {
            get
            {
                if (string.IsNullOrEmpty(_cancelClick))
                {
                    var cancelRoute = new MvcRoute(CallBackRoute, MvcConstants.ActionDataView);
                    if (cancelRoute.Entity == EntitiesAlias.OrgRefRole && !cancelRoute.IsPopup)
                        cancelRoute.OwnerCbPanel = WebApplicationConstants.AppCbPanel;
                    cancelRoute.Url = string.Empty;
                    if (cancelRoute.IsJobCardEntity)
                        cancelRoute.Entity = EntitiesAlias.JobCard;
                    return string.Format(JsConstants.FormCancelClick, FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
                }

                return _cancelClick;
            }
            set { _cancelClick = value; }
        }

        public TView Record { get; set; }

        public long MaxID { get; set; }
        public long MinID { get; set; }

        public IList<FormNavMenu> NavigationPane
        {
            get
            {
                if (Record != null && Record is Entities.Administration.SystemReference)
                {
                    var recordId = Record == null ? 0 : (Record as Entities.Administration.SystemReference).Id;
                    var route = new MvcRoute(CallBackRoute, MvcConstants.ActionPrevNext, recordId);
                    route.IsPopup = IsPopUp;                  
                    return route.GetFormNavMenus(Icon, Permission, ControlNameSuffix, Operations[OperationTypeEnum.New], Operations[OperationTypeEnum.Edit], SessionProvider);
                }
                else
                {
                    var recordId = Record == null ? 0 : (Record as SysRefModel).Id;
                    var route = new MvcRoute(CallBackRoute, MvcConstants.ActionPrevNext, recordId);
                    route.ParentRecordId = Record == null ? 0 : (Record as SysRefModel).ParentId;
                    route.IsPopup = IsPopUp;
                    return route.GetFormNavMenus(Icon, Permission, ControlNameSuffix, Operations[OperationTypeEnum.New], Operations[OperationTypeEnum.Edit], SessionProvider);
                }
            }
        }

    }
}