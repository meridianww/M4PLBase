/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRole
//Purpose:                                      Contains Actions to render view on Program's Role page
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
    public class PrgRoleController : BaseController<ProgramRoleView>
    {
        private readonly APIClient.Organization.IOrgRefRoleCommands _orgRefRoleCommands;

        /// <summary>
        /// Interacts with the interfaces to get the Program's role details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="programRoleCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgRoleController(IPrgRoleCommands programRoleCommands, ICommonCommands commonCommands, APIClient.Organization.IOrgRefRoleCommands orgRefRoleCommands)
            : base(programRoleCommands)
        {
            _commonCommands = commonCommands;
            _orgRefRoleCommands = orgRefRoleCommands;
        }

        public override ActionResult AddOrEdit(ProgramRoleView programRoleView)
        {
            programRoleView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(programRoleView, Request.Params[WebApplicationConstants.UserDateTime]);
            programRoleView.ProgramID = programRoleView.ParentId;
            if (programRoleView.OrgID == 0)
                programRoleView.OrgID = SessionProvider.ActiveUser.OrganizationId;
            programRoleView.ProgramRoleCode = Request.Form["PrgRoleId"];
            if (programRoleView.ProgramRoleCode == WebUtilities.GetNullText(WebUtilities.GetUserColumnSettings(_commonCommands.GetColumnSettings(EntitiesAlias.PrgRole), SessionProvider).FirstOrDefault("PrgRoleId").ColAliasName))
                programRoleView.ProgramRoleCode = null;
            if (!string.IsNullOrWhiteSpace(programRoleView.ProgramRoleCode) && !programRoleView.PrgRoleId.HasValue)
                programRoleView.PrgRoleId = 0;
            var descriptionByteArray = programRoleView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRole, ByteArrayFields.PrgRoleDescription.ToString());
            var commentByteArray = programRoleView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgRole, ByteArrayFields.PrgComments.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray, commentByteArray
            };

            var messages = ValidateMessages(programRoleView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = programRoleView.Id > 0 ? base.UpdateForm(programRoleView) : base.SaveForm(programRoleView);
            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;
                commentByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(programRoleView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(programRoleView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<ProgramRoleView, long> programRoleView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            programRoleView.Insert.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            programRoleView.Update.ForEach(c => { c.ProgramID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(programRoleView, route, gridName);
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrgRoleDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PrgRoleDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        public ActionResult RichEditComments(string strRoute, M4PL.Entities.Support.Filter docId)
        {
            long newDocumentId;
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.PrgComments.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.PrgComments.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public PartialViewResult GetRefRoleLogicals(string strRoute, long id)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _orgRefRoleCommands.ActiveUser = SessionProvider.ActiveUser;
            var logicalData = _orgRefRoleCommands.Get(id);

            _formResult.Record = new ProgramRoleView()
            {
                Id = route.RecordId,
                ParentId = route.ParentRecordId,
                //PrgRoleContactID = logicalData.OrgRoleContactID,
                ProgramRoleCode = logicalData.OrgRoleCode,
                PrgRoleTitle = logicalData.OrgRoleTitle,
                RoleTypeId = logicalData.RoleTypeId,
                PrxJobDefaultAnalyst = logicalData.PrxJobDefaultAnalyst,
                PrxJobDefaultResponsible = logicalData.PrxJobDefaultResponsible,
                PrxJobGWDefaultAnalyst = logicalData.PrxJobGWDefaultAnalyst,
                PrxJobGWDefaultResponsible = logicalData.PrxJobGWDefaultResponsible,
            };

            _formResult.SessionProvider = SessionProvider;
            _formResult.SetupFormResult(_commonCommands, route);

            return PartialView("Logicals", _formResult);
        }

        public PartialViewResult GetRefRoleCodeDetails(string strRoute, long id)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            _orgRefRoleCommands.ActiveUser = SessionProvider.ActiveUser;
            var logicalData = id == 0 ? new APIClient.ViewModels.Organization.OrgRefRoleView() : _orgRefRoleCommands.Get(id);

            _formResult.Record = new ProgramRoleView()
            {
                Id = route.RecordId,
                ParentId = route.ParentRecordId,
                ProgramRoleCode = logicalData.OrgRoleCode,
                PrgRoleTitle = logicalData.OrgRoleTitle,
                RoleTypeId = logicalData.RoleTypeId,
                PrxJobDefaultAnalyst = logicalData.PrxJobDefaultAnalyst,
                PrxJobDefaultResponsible = logicalData.PrxJobDefaultResponsible,
                PrxJobGWDefaultAnalyst = logicalData.PrxJobGWDefaultAnalyst,
                PrxJobGWDefaultResponsible = logicalData.PrxJobGWDefaultResponsible,
            };

            _formResult.SessionProvider = SessionProvider;
            _formResult.SetupFormResult(_commonCommands, route);

            return PartialView("ProgramRoleCode", _formResult);
        }
    }
}