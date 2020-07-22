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
// Program Name:                                 JobReport
// Purpose:                                      Contains objects related to JobReport
//==========================================================================================================
using System;
using System.ComponentModel;

namespace M4PL.Entities.Job
{
	public class JobReport : BaseReportModel
	{
		public JobReport()
		{
		}

		public JobReport(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}

		[DisplayName("Start Date")]
		public DateTime StartDate { get; set; }

		[DisplayName("End Date")]
		public DateTime EndDate { get; set; }

		#region VOC

		public string Location { get; set; }
		public long? IsPBSReportFieldId { get; set; }
		public bool IsPBSReport { get; set; }

		#endregion VOC

		#region Advanced report

		public long CustomerId { get; set; }
		public long ProgramId { get; set; }
		public string ProgramIdCode { get; set; }
		public string OrderType { get; set; }
		public string OrderTypeName { get; set; }
		public string Scheduled { get; set; }
		public string ScheduledName { get; set; }
		public string Origin { get; set; }
		public string Destination { get; set; }
		public string JobStatusId { get; set; }
		public string JobStatusIdName { get; set; }
		public string GatewayStatus { get; set; }
		public string ServiceMode { get; set; }
		public string Mode { get; set; }
		public string Search { get; set; }
		public string ProgramCode { get; set; }
		public string ProgramTitle { get; set; }
		public string Brand { get; set; }
		public string ProductType { get; set; }
		public string JobChannel { get; set; }
		public string DateTypeName { get; set; }

		//public bool IsEnabledAddtionalfield { get; set; }
		public bool Manifest { get; set; }

		//public string CgoPackagingTypeId { get; set; }
		//public string CgoPackagingTypeIdName { get; set; }
		//public int? CgoWeightUnitTypeId { get; set; }
		//public string CgoWeightUnitTypeIdName { get; set; }
		//public int JobPartsOrdered { get; set; }
		public long CargoId { get; set; }

		public string CargoIdName { get; set; }
		public string PackagingCode { get; set; }

		#endregion Advanced report
	}
}