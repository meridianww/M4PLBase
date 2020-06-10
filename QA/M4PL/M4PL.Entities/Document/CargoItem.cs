﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
