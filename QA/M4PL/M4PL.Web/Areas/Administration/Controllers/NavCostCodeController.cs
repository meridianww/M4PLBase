﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavPriceCode
//Purpose:                                      Contains Actions to render view on Nav Cost Code over the Pages in the system
//====================================================================================================================================================*/
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;
using M4PL.Entities;
using System.Collections.Generic;
using System.Web.Mvc;

namespace M4PL.Web.Areas.Administration.Controllers
{
	public class NavCostCodeController : BaseController<NavCostCodeView>
	{
		protected INavCostCodeCommands _navCostCodeCommands;

		/// <summary>
		/// Interacts with the interfaces to get the Nav Cost Code details and renders to the page
		/// </summary>
		/// <param name="navPriceCodeCommands">navPriceCodeCommands</param>
		/// <param name="commonCommands">commonCommands</param>
		public NavCostCodeController(INavCostCodeCommands navCostCodeCommands, ICommonCommands commonCommands)
				: base(navCostCodeCommands)
		{
			_commonCommands = commonCommands;
			_navCostCodeCommands = navCostCodeCommands;

		}

		public ActionResult SyncSalesPricesDataFromNav()
		{
			IList<NavCostCodeView> navCostCodeViewList = _currentEntityCommands.Get();
			var displayMessage = _commonCommands.GetDisplayMessageByCode(MessageTypeEnum.Information, DbConstants.NavCostCode);
			if (navCostCodeViewList == null || navCostCodeViewList.Count == 0)
			{
				displayMessage.Description = "No record found from Dynamic Nav to sync data for cost code.";
			}

            return Json(displayMessage, JsonRequestBehavior.AllowGet);
        }
	}
}
