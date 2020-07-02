#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.API.Areas.HelpPage
{
	/// <summary>
	/// This represents an image sample on the help page. There's a display template named ImageSample associated with this class.
	/// </summary>
	public class ImageSample
	{
		/// <summary>
		/// Initializes a new instance of the <see cref="ImageSample"/> class.
		/// </summary>
		/// <param name="src">The URL of an image.</param>
		public ImageSample(string src)
		{
			if (src == null)
			{
				throw new ArgumentNullException("src");
			}
			Src = src;
		}

		public string Src { get; private set; }

		public override bool Equals(object obj)
		{
			ImageSample other = obj as ImageSample;
			return other != null && Src == other.Src;
		}

		public override int GetHashCode()
		{
			return Src.GetHashCode();
		}

		public override string ToString()
		{
			return Src;
		}
	}
}