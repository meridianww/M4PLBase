#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Document
{
	public class CargoItem
	{
		public int? ItemNo { get; set; }
		public string PartCode { get; set; }
		public string SerialNumber { get; set; }
		public string Title { get; set; }
		public string PackagingType { get; set; }
		public string QuantityUnit { get; set; }
		public decimal Weight { get; set; }
		public decimal Cubes { get; set; }
	}
}