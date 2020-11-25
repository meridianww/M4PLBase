#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/11/2019
// Program Name:                                 CompanyAddress
// Purpose:                                      Contains objects related to CompanyAddress
//====================================================================================================================================================
using System;

namespace M4PL.Entities.CompanyAddress
{
	/// <summary>
	/// Model Class for Company Address
	/// </summary>
	public class CompanyAddress
	{
		/// <summary>
		/// Gets or Sets Id
		/// </summary>
		public long Id { get; set; }
		/// <summary>
		/// Gets or Sets Organization Id
		/// </summary>
		public long AddOrgId { get; set; }
		/// <summary>
		/// Gets or Sets AddTable Name
		/// </summary>
		public string AddTableName { get; set; }
		/// <summary>
		/// Gets or Sets AddPrimaryRecordId
		/// </summary>
		public long AddPrimaryRecordId { get; set; }
		/// <summary>
		/// Gets or Sets AddPrimaryContactId
		/// </summary>
		public long? AddPrimaryContactId { get; set; }
		/// <summary>
		/// Gets or Sets Sorting Order
		/// </summary>
		public int? AddItemNumber { get; set; }
		/// <summary>
		/// Gets or Sets AddCode
		/// </summary>
		public string AddCode { get; set; }
		/// <summary>
		/// Gets or Sets AddTitle
		/// </summary>
		public string AddTitle { get; set; }
		/// <summary>
		/// Gets or Sets StatusId
		/// </summary>
		public int StatusId { get; set; }
		/// <summary>
		/// Gets or Sets Address1
		/// </summary>
		public string Address1 { get; set; }
		/// <summary>
		/// Gets or Sets Address2
		/// </summary>
		public string Address2 { get; set; }
		/// <summary>
		/// Gets or Sets City
		/// </summary>
		public string City { get; set; }
		/// <summary>
		/// Gets or Sets StateId
		/// </summary>
		public int? StateId { get; set; }
		/// <summary>
		/// Gets or Sets StateIdName
		/// </summary>
		public string StateIdName { get; set; }
		/// <summary>
		/// Gets or Sets ZipPostal
		/// </summary>
		public string ZipPostal { get; set; }
		/// <summary>
		/// Gets or Sets CountryId
		/// </summary>
		public int? CountryId { get; set; }
		/// <summary>
		/// Gets or Sets CountryIdName
		/// </summary>
		public string CountryIdName { get; set; }
		/// <summary>
		/// Gets or Sets AddTypeId as From Ref Options
		/// </summary>
		public int? AddTypeId { get; set; }
		/// <summary>
		/// Gets or Sets DateEntered
		/// </summary>
		public DateTime DateEntered { get; set; }
		/// <summary>
		/// Gets or Sets EnteredBy
		/// </summary>
		public string EnteredBy { get; set; }
		/// <summary>
		/// Gets or Sets DateChanged
		/// </summary>
		public DateTime? DateChanged { get; set; }
		/// <summary>
		/// Gets or Sets ChangedBy
		/// </summary>
		public string ChangedBy { get; set; }

	}
}