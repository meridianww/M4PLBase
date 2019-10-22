/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/22/2019
Program Name:                                 JobOrderItemMapping
Purpose:                                      Contains objects related to JobOrderItemMapping
==========================================================================================================*/

namespace M4PL.Entities.Finance
{
	public class JobOrderItemMapping
	{
		public long JobId { get; set; }
		public string EntityName { get; set; }
		public int LineNumber { get; set; }
	}
}
