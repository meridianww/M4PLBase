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
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              05/21/2020
// Program Name:                                 JobInvoiceData
// Purpose:                                      Contains objects related to JobInvoiceData
//==========================================================================================================
using System;

namespace M4PL.Entities.Job
{
    public class JobInvoiceData
    {
        public long JobId { get; set; }

        public DateTime InvoicedDate { get; set; }

        public bool IsCustomerUpdateRequired { get; set; }

        public long CustomerId { get; set; }
    }
}
