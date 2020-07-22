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
// Program Name:                                 BaseCommands
// Purpose:                                      Contains methods to the get base lookup data
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using System.Collections.Generic;

namespace M4PL.DataAccess
{
	public class GenericCommands<T> where T : class, new()
	{
		public static IList<T> GetIdRefLangNamesFromTable(string langCode, int lookupId)
		{
			var parameters = new[]
			{
				new Parameter("@langCode", langCode),
				new Parameter("@lookupId", lookupId)
			};
			return
				SqlSerializer.Default.DeserializeMultiRecords<T>(
					StoredProceduresConstant.GetIdRefLangNamesFromTable, parameters, storedProcedure: true);
		}
	}
}