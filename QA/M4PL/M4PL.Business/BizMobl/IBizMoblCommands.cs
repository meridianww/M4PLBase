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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IBizMoblCommands
// Purpose:                                      Set of rules for CustomerCommands
//==============================================================================================================

using M4PL.Entities;
using M4PL.Entities.BizMobl;
using System.Collections.Generic;

namespace M4PL.Business.BizMobl
{
	/// <summary>
	/// Performs basic CRUD operation on the IBizMoblCommands Entity
	/// </summary>
	public interface IBizMoblCommands : IBaseCommands<BizMoblModel>
	{
		StatusModel GenerateCSVByFileName(string fileName);
	}
}