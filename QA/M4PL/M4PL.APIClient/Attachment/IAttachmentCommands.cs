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
// Program Name:                                 IContactCommands
// Purpose:                                      Set of rules for ContactCommands
//=============================================================================================================

using M4PL.APIClient.ViewModels.Attachment;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Attachment
{
	/// <summary>
	/// Performs basic CRUD operation on the Contact Entity
	/// </summary>
	public interface IAttachmentCommands : IBaseCommands<AttachmentView>
	{
		IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName);
	}
}