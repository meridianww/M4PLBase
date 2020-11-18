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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavSalesOrder
//Purpose:                                      Contains Actions to render view on Nav Sales Order over the Pages in the system
//====================================================================================================================================================*/
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;
using M4PL.APIClient.Job;
using M4PL.APIClient.ViewModels.Finance;
using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities;
using M4PL.Entities.Finance;
using System.Text;
using System.Web.Mvc;

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
			StringBuilder successMessage = new StringBuilder();
			_jobCommands.ActiveUser = SessionProvider.ActiveUser;
			JobView jobData = _jobCommands.GetJobByProgram(route.RecordId, route.ParentRecordId);
			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.CreateSalesOrder);
			if (jobData == null)
			{
				displayMessage.Description = string.Format("There is no data found to create sales order for JobId: {0}.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			else if (jobData != null && string.IsNullOrEmpty(jobData.CustomerERPId))
			{
				displayMessage.Description = string.IsNullOrEmpty(jobData.JobSONumber) ? string.Format("Sales order creation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId) : string.Format("Sales order updation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			else if(jobData != null && !jobData.JobOriginDateTimeActual.HasValue)
			{
				displayMessage.Description = string.IsNullOrEmpty(jobData.JobSONumber) ? string.Format("Sales order creation for JobId: {0} could not proceed, Origin Date Actual can not be empty.", route.RecordId) : string.Format("Sales order updation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			else if (jobData != null && !jobData.JobDeliveryDateTimeActual.HasValue)
			{
				displayMessage.Description = string.IsNullOrEmpty(jobData.JobSONumber) ? string.Format("Sales order creation for JobId: {0} could not proceed, Delivery Date Actual can not be empty.", route.RecordId) : string.Format("Sales order updation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}
			else if (jobData != null && !jobData.JobCompleted)
			{
				displayMessage.Description = string.IsNullOrEmpty(jobData.JobSONumber) ? string.Format("Sales order creation for JobId: {0} could not proceed, Job is not in completed state.", route.RecordId) : string.Format("Sales order updation for JobId: {0} could not proceed, customer is not synced from NAV.", route.RecordId);
				return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
			}

			M4PLOrderCreationResponse m4PLOrderCreationResponse = _navSalesOrderCommands.GenerateOrdersInNav(jobData.Id);
			if (m4PLOrderCreationResponse != null)
			{
				if (m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse != null)
				{
					if (m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ManualSalesOrder != null && !string.IsNullOrEmpty(m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ManualSalesOrder.No))
					{
						successMessage.AppendLine(string.Format("Manual Sales Order: {0}", m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ManualSalesOrder.No));
					}

					if (m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ElectronicSalesOrder != null && !string.IsNullOrEmpty(m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ElectronicSalesOrder.No))
					{
						successMessage.AppendLine(string.Format("Electronic Sales Order: {0}", m4PLOrderCreationResponse.M4PLSalesOrderCreationResponse.ElectronicSalesOrder.No));
					}
				}

				if (m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse != null)
				{
					if (m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ManualPurchaseOrder != null && !string.IsNullOrEmpty(m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ManualPurchaseOrder.No))
					{
						successMessage.AppendLine(string.Format("Manual Purchase Order: {0}", m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ManualPurchaseOrder.No));
					}

					if (m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ElectronicPurchaseOrder != null && !string.IsNullOrEmpty(m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ElectronicPurchaseOrder.No))
					{
						successMessage.AppendLine(string.Format("Electronic Purchase Order: {0}", m4PLOrderCreationResponse.M4PLPurchaseOrderCreationResponse.ElectronicPurchaseOrder.No));
					}
				}

				if (!string.IsNullOrEmpty(successMessage.ToString()))
				{
					displayMessage.Description = string.Format("Order creation process successfully completed, details are as follows: {0}", successMessage.ToString());
				}
				else
				{
					displayMessage.Description = "Order is not Created In Nav.";
				}
			}
			else
			{
				displayMessage.Description = "Order is not Created In Nav.";
			}

			return Json(new { route, displayMessage }, JsonRequestBehavior.AllowGet);
		}
	}
}