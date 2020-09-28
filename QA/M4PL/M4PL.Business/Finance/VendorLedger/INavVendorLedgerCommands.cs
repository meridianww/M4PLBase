﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              06/25/2019
// Program Name:                                 INavVendorCommands
// Purpose:                                      Set of rules for NavVendorCommands
//================================================================================================================
using M4PL.Entities.Finance.Vendor;
using M4PL.Entities.Finance.VendorLedger;
using System.Collections.Generic;

namespace M4PL.Business.Finance.VendorLedger
{
    /// <summary>
    /// Provides the operations based on the Table name
    /// </summary>
    public interface INavVendorLedgerCommands : IBaseCommands<NavVendorLedger>
    {
		List<VendorCheckedInvoice> GetVendorCheckedInvoice(string postedInvoiceNumber);
	}
}