#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.AttributeMapping;
using System.Collections.Generic;

namespace M4PL.DataAccess.SQLSerializer.BusinessMapping
{
	/// <summary>
	///     This interface should be implemented all dataset.
	/// </summary>
	public interface IDataSet : IServerType
	{
		#region Properties

		/// <summary>
		///     Gets or sets select stored procedure name
		/// </summary>
		string StoredProcedureName { get; set; }

		/// <summary>
		///     Gets or sets input parameters of stored procedure
		/// </summary>
		List<DbParameter> InputParams { get; set; }

		#endregion Properties
	}
}