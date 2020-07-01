/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              07/31/2019
Program Name:                                 NavPriceCodeCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPriceCodeCommands
=============================================================================================================*/

using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Finance.OrderItem
{
    public class NavOrderItemCommands : BaseCommands<NAVOrderItemResponse>, INavOrderItemCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public NAVOrderItemResponse Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<NAVOrderItemResponse> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public NAVOrderItemResponse Patch(NAVOrderItemResponse entity)
        {
            throw new NotImplementedException();
        }

        public NAVOrderItemResponse Post(NAVOrderItemResponse entity)
        {
            throw new NotImplementedException();
        }

        public NAVOrderItemResponse Put(NAVOrderItemResponse entity)
        {
            throw new NotImplementedException();
        }
    }
}
