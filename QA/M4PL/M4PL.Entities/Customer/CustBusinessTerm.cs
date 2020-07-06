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
// Program Name:                                 CustBusinessTerm
// Purpose:                                      Contains objects related to CustBusinessTerm
//==========================================================================================================

using System;

namespace M4PL.Entities.Customer
{
	/// <summary>
	///  Cusotmer Business Terms keeps the track for Customer's Business information and documents
	/// </summary>
	public class CustBusinessTerm : BaseModel
	{
		/// <summary>
		/// Gets or sets the organization identifier to which the customer is associated.
		/// </summary>
		/// <value>
		/// The Organization Identifier
		/// </value>
		public long? CbtOrgID { get; set; }

		public string CbtOrgIDName { get; set; }

		/// <summary>
		/// Gets or sets the Customer identifier.
		/// </summary>
		/// <value>
		/// The Customer identifier.
		/// </value>
		public long? CbtCustomerId { get; set; }

		public string CbtCustomerIdName { get; set; }

		/// <summary>
		/// Gets or sets the sorting order.
		/// </summary>
		/// <value>
		/// The CbtItemNumber.
		/// </value>
		public int? CbtItemNumber { get; set; }

		/// <summary>
		/// Gets or sets the special code defined for the Customers.
		/// </summary>
		/// <value>
		/// The CbtCode.
		/// </value>
		public string CbtCode { get; set; }

		/// <summary>
		/// Gets or sets the title.
		/// </summary>
		/// <value>
		/// The CbtTitle.
		/// </value>
		public string CbtTitle { get; set; }

		/// <summary>
		/// Gets or sets the description.
		/// </summary>
		/// <value>
		/// The CbtDescription.
		/// </value>
		public byte[] CbtDescription { get; set; }

		/// <summary>
		/// Gets or sets the type of business.
		/// </summary>
		/// <value>
		/// The BusinessTermType identifier.
		/// </value>
		public int? BusinessTermTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Active Date.
		/// </summary>
		/// <value>
		/// The CbtActiveDate.
		/// </value>
		public DateTime? CbtActiveDate { get; set; }

		/// <summary>
		/// Gets or sets the cost value of the business terms.
		/// </summary>
		/// <value>
		/// The CbtValue.
		/// </value>
		public decimal? CbtValue { get; set; }

		/// <summary>
		/// Gets or sets the high threshold for the cost value.
		/// </summary>
		/// <value>
		/// The CbtHiThreshold.
		/// </value>
		public decimal? CbtHiThreshold { get; set; }

		/// <summary>
		/// Gets or sets the low threshold for the cost value.
		/// </summary>
		/// <value>
		/// The CbtLoThreshold.
		/// </value>
		public decimal? CbtLoThreshold { get; set; }

		/// <summary>
		/// Gets or sets the count of attached documents.
		/// </summary>
		/// <value>
		/// The CbtAttachment.
		/// </value>
		public int? CbtAttachment { get; set; }
	}
}