#region Copyright

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
// Program Name:                                 INavCostCodeCommands
// Purpose:                                      Set of rules for NavCostCodeCommands
//=============================================================================================================
using M4PL.APIClient.ViewModels.Document;
using M4PL.APIClient.ViewModels.Finance;
using System.Collections.Generic;

namespace M4PL.APIClient.Finance
{
	public interface INavCostCodeCommands : IBaseCommands<NavCostCodeView>
	{
		IList<NavCostCodeView> GetAllCostCode();
        DocumentDataView GetCostCodeReportByJobId(string jobId);
    }
}