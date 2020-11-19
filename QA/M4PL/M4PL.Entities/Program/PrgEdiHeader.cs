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
// Program Name:                                 PrgEdiHeader
// Purpose:                                      Contains objects related to PrgEdiHeader
//==========================================================================================================

using System;
using System.ComponentModel.DataAnnotations;

namespace M4PL.Entities.Program
{
	/// <summary>
	///
	/// </summary>
	public class PrgEdiHeader : BaseModel
	{
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? PehProgramID { get; set; }
		/// <summary>
		/// Gets or Sets Program Name
		/// </summary>
		public string PehProgramIDName { get; set; }

		/// <summary>
		/// Gets or sets the Sorting order.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public int? PehItemNumber { get; set; }
		/// <summary>
		/// Gets or sets the EDI Code. e.g. AWC204
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehEdiCode { get; set; }
		/// <summary>
		/// Gets or sets the EDI Title. e.g. AWC EDI 204 Document
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehEdiTitle { get; set; }
		/// <summary>
		/// Gets or sets the Description.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public byte[] PehEdiDescription { get; set; }
		/// <summary>
		/// Gets or sets the Trading Partner.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehTradingPartner { get; set; }
		/// <summary>
		/// Gets or sets the EDI Document. e.g. 204
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehEdiDocument { get; set; }
		/// <summary>
		/// Gets or sets the EDI Version.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehEdiVersion { get; set; }
		/// <summary>
		/// Gets or sets the SCAC Code. e.g. MEWF
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public string PehSCACCode { get; set; }
		/// <summary>
		/// Gets or sets the number of attachments.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public int? PehAttachments { get; set; }
		/// <summary>
		/// Gets or sets the Start Date.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public DateTime? PehDateStart { get; set; }
		/// <summary>
		/// Gets or sets the End Date.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>

		public DateTime? PehDateEnd { get; set; }
		/// <summary>
		/// Gets or Sets flag if Send or Recieve or not
		/// </summary>
		public bool PehSndRcv { get; set; }
		/// <summary>
		/// Gets or Sets flag if the current EDI is Parent EDI or not
		/// </summary>
		public bool PehParentEDI { get; set; }
		/// <summary>
		/// Gets or Sets Insert Code
		/// </summary>
		public string PehInsertCode { get; set; }
		/// <summary>
		/// Gets or Sets Update Code
		/// </summary>
		public string PehUpdateCode { get; set; }
		/// <summary>
		/// Gets or Sets Cancel Code
		/// </summary>
		public string PehCancelCode { get; set; }
		/// <summary>
		/// Gets or Sets Hold Code
		/// </summary>
		public string PehHoldCode { get; set; }
		/// <summary>
		/// Gets or Sets Original Code
		/// </summary>
		public string PehOriginalCode { get; set; }
		/// <summary>
		/// Gets or Sets Return Code
		/// </summary>
		public string PehReturnCode { get; set; }

		/// <summary>
		/// Gets or sets UDF01
		/// </summary>
		public string UDF01 { get; set; }

		/// <summary>
		/// Gets or sets the UDF02
		/// </summary>
		public string UDF02 { get; set; }

		/// <summary>
		/// Gets or sets the UDF03
		/// </summary>
		public string UDF03 { get; set; }

		/// <summary>
		/// Gets or sets the UDF04
		/// </summary>
		public string UDF04 { get; set; }
		/// <summary>
		/// Gets or Sets UDF05
		/// </summary>
		public string UDF05 { get; set; }
		/// <summary>
		/// Gets or Sets UDF06
		/// </summary>
		public string UDF06 { get; set; }
		/// <summary>
		/// Gets or Sets UDF07
		/// </summary>
		public string UDF07 { get; set; }
		/// <summary>
		/// Gets or Sets UDF08
		/// </summary>
		public string UDF08 { get; set; }
		/// <summary>
		/// Gets or Sets UDF09
		/// </summary>
		public string UDF09 { get; set; }
		/// <summary>
		/// Gets or Sets UDF10
		/// </summary>
		public string UDF10 { get; set; }
		/// <summary>
		/// Gets or Sets Input Output folder address
		/// </summary>
		public string PehInOutFolder { get; set; }
		/// <summary>
		/// Gets or Sets Archive Folder Address
		/// </summary>
		public string PehArchiveFolder { get; set; }
		/// <summary>
		/// Gets or Sets Processed Folder Address
		/// </summary>
		public string PehProcessFolder { get; set; }
		/// <summary>
		/// Gets or Sets FTP Server URL
		/// </summary>
		public string PehFtpServerUrl { get; set; }
		/// <summary>
		/// Gets or Sets FTP User Name
		/// </summary>
		public string PehFtpUsername { get; set; }
		/// <summary>
		/// Gets or Sets FTP Password
		/// </summary>
		[DataType(DataType.Password)]
		[Display(Name = "FTP Password")]
		public string PehFtpPassword { get; set; }
		/// <summary>
		/// Gets or Sets FTP Port
		/// </summary>
		public string PehFtpPort { get; set; }
		/// <summary>
		/// Gets or Sets flag if the FTP is being used of EDI file transfer or not
		/// </summary>
		public bool IsSFTPUsed { get; set; }
	}
}