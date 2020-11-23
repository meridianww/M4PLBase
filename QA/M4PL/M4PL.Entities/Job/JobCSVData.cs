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
// Date Programmed:                              02/04/2020
// Program Name:                                 JobCSVData
// Purpose:                                      Contains objects related to Job CSV Data
//==========================================================================================================
namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Multiple Job creation from CSV
	/// </summary>
	public class JobCSVData
	{
		/// <summary>
		/// Gets or Sets Program Id
		/// </summary>
		public long ProgramId { get; set; }
		/// <summary>
		/// Gets or Sets CSV content in Varbinary format
		/// </summary>
		public byte[] FileContent { get; set; }
		/// <summary>
		/// Gets or Sets CSV Content Base type
		/// </summary>
		public string FileContentBase64 { get; set; }
	}
}