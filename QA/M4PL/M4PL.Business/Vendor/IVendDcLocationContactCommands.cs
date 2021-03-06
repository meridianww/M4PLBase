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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IVendDcLocationContactCommands
// Purpose:                                      Set of rules for VendDcLocationContactCommands
//==============================================================================================================

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;

namespace M4PL.Business.Vendor
{
	/// <summary>
	/// performs basic CRUD operation on the VendDcLocationContact Entity
	/// </summary>
	public interface IVendDcLocationContactCommands : IBaseCommands<VendDcLocationContact>
	{
		VendDcLocationContact GetVendDcLocationContact(ActiveUser activeUser, long id, long? parentId);
	}
}