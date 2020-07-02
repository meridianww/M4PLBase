#region Copyright
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
// Date Programmed:                              10/04/2019
// Program Name:                                 NavPurchaseOrderCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPurchaseOrderCommands
//==============================================================================================================
using M4PL.Entities.Finance.PurchaseOrder;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Finance.PurchaseOrder
{
    public class NavPurchaseOrderCommands : BaseCommands<NavPurchaseOrder>, INavPurchaseOrderCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public NavPurchaseOrder Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<NavPurchaseOrder> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public NavPurchaseOrder Patch(NavPurchaseOrder entity)
        {
            throw new NotImplementedException();
        }

        public NavPurchaseOrder Post(NavPurchaseOrder entity)
        {
            throw new NotImplementedException();
        }

        public NavPurchaseOrder Put(NavPurchaseOrder entity)
        {
            throw new NotImplementedException();
        }

        public NavPurchaseOrder CreatePurchaseOrderForNAV(long jobId)
        {
            return new NavPurchaseOrder();
        }
    }
}
