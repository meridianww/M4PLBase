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
// Date Programmed:                              10/10/2017
// Program Name:                                 VendorCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendorCommands
//====================================================================================================================

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendorCommands;

namespace M4PL.Business.Vendor
{
    public class VendorCommands : BaseCommands<Entities.Vendor.Vendor>, IVendorCommands
    {
        /// <summary>
        /// Gets list of vendor data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Vendor.Vendor> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific vendor record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Vendor.Vendor Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new vendor record
        /// </summary>
        /// <param name="vendor"></param>
        /// <returns></returns>

        public Entities.Vendor.Vendor Post(Entities.Vendor.Vendor vendor)
        {
            return _commands.Post(ActiveUser, vendor);
        }

        /// <summary>
        /// Updates an existing vendor record
        /// </summary>
        /// <param name="vendor"></param>
        /// <returns></returns>

        public Entities.Vendor.Vendor Put(Entities.Vendor.Vendor vendor)
        {
            return _commands.Put(ActiveUser, vendor);
        }

        /// <summary>
        /// Deletes a specific vendor record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of vendor record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public Entities.Vendor.Vendor Patch(Entities.Vendor.Vendor entity)
        {
            return _commands.Patch(ActiveUser, entity);
        }
    }
}