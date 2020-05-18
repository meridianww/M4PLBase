/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              07/31/2019
Program Name:                                 NavCostCodeCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavCostCodeCommands
=============================================================================================================*/
using M4PL.Entities.Finance.CostCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using System.Net;
using System.IO;
using _commands = M4PL.DataAccess.Finance.NavCostCodeCommands;
using _orderItemCommands = M4PL.DataAccess.Finance.NAVOrderItemCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Business.Common;

namespace M4PL.Business.Finance.CostCode
{
	public class NavCostCodeCommands : BaseCommands<NavCostCode>, INavCostCodeCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public IList<NavCostCode> GetAllCostCode()
		{
			List<NavCostCode> navCostCodeList = null;
			if (!M4PBusinessContext.ComponentSettings.NavRateReadFromItem)
			{
				navCostCodeList = GetNavCostCodeData();
				if (navCostCodeList != null && navCostCodeList.Count > 0)
				{
					_commands.Put(ActiveUser, navCostCodeList);
				}
			}
			else
			{
				NAVOrderItemResponse navOrderItemResponse = CommonCommands.GetNAVOrderItemResponse();
				if (navOrderItemResponse?.OrderItemList?.Count > 0)
				{
					_orderItemCommands.UpdateNavCostCode(ActiveUser, navOrderItemResponse.OrderItemList);
					navCostCodeList = new List<NavCostCode>();
				}
			}

			return navCostCodeList;
		}

		public NavCostCode Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavCostCode> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Patch(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Post(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		public NavCostCode Put(NavCostCode entity)
		{
			throw new NotImplementedException();
		}

		private List<NavCostCode> GetNavCostCodeData()
		{
			string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
			string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
			string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
			NavCostCodeResponse navCostCodeResponse = null;
			try
			{
				string serviceCall = string.Format("{0}('{1}')/PurchasePrices", navAPIUrl, "Meridian");
				NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
				request.Credentials = myCredentials;
				request.KeepAlive = false;
				WebResponse response = request.GetResponse();

				using (Stream navPriceCodeResponseStream = response.GetResponseStream())
				{
					using (TextReader txtCarrierSyncReader = new StreamReader(navPriceCodeResponseStream))
					{
						string responceString = txtCarrierSyncReader.ReadToEnd();

						using (var stringReader = new StringReader(responceString))
						{
							navCostCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavCostCodeResponse>(responceString);
						}
					}
				}
			}
			catch(Exception exp)
			{
				_logger.Log(exp, "Error is occurring when getting the Nav Cost code data.", "GetNavCostCodeData", Utilities.Logger.LogType.Error);
			}

			return (navCostCodeResponse?.CostCodeList?.Count > 0) ?
					navCostCodeResponse.CostCodeList :
					new List<NavCostCode>();
		}
	}
}
