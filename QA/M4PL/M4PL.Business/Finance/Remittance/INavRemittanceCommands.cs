﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Document;
using M4PL.Entities.Finance.Remittance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.Finance.Remittance
{
	public interface INavRemittanceCommands : IBaseCommands<NavRemittance>
	{
		DocumentData GetPostedInvoiceByCheckNumber(string checkNumber);
	}
}
