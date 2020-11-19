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
// Program Name:                                 PrgEdiMapping
// Purpose:                                      Contains objects related to PrgEdiMapping
//==========================================================================================================

using System;

namespace M4PL.Entities.Program
{
	/// <summary>
	///
	/// </summary>
	public class PrgEdiMapping : BaseModel
	{
		/// <summary>
		/// Gets or Sets Program EDI Mapping Header ID
		/// </summary>
		public long? PemHeaderID { get; set; }
		/// <summary>
		/// Gets or Sets Name for the identifier
		/// </summary>
		public string PemHeaderIDName { get; set; }
		/// <summary>
		/// Gets or Sets Edi Table Name e.g. EDI204SummaryHeader
		/// </summary>
		public string PemEdiTableName { get; set; }
		/// <summary>
		/// Gets or Sets Edi Field Name e.g. eshBOLNo
		/// </summary>
		public string PemEdiFieldName { get; set; }
		/// <summary>
		/// Gets or Sets Field Data Type e.g. varchar
		/// </summary>
		public string PemEdiFieldDataType { get; set; }
		/// <summary>
		/// Gets or Sets System Table Name e.g. JOBDL000Master
		/// </summary>
		public string PemSysTableName { get; set; }
		/// <summary>
		/// Gets or Sets System Field Name e.g. JobBOL
		/// </summary>
		public string PemSysFieldName { get; set; }
		/// <summary>
		/// Gets or Sets Data Type e.g. nvarchar
		/// </summary>
		public string PemSysFieldDataType { get; set; }
		/// <summary>
		/// Gets or Sets Mapping start Date if any
		/// </summary>
		public DateTime? PemDateStart { get; set; }
		/// <summary>
		/// Gets or Sets Mapping End Date if any
		/// </summary>
		public DateTime? PemDateEnd { get; set; }
		/// <summary>
		/// Gets or Sets Identifier if the current values are for insert or update e.g. 212 for Insert and 213 for update
		/// </summary>
		public int? PemInsertUpdate { get; set; }
	}
}