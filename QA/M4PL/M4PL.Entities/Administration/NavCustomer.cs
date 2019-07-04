﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 NavCustomer
Purpose:                                      Contains objects related to NavCustomer
==========================================================================================================*/

using M4PL.Utilities;
using System.Collections.Generic;

namespace M4PL.Entities.Administration
{
	/// <summary>
	/// Class For Nav Customer
	/// </summary>
	public class NavCustomer : BaseModel
	{
		/// <summary>
		/// Gets Or Sets ERPId
		/// </summary>
		public string ERPId { get; set; }

		/// <summary>
		/// Gets Or Sets CustomerName
		/// </summary>
		public string Name { get; set; }

		/// <summary>
		/// Gets Or Sets CustomerCode
		/// </summary>
		public string PBS_Customer_Code { get; set; }

		/// <summary>
		/// Gets Or Sets M4PLCustomerId
		/// </summary>
		public long M4PLCustomerId { get; set; }

		/// <summary>
		/// Gets Or Sets MatchedCustomer
		/// </summary>
		public List<MatchedCustomer> MatchedCustomer { get; set; }

        /// <summary>
		/// Gets Or Sets IsAlreadyProcessed
		/// </summary>
		public bool IsAlreadyProcessed { get; set; }

        /// <summary>
        /// Gets or Sets StrRoute
        /// </summary>
        public string StrRoute { get; set; }
    }

	public class MatchedCustomer
	{
		/// <summary>
		/// Gets Or Sets ERPId
		/// </summary>
		public string ERPId { get; set; }

		/// <summary>
		/// Gets Or Sets CustomerName
		/// </summary>
		public string CustomerName { get; set; }

		/// <summary>
		/// Gets Or Sets CustomerCode
		/// </summary>
		public string CustomerCode { get; set; }
	}
}
