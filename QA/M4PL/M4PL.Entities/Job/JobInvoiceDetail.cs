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
// Date Programmed:                              07/02/2020
// Program Name:                                 JobInvoiceDetail
// Purpose:                                      Contains objects related to JobInvoiceDetail
//==========================================================================================================

using System;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Invoice Details
	/// </summary>
	public class JobInvoiceDetail
	{
		/// <summary>
		/// Gets or Sets Job Sales Invoice Number
		/// </summary>
		public string JobSalesInvoiceNumber { get; set; }
		/// <summary>
		/// Gets or Sets Job Purchase Invoice Number
		/// </summary>
		public string JobPurchaseInvoiceNumber { get; set; }
		/// <summary>
		/// Gets or Sets Job Invoice Date
		/// </summary>
		public DateTime? JobInvoicedDate { get; set; }
	}
}
