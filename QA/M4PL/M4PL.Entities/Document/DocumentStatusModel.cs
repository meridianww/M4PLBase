﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Document
{
	/// <summary>
	/// Model class for Response of NAV Posted Invoices
	/// </summary>
	public class DocumentStatusModel
	{
		/// <summary>
		/// Gets or Sets flag if the Response is Success
		/// </summary>
		public bool IsSuccess { get; set; }
		/// <summary>
		/// Gets or Sets Additional Message
		/// </summary>
		public string AdditionalMessage { get; set; }
		/// <summary>
		/// Gets or Sets Invoice Document Data from NAV
		/// </summary>
		public DocumentData DocumentData { get; set; }
	}
}
