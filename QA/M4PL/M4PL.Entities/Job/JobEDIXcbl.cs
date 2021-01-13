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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              19/02/2020
// Program Name:                                 JobEDIXcbl
// Purpose:                                      Contains objects related to JobEDIXcbl
//==========================================================================================================

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job EDI Xcbl
	/// </summary>
	public class JobEDIXcbl : BaseModel
	{
		/// <summary>
		/// Gets Or Sets Id
		/// </summary>
		//public long Id { get; set; }

		/// <summary>
		/// Gets Or Sets JobId
		/// </summary>
		public long JobId { get; set; }

		/// <summary>
		/// Gets Or EdtCode
		/// </summary>
		public string EdtCode { get; set; }

		/// <summary>
		/// Gets Or Sets EdtTitle
		/// </summary>
		public string EdtTitle { get; set; }

		/// <summary>
		/// Gets Or Sets EdtData
		/// </summary>
		public string EdtData { get; set; }

		/// <summary>
		/// Gets Or Sets EdtTypeId
		/// </summary>
		public int EdtTypeId { get; set; }

		/// <summary>
		/// Gets Or Sets EdtTypeId Name
		/// </summary>
		public string EdtTypeIdName { get; set; }

		/// <summary>
		/// Gets Or Sets TransactionDate
		/// </summary>
		public DateTime? TransactionDate { get; set; }
	}
}