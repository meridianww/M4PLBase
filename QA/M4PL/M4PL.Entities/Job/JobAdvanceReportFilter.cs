#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Advance Report Filter
	/// </summary>
	public class JobAdvanceReportFilter : BaseReportModel
	{
		/// <summary>
		/// Default Constructor
		/// </summary>
		public JobAdvanceReportFilter()
		{
		}
		/// <summary>
		/// Parameterised constructor by passing Base Report Model
		/// </summary>
		/// <param name="baseReportModel"></param>
		public JobAdvanceReportFilter(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}

		/// <summary>
		/// Gets or Sets CustomerId
		/// </summary>
		public long CustomerId { get; set; }
		/// <summary>
		/// Gets or Sets ProgramId
		/// </summary>
		public long ProgramId { get; set; }
		/// <summary>
		/// Gets or Sets ProgramId Code
		/// </summary>
		public string ProgramIdCode { get; set; }
		/// <summary>
		/// Gets or Sets Order Type
		/// </summary>
		public int? OrderType { get; set; }
		/// <summary>
		/// Gets or Sets Order Type Name
		/// </summary>
		public string OrderTypeName { get; set; }
		/// <summary>
		/// Gets or Sets Scheduled count
		/// </summary>
		public int? Scheduled { get; set; }
		/// <summary>
		/// Gets or Sets Scheduled Name
		/// </summary>
		public string ScheduledName { get; set; }
		/// <summary>
		/// Gets or Sets Origin
		/// </summary>
		public string Origin { get; set; }
		/// <summary>
		/// Gets or Sets Destination
		/// </summary>
		public string Destination { get; set; }
		/// <summary>
		/// Gets or Sets Job StatusId
		/// </summary>
		public long JobStatusId { get; set; }
		/// <summary>
		/// Gets or Sets Job StatusId Name
		/// </summary>
		public string JobStatusIdName { get; set; }
		/// <summary>
		/// Gets or Sets Gateway Status
		/// </summary>
		public string GatewayStatus { get; set; }
		/// <summary>
		/// Gets or Sets Service Mode
		/// </summary>
		public string ServiceMode { get; set; }
		/// <summary>
		/// Gets or Sets Mode
		/// </summary>
		public long Mode { get; set; }
		/// <summary>
		/// Gets or Sets Search
		/// </summary>
		public string Search { get; set; }
		/// <summary>
		/// Gets or Sets Program Code
		/// </summary>
		public string ProgramCode { get; set; }
		/// <summary>
		/// Gets or Sets Program Title
		/// </summary>
		public string ProgramTitle { get; set; }
		/// <summary>
		/// Gets or Sets Brand
		/// </summary>
		public string Brand { get; set; }
		/// <summary>
		/// Gets or Sets Product Type
		/// </summary>
		public string ProductType { get; set; }
		/// <summary>
		/// Gets or Sets Job Channel
		/// </summary>
		public string JobChannel { get; set; }
		/// <summary>
		/// Gets or Sets DateType Name
		/// </summary>
		public string DateTypeName { get; set; }
		/// <summary>
		/// Gets or Sets Packaging Code
		/// </summary>
		public string PackagingCode { get; set; }
		/// <summary>
		/// Gets or Sets Weight Unit
		/// </summary>
		public string WeightUnit { get; set; }
		/// <summary>
		/// Gets or Sets Cargo Title
		/// </summary>
		public string CargoTitle { get; set; }

	}
}