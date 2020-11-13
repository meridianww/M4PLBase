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
// Program Name:                                 BaseReportModel
// Purpose:                                      Contains objects related to BaseReportModel
//==========================================================================================================
namespace M4PL.Entities
{
	/// <summary>
	/// Gets or Sets Base Report Model
	/// </summary>
	public class BaseReportModel : BaseModel
	{
		/// <summary>
		/// Default Constructor
		/// </summary>
		public BaseReportModel()
		{
		}
		/// <summary>
		/// Copies the instance beaing passed
		/// </summary>
		/// <param name="baseReportModel"></param>
		public BaseReportModel(BaseReportModel baseReportModel)
		{
			if (baseReportModel != null)
			{
				Id = baseReportModel.Id;
				LangCode = baseReportModel.LangCode;
				OrganizationId = baseReportModel.OrganizationId;
				RprtMainModuleId = baseReportModel.RprtMainModuleId;
				RprtName = baseReportModel.RprtName;
				RprtIsDefault = baseReportModel.RprtIsDefault;
			}
		}
		/// <summary>
		/// Gets or Sets Report ID
		/// </summary>
		public int RprtMainModuleId { get; set; }
		/// <summary>
		/// Gets or Sets varbinary Report Template
		/// </summary>
		public byte[] RprtTemplate { get; set; }
		/// <summary>
		/// Gets or Sets Report Description
		/// </summary>
		public string RprtDescription { get; set; }
		/// <summary>
		/// Gets or Sets Report Name e.g. OSD Report
		/// </summary>
		public string RprtName { get; set; }
		/// <summary>
		/// Gets or Sets if the current report is default e.g. Job Advance Report is default for Job Reports
		/// </summary>
		private bool? rprtIsDefault;
		/// <summary>
		/// Gets or Sets if the current report is default e.g. Job Advance Report is default for Job Reports
		/// </summary>
		public bool? RprtIsDefault { get { return rprtIsDefault; } set { rprtIsDefault = value == null ? false : value; } }
	}
}