/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavSalesOrder
//Purpose:                                      Contains Actions to render view on Nav Sales Order over the Pages in the system
//====================================================================================================================================================*/
using M4PL.APIClient.Finance;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Mvc;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Job;

namespace M4PL.Web.Areas.Finance.Controllers
{
    public class NavSalesOrderController : BaseController<NavSalesOrderView>
	{
		protected INavSalesOrderCommands _navSalesOrderCommands;

		private readonly IJobCommands _jobCommands;

		/// <summary>
		/// Nav Sales Order Controller Constructor
		/// </summary>
		/// <param name="navSalesOrderCommands">navSalesOrderCommands</param>
		/// <param name="commonCommands">commonCommands</param>
		public NavSalesOrderController(INavSalesOrderCommands navSalesOrderCommands, ICommonCommands commonCommands, IJobCommands jobCommands)
                : base(navSalesOrderCommands)
        {
			_commonCommands = commonCommands;
			_navSalesOrderCommands = navSalesOrderCommands;
			_jobCommands = jobCommands;
		}

		public ActionResult SyncOrderDetailsInNAV()
		{
			var route = SessionProvider.ActiveUser.CurrentRoute;
			NavSalesOrderView navSalesOrder;
			_jobCommands.ActiveUser = SessionProvider.ActiveUser;
			JobView jobData = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId);
			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.CreateSalesOrder);
			if (jobData == null)
			{
				displayMessage.Description = string.Format("There is no data found to create sales order for JobId: {0}.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			else if(jobData != null && jobData.CustomerERPId == 0)
			{
				displayMessage.Description = string.IsNullOrEmpty(jobData.JobSONumber) ? string.Format("Sales order creation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId) : string.Format("Sales order updation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			
			if (!string.IsNullOrEmpty(jobData.JobSONumber))
			{
				navSalesOrder = new NavSalesOrderView()
				{
					No = jobData.JobSONumber,
					M4PL_Job_ID = jobData.Id.ToString(),
					Quote_No = jobData.JobPONumber,
					VendorNo = jobData.VendorERPId,
					Electronic_Invoice = jobData.JobElectronicInvoice
				};

				navSalesOrder = _currentEntityCommands.Patch(navSalesOrder);
				displayMessage.Description = string.Format("Sales Order {0} updated successfully in NAV.", jobData.JobSONumber);
			}
			else
			{
				navSalesOrder = new NavSalesOrderView()
				{
					M4PL_Job_ID = jobData.Id.ToString(),
					VendorNo = jobData.VendorERPId,
					Electronic_Invoice = jobData.JobElectronicInvoice
				};

				NavSalesOrderView navSalesOrderView = _currentEntityCommands.Post(navSalesOrder);
				if (navSalesOrderView != null && !string.IsNullOrEmpty(navSalesOrderView.No))
				{
					displayMessage.Description = string.Format("Sales order generated sucessfully, sales order number is: {0}", navSalesOrderView.No);
				}
				else
				{
					displayMessage.Description = "Sales Order is not Created In Nav.";
				}
			}

			return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
		}
	}
}