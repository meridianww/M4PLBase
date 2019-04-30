﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramBillableRate
//Purpose:                                      Contains Actions to render view on Program's Act role page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Program;
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Program.Controllers
{
    public class PrgBillableRateController : BaseController<ProgramBillableRateView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program billable rate details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="ProgramBillableRateCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgBillableRateController(IPrgBillableRateCommands ProgramBillableRateCommands, ICommonCommands commonCommands)
            : base(ProgramBillableRateCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(ProgramBillableRateView programBillableRateView)
        {
            programBillableRateView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(programBillableRateView, Request.Params[WebApplicationConstants.UserDateTime]);
            programBillableRateView.PbrPrgrmID = programBillableRateView.ParentId;
            var descriptionByteArray = programBillableRateView.Id.GetVarbinaryByteArray(EntitiesAlias.PrgBillableRate, ByteArrayFields.PbrDescription.ToString());

            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };
            var messages = ValidateMessages(programBillableRateView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = programBillableRateView.Id > 0 ? base.UpdateForm(programBillableRateView) : base.SaveForm(programBillableRateView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(programBillableRateView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(programBillableRateView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ProgramBillableRateView, long> programBillableRateView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            programBillableRateView.Insert.ForEach(c => { c.PbrPrgrmID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            programBillableRateView.Update.ForEach(c => { c.PbrPrgrmID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(programBillableRateView, route, gridName);
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

        public ActionResult RichEditDescription(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PbrDescription.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}