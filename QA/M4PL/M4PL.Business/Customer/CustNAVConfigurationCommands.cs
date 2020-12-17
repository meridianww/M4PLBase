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
// Programmer:                                   Kamal
// Date Programmed:                              17/12/2020
// Program Name:                                 CustNAVConfigurationCommands
// Purpose:                                      Set of rules for CustNAVConfigurationCommands
//==============================================================================================================

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustNAVConfigurationCommands;

namespace M4PL.Business.Customer
{
    public class CustNAVConfigurationCommands : BaseCommands<CustNAVConfiguration>, ICustNAVConfigurationCommands
    {
        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public CustNAVConfiguration Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public IList<CustNAVConfiguration> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public CustNAVConfiguration Patch(CustNAVConfiguration entity)
        {
            throw new NotImplementedException();
        }

        public CustNAVConfiguration Post(CustNAVConfiguration entity)
        {
            return _commands.Post(ActiveUser, entity);
        }

        public CustNAVConfiguration Put(CustNAVConfiguration entity)
        {
            return _commands.Put(ActiveUser, entity);
        }
    }
}
