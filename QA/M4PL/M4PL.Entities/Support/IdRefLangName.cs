#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 IdRefLangName
// Purpose:                                      Contains objects related to IdRefLangName
//==========================================================================================================

namespace M4PL.Entities.Support
{
	/// <summary>
	/// IdRefLangName class defines the user language in the system
	/// </summary>
	public class IdRefLangName
	{
		public IdRefLangName()
		{
		}

		public IdRefLangName(int sysRefId, string langName)
		{
			SysRefId = sysRefId;
			LangName = langName;
		}
		/// <summary>
		/// Gets or Sets System Reference Identifier
		/// </summary>
		public int SysRefId { get; set; }
		/// <summary>
		/// Gets or Sets Parent Id
		/// </summary>
		public long ParentId { get; set; }
		/// <summary>
		/// Gets or Sets System reference Name
		/// </summary>
		public string SysRefName { get; set; }
		/// <summary>
		/// Gets or Sets Language e.g. EN for English
		/// </summary>
		public string LangName { get; set; }
		/// <summary>
		/// Gets or Sets Flag for default record
		/// </summary>
		public bool IsDefault { get; set; }
	}
}