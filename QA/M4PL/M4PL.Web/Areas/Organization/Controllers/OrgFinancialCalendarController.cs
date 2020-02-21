/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationFinancialCalendar
//Purpose:                                      Contains Actions to render view on Organization's Financial Calender page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Organization;
using M4PL.APIClient.ViewModels.Organization;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Organization.Controllers
{
    public class OrgFinancialCalendarController : BaseController<OrgFinancialCalendarView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Organization's financial calender details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="orgFinancialCalenderCommands"></param>
        /// <param name="commonCommands"></param>
        public OrgFinancialCalendarController(IOrgFinancialCalendarCommands orgFinancialCalenderCommands, ICommonCommands commonCommands)
            : base(orgFinancialCalenderCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(OrgFinancialCalendarView orgFinancialCalendarView)
        {
            orgFinancialCalendarView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(orgFinancialCalendarView, Request.Params[WebApplicationConstants.UserDateTime]);
            orgFinancialCalendarView.OrgID = orgFinancialCalendarView.ParentId;
            orgFinancialCalendarView.OrganizationId = orgFinancialCalendarView.ParentId;
            var messages = ValidateMessages(orgFinancialCalendarView);
            var descriptionByteArray = orgFinancialCalendarView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.OrgFinancialCalendar, ByteArrayFields.FclDescription.ToString());
            var byteArray = new List<ByteArray> { descriptionByteArray };
            if (messages.Any())
                return Json(new { status = false, errMessages = messages, byteArray = byteArray }, JsonRequestBehavior.AllowGet);

            var record = orgFinancialCalendarView.Id > 0 ? base.UpdateForm(orgFinancialCalendarView) : base.SaveForm(orgFinancialCalendarView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);

            if (record is SysRefModel)
            {
                route.RecordId = record.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                return SuccessMessageForInsertOrUpdate(orgFinancialCalendarView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(orgFinancialCalendarView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<OrgFinancialCalendarView, long> orgFinancialCalendarView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            orgFinancialCalendarView.Insert.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            orgFinancialCalendarView.Update.ForEach(c => { c.OrgID = route.ParentRecordId; c.OrganizationId = route.ParentRecordId; });
            var batchError = BatchUpdate(orgFinancialCalendarView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        #region RichEdit

		public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
		{
			long newDocumentId;
			var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
			var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.FclDescription.ToString());
			if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
			{
				byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.FclDescription.ToString());
			}
			if (route.RecordId > 0)
				byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
			return base.RichEditFormView(byteArray);
		}

		#endregion RichEdit
	}
}