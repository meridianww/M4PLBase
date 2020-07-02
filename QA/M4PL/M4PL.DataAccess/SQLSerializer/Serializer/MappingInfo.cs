#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
	public abstract class MappingInfo
	{
		public abstract MappingAttribute MappingAttribute { get; }

		public abstract string Name { get; }

		public abstract object GetValue(object obj);

		public abstract void SetValue(object obj, object value);
	}
}