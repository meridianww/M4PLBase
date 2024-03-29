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
// Date Programmed:                              07/31/2019
// Program Name:                                 INavPriceCodeCommands
// Purpose:                                      Set of rules for NavPriceCodeCommands
//================================================================================================================

using M4PL.Entities.Finance.PriceCode;
using System.Collections.Generic;

namespace M4PL.Business.Finance.PriceCode
{
	public interface INavPriceCodeCommands : IBaseCommands<NavPriceCode>
	{
		IList<NavPriceCode> GetAllPriceCode();

		Entities.Document.DocumentData GetPriceCodeReportByJobId(string jobId);

		Entities.Document.DocumentStatus IsPriceCodeDataPresentForJobInNAV(string jobId);
	}
}