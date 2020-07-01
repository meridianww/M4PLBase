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
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramMvoc
//Purpose:                                      Contains Actions to render view on Program's Mvoc page
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
    public class PrgMvocController : BaseController<PrgMvocView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's mvoc details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="prgMVOCCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgMvocController(IPrgMvocCommands prgMVOCCommands, ICommonCommands commonCommands)
            : base(prgMVOCCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(PrgMvocView prgMvocView)
        {
            prgMvocView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgMvocView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgMvocView.VocProgramID = prgMvocView.ParentId;
            if (prgMvocView.VocOrgID == 0)
                prgMvocView.VocOrgID = SessionProvider.ActiveUser.OrganizationId;
            var descriptionByteArray = prgMvocView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgMvoc, ByteArrayFields.VocDescription.ToString());

            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(prgMvocView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgMvocView.Id > 0 ? base.UpdateForm(prgMvocView) : base.SaveForm(prgMvocView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(prgMvocView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(prgMvocView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgMvocView, long> prgMvocView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgMvocView.Insert.ForEach(c => { c.VocProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgMvocView.Update.ForEach(c => { c.VocProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgMvocView, route, gridName);
            if (!batchError.Any(b => b.Key == -100))//100 represent model state so no need to show message
            {
                var displayMessage = batchError.Count == 0 ? _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Success, DbConstants.UpdateSuccess) : _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Error, DbConstants.UpdateError);

                displayMessage.Operations.ToList().ForEach(op => op.SetupOperationRoute(route));
                ViewData[WebApplicationConstants.GridBatchEditDisplayMessage] = displayMessage;
            }
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.ActionDataView);
        }

        #region RichEdit

        public ActionResult RichEditDescription(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.VocDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.VocDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public override PartialViewResult DataView(string strRoute, string gridName = "", long filterId = 0, bool isJobParentEntity = false, bool isDataView = false)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            long expandRowId;
            System.Int64.TryParse(route.Url, out expandRowId);
            base.DataView(strRoute);
            _gridResult.GridSetting.ChildGridRoute.ParentRecordId = expandRowId;
            return PartialView(_gridResult);
        }
    }
}