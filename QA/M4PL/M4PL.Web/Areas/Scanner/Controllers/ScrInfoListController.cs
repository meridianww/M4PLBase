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
//Programmer:                                   Janardana
//Date Programmed:                              28/07/2018
//Program Name:                                 ScrInfoList
//Purpose:                                      Contains Actions to render view on ScrInfoList page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.Web.Areas.Scanner.Controllers
{
	public class ScrInfoListController : BaseController<ScrInfoListView>
	{
		public ScrInfoListController(IScrInfoListCommands scrInfoListCommands, ICommonCommands commonCommands) : base(scrInfoListCommands)
		{
			_commonCommands = commonCommands;
		}
	}
}