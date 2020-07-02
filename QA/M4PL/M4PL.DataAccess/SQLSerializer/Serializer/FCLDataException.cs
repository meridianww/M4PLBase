#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
	public class FCLDataException : Exception
	{
		public FCLDataException(string errorCode, string message, Exception innerException)
			: base(message, innerException)
		{
			ErrorCode = errorCode;
		}

		public string ErrorCode { get; private set; }
	}
}