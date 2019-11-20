﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              07/31/2019
Program Name:                                 INavCostCodeCommands
Purpose:                                      Set of rules for NavCostCodeCommands
===============================================================================================================*/

using M4PL.Entities.Finance.SalesOrder;
using System.Collections.Generic;

namespace M4PL.Business.Finance.SalesOrder
{
	public interface INavSalesOrderCommands : IBaseCommands<NavSalesOrder>
	{
		NavSalesOrder CreateSalesOrderForRollup(List<long> jobIdList);
		NavSalesOrder UpdateSalesOrderForRollup(List<long> jobIdList);
	}
}
