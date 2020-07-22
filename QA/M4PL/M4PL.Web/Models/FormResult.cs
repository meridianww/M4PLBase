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
//Programmer:                                   Kirty Anurag
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
				{
					if (SessionProvider.ViewPagedDataSession.ContainsKey(CallBackRoute.Entity) &&
						SessionProvider.ViewPagedDataSession[CallBackRoute.Entity].PagedDataInfo.IsJobCardEntity)
						return "JobForm";
					else
						return CallBackRoute.Controller + "Form"; //This formName dependent on _NavigationPanePartial's 'SaveRecordPopup' ItemClick Method.
				}
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
					if (SessionProvider.ViewPagedDataSession.ContainsKey(cancelRoute.Entity)
						&& SessionProvider.ViewPagedDataSession[cancelRoute.Entity].PagedDataInfo.IsJobCardEntity)
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