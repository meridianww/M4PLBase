﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 NavRateCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Administration.NavRateCommands
//==============================================================================================================

using System;
using System.Collections.Generic;
using M4PL.Entities;
using M4PL.Entities.Finance.Customer;
using M4PL.Entities.Support;
using System.Net;
using System.Linq;

namespace M4PL.Business.Finance.Gateway
{
	public class GatewayCommands : BaseCommands<Entities.Finance.Customer.Gateway>, IGatewayCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public StatusModel GenerateProgramGateway(List<Entities.Finance.Customer.Gateway> gatewayList)
		{
			StatusModel statusModel = ValidateGatewayListPassedForUpload(gatewayList);
			if (statusModel == null)
			{
				var sysReferenceList = DataAccess.Administration.SystemReferenceCommands.GetSystemRefrenceList();
				return DataAccess.Finance.GatewayCommands.GenerateProgramGateway(gatewayList, ActiveUser, sysReferenceList);
			}

			return statusModel;
		}

		public Entities.Finance.Customer.Gateway Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<Entities.Finance.Customer.Gateway> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Patch(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Post(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}

		public Entities.Finance.Customer.Gateway Put(Entities.Finance.Customer.Gateway entity)
		{
			throw new NotImplementedException();
		}

		private StatusModel ValidateGatewayListPassedForUpload(List<Entities.Finance.Customer.Gateway> gatewayList)
		{
			var duplicateRecords = gatewayList != null ? gatewayList
                                  .GroupBy(r => new { r.Code, r.ShipmentType, r.OrderType, r.Type })
                                  .Select(g => new Entities.Finance.Customer.Gateway
								  {
									  Code  = g.Key.Code,
									  OrderType = g.Key.OrderType,
									  ShipmentType = g.Key.ShipmentType,
									  Type = g.Key.Type
								  })
								  : null;

			if (gatewayList == null || (gatewayList != null && gatewayList.Count == 0))
			{
				return new StatusModel() { AdditionalDetail ="Gateway details can not be empty.", Status ="Failue", StatusCode = (int)HttpStatusCode.PreconditionFailed };
			}
			else if(!gatewayList.Where(p => (String.Equals(p.OrderType, "Original", StringComparison.CurrentCulture) || String.Equals(p.OrderType, "Return", StringComparison.CurrentCulture))).Any())
			{
				return new StatusModel() { AdditionalDetail = "Your uploaded file data is having some unwanted OrderType, valid order types accepting by the system are: Original and Return.", Status = "Failue", StatusCode = (int)HttpStatusCode.PreconditionFailed };
			}
			else if (!gatewayList.Where(p => (String.Equals(p.ShipmentType, "Cross-Dock Shipment", StringComparison.CurrentCulture) || String.Equals(p.ShipmentType, "Direct Shipment", StringComparison.CurrentCulture))).Any())
			{
				return new StatusModel() { AdditionalDetail = "Your uploaded file data is having some unwanted ShipmentType, valid shipment types accepting by the system are: Cross-Dock Shipment and Direct Shipment.", Status = "Failue", StatusCode = (int)HttpStatusCode.PreconditionFailed };
			}
			else if (!gatewayList.Where(p => (String.Equals(p.Type, "Gateway", StringComparison.CurrentCulture) || String.Equals(p.Type, "Action", StringComparison.CurrentCulture))).Any())
			{
				return new StatusModel() { AdditionalDetail = "Your uploaded file data is having some unwanted Gateway Types, valid gateway types accepting by the system are: Gateway and Action.", Status = "Failue", StatusCode = (int)HttpStatusCode.PreconditionFailed };
			}
			else if(duplicateRecords != null && duplicateRecords.Count() > 1)
			{
				return new StatusModel() { AdditionalDetail = "Combination of Code, Type, Shipment Type and Order Type should be unique, please delete the duplicate records from file.", Status = "Failue", StatusCode = (int)HttpStatusCode.PreconditionFailed };
			}

			return null;
		}
	}
}