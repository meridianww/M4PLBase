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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 ColumnAlias
//Purpose:                                      End point to interact with Column Alias module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/ColumnAliases")]
	public class ColumnAliasesController : BaseApiController<ColumnAlias>
	{
		private readonly IColumnAliasCommands _columnAliasCommands;

		/// <summary>
		/// Function to get tables and reference name details
		/// </summary>
		/// <param name="columnAliasCommands"></param>
		public ColumnAliasesController(IColumnAliasCommands columnAliasCommands)
			: base(columnAliasCommands)
		{
			_columnAliasCommands = columnAliasCommands;
		}
	}
}