#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.Training
{
	public class TrainingDetail
	{
		/// <summary>
		/// Gets or Sets Category Id e.g. 1 for BizMobl Training
		/// </summary>
		public int CategoryId { get; set; }
		/// <summary>
		/// Gets or Sets Category Name of training video e.g. BizMobl Training
		/// </summary>
		public string CategoryName { get; set; }
		/// <summary>
		/// Gets or Sets Video Name e.g. Inbound Shipments
		/// </summary>
		public string VideoName { get; set; }
		/// <summary>
		/// Gets or Sets URL of training video URL e.g. https://m4pl.meridianww.com:1010/M4PL_Video/BizMobl/INBOUND SHIPMENTS_1_1.mp4
		/// </summary>
		public string VideoURL { get; set; }
		/// <summary>
		/// Gets or Sets Content/MIME Type for the request e.g. video/mp4
		/// </summary>
		public string ContentType { get; set; }
    }
}
