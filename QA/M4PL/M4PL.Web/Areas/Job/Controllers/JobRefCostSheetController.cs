/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobRefCostSheet
//Purpose:                                      Contains Actions to render view on Job's Ref Cost Sheet page
//====================================================================================================================================================*/

using DevExpress.Web.Mvc;
using M4PL.APIClient.Common;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Models;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Job.Controllers
{
    public class JobRefCostSheetController : BaseController<JobRefCostSheetView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the Job'd ref cost sheet details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="JobRefCostSheetCommands"></param>
        /// <param name="commonCommands"></param>
        public JobRefCostSheetController(IJobRefCostSheetCommands JobRefCostSheetCommands, ICommonCommands commonCommands)
            : base(JobRefCostSheetCommands)
        {
            _commonCommands = commonCommands;
        }

        public override ActionResult AddOrEdit(JobRefCostSheetView jobRefCostSheetView)
        {
            jobRefCostSheetView.IsFormView = true;
            SessionProvider.ActiveUser.SetRecordDefaults(jobRefCostSheetView, Request.Params[WebApplicationConstants.UserDateTime]);
            jobRefCostSheetView.JobID = jobRefCostSheetView.ParentId;
            var messages = ValidateMessages(jobRefCostSheetView);
            if (messages.Any())
                return Json(new { status = false, errMessages = messages }, JsonRequestBehavior.AllowGet);

            var result = jobRefCostSheetView.Id > 0 ? base.UpdateForm(jobRefCostSheetView) : base.SaveForm(jobRefCostSheetView);

            var commentByteArray = jobRefCostSheetView.Id.GetVarbinaryByteArray(EntitiesAlias.JobRefCostSheet, ByteArrayFields.CstComments.ToString());
            _commonCommands.SaveBytes(commentByteArray, RichEditExtension.SaveCopy(commentByteArray.ControlName, DevExpress.XtraRichEdit.DocumentFormat.OpenXml));

            var route = new MvcRoute(BaseRoute, MvcConstants.ActionDataView);
            if (result is SysRefModel)
            {
                route.RecordId = result.Id;
            }
            route.ParentEntity = EntitiesAlias.Job;
            route.ParentRecordId = jobRefCostSheetView.ParentId;
            return Json(new { status = true, route = route, fileUpload = new List<ByteArray>() }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost, ValidateInput(false)]
        public PartialViewResult DataViewBatchUpdate(MVCxGridViewBatchUpdateValues<JobRefCostSheetView, long> jobRefCostSheetView, string strRoute, string gridName)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<Entities.Support.MvcRoute>(strRoute);
            jobRefCostSheetView.Insert.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            jobRefCostSheetView.Update.ForEach(c => { c.JobID = route.ParentRecordId; c.OrganizationId = SessionProvider.ActiveUser.OrganizationId; });
            base.BatchUpdate(jobRefCostSheetView, route, gridName);
            SetGridResult(route);
            return ProcessCustomBinding(route, MvcConstants.GridViewPartial);
        }

        #region RichEdit

        public ActionResult RichEditComments(string strRoute)
        {
            var route = JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var byteArray = route.GetVarbinaryByteArray(ByteArrayFields.CstComments.ToString());
            if (route.RecordId > 0)
                byteArray.Bytes = _commonCommands.GetByteArrayByIdAndEntity(byteArray).Bytes;
            return base.RichEditFormView(byteArray);
        }

        #endregion RichEdit

        public ActionResult TabView(string strRoute)
        {
            var route = Newtonsoft.Json.JsonConvert.DeserializeObject<MvcRoute>(strRoute);
            var pageControlResult = new PageControlResult
            {
                PageInfos = _commonCommands.GetPageInfos(EntitiesAlias.JobRefCostSheet),
                CallBackRoute = new MvcRoute(route, MvcConstants.ActionTabView),
                ParentUniqueName = string.Concat(route.EntityName, "_", EntitiesAlias.JobCargo.ToString())
            };
            foreach (var pageInfo in pageControlResult.PageInfos)
            {
                pageInfo.SetRoute(route, _commonCommands);
                pageInfo.Route.ParentRecordId = route.ParentRecordId;
            }
            return PartialView(MvcConstants.ViewInnerPageControlPartial, pageControlResult);
        }
    }
}