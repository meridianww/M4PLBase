#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.DataAccess.SQLSerializer.Serializer;

namespace M4PL.DataAccess.SQLSerializer.Interface
{
	/// <summary>
	/// </summary>
	public interface ISerializer
	{
		#region Serializer

		/// <summary>
		///     Get Sql serializer for
		/// </summary>
		SqlSerializer DAL { get; }

		#endregion Serializer
	}
}