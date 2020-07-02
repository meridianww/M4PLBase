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
// Program Name:                                 JobSeller
// Purpose:                                      Contains objects related to Job Seller
//==========================================================================================================

namespace M4PL.Entities.Job
{
	public class JobSeller : BaseModel
	{
		public bool JobCompleted { get; set; }
		public string JobSellerCode { get; set; }
		public string JobSellerSitePOC { get; set; }
		public string JobSellerSitePOCPhone { get; set; }
		public string JobSellerSitePOCEmail { get; set; }
		public string JobSellerSitePOC2 { get; set; }
		public string JobSellerSitePOCPhone2 { get; set; }
		public string JobSellerSitePOCEmail2 { get; set; }
		public string JobSellerSiteName { get; set; }
		public string JobSellerStreetAddress { get; set; }
		public string JobSellerStreetAddress2 { get; set; }
		public string JobSellerStreetAddress3 { get; set; }
		public string JobSellerStreetAddress4 { get; set; }
		public string JobSellerCity { get; set; }
		public string JobSellerState { get; set; }
		public string JobSellerPostalCode { get; set; }
		public string JobSellerCountry { get; set; }

		public string JobShipFromSiteName { get; set; }
		public string JobShipFromStreetAddress { get; set; }
		public string JobShipFromStreetAddress2 { get; set; }
		public string JobShipFromStreetAddress3 { get; set; }
		public string JobShipFromStreetAddress4 { get; set; }
		public string JobShipFromCity { get; set; }
		public string JobShipFromState { get; set; }
		public string JobShipFromPostalCode { get; set; }
		public string JobShipFromCountry { get; set; }
		public string JobShipFromSitePOC { get; set; }
		public string JobShipFromSitePOCPhone { get; set; }
		public string JobShipFromSitePOCEmail { get; set; }
		public string JobShipFromSitePOC2 { get; set; }
		public string JobShipFromSitePOCPhone2 { get; set; }
		public string JobShipFromSitePOCEmail2 { get; set; }
	}
}