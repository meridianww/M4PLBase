#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
	/// <summary>
	///     This interface should be implemented by all models.
	///     It does not specify any methods that need to be implemented.
	///     Its sole purpose is to give all model implementations a common type.
	/// </summary>
	public interface IModel : IServerType
	{
		/// <summary>
		///     Gets a value indicating whether current object
		///     is a new object or existing object.
		/// </summary>
		bool IsNew { get; }
	}
}