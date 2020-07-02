#region Copyright
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
	public class DocumentData
	{
		public string DocumentName { get; set; }

		public byte[] DocumentContent { get; set; }

		public string DocumentExtension { get; set; }

		public string DocumentHtml { get; set; }

		public string DocumentType { get; set; }
	}
}
