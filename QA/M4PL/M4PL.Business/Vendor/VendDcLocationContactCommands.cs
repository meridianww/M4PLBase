#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              09/25/2018
// Program Name:                                 VendDcLocationContactCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendDcLocationContactCommands
//====================================================================================================================
using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendDcLocationContactCommands;

namespace M4PL.Business.Vendor
{
    public class VendDcLocationContactCommands : BaseCommands<VendDcLocationContact>, IVendDcLocationContactCommands
    {
        /// <summary>
        /// Get list of Vendor dclocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<VendDcLocationContact> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific Vendor dclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public VendDcLocationContact Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new Vendor dclocation contact record
        /// </summary>
        /// <param name="vendDcLocationContact"></param>
        /// <returns></returns>

        public VendDcLocationContact Post(VendDcLocationContact vendDcLocationContact)
        {
            return _commands.Post(ActiveUser, vendDcLocationContact);
        }

        /// <summary>
        /// Updates an existing Vendor dclocation contact record
        /// </summary>
        /// <param name="vendDcLocationContact"></param>
        /// <returns></returns>

        public VendDcLocationContact Put(VendDcLocationContact vendDcLocationContact)
        {
            return _commands.Put(ActiveUser, vendDcLocationContact);
        }

        /// <summary>
        /// Deletes a specific Vendor dclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of Vendor dclocation record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        /// <summary>
        /// Gets specific vendor dclocation record based on the userid
        /// </summary>
        /// <param name="activeuser"></param>
        /// <param name="id"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public VendDcLocationContact GetVendDcLocationContact(ActiveUser activeuser, long id, long? parentId)
        {
            return _commands.Get(activeuser, id, parentId);
        }

        public VendDcLocationContact Patch(VendDcLocationContact entity)
        {
            throw new NotImplementedException();
        }
    }
}
