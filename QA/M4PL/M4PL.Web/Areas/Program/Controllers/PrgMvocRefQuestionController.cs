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
//Program Name:                                 ProgramMvocRefQuestion
//Purpose:                                      Contains Actions to render view on Program's MvocRefQuestion page
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
    public class PrgMvocRefQuestionController : BaseController<PrgMvocRefQuestionView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Program's mvoc ref question details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="mvocRefQuestionCommands"></param>
        /// <param name="commonCommands"></param>
        public PrgMvocRefQuestionController(IPrgMvocRefQuestionCommands mvocRefQuestionCommands, ICommonCommands commonCommands)
            : base(mvocRefQuestionCommands)
        {
            _commonCommands = commonCommands;
        }


        public override ActionResult AddOrEdit(PrgMvocRefQuestionView prgMvocRefQuestionView)
        {
            prgMvocRefQuestionView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(prgMvocRefQuestionView, Request.Params[WebApplicationConstants.UserDateTime]);
            prgMvocRefQuestionView.MVOCID = prgMvocRefQuestionView.ParentId;

            var descriptionByteArray = prgMvocRefQuestionView.ArbRecordId.GetVarbinaryByteArray(EntitiesAlias.PrgMvocRefQuestion, ByteArrayFields.QueDescription.ToString());
            var byteArray = new List<ByteArray> {
                descriptionByteArray
            };

            var messages = ValidateMessages(prgMvocRefQuestionView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = prgMvocRefQuestionView.Id > 0 ? base.UpdateForm(prgMvocRefQuestionView) : base.SaveForm(prgMvocRefQuestionView);

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView).SetParent(EntitiesAlias.Program, prgMvocRefQuestionView.ParentId, true);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
                route.Url = prgMvocRefQuestionView.MVOCID.ToString();
                route.Entity = EntitiesAlias.PrgMvoc;
                route.SetParent(EntitiesAlias.Program, result.ParentId);
                descriptionByteArray.FileName = WebApplicationConstants.SaveRichEdit;

                return SuccessMessageForInsertOrUpdate(prgMvocRefQuestionView.Id, route, byteArray);
            }
            return ErrorMessageForInsertOrUpdate(prgMvocRefQuestionView.Id, route);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<PrgMvocRefQuestionView, long> prgMvocRefQuestionView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            prgMvocRefQuestionView.Insert.ForEach(c => { c.MVOCID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            prgMvocRefQuestionView.Update.ForEach(c => { c.MVOCID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            var batchError = BatchUpdate(prgMvocRefQuestionView, route, gridName);
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
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.QueDescription.ToString());
            if (docId != null && docId.FieldName.Equals("ArbRecordId") && long.TryParse(docId.Value, out newDocumentId))
            {
                byteArray = route.GetVarbinaryByteArray(newDocumentId, ByteArrayFields.QueDescription.ToString());
            }
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray)?.Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit
    }
}