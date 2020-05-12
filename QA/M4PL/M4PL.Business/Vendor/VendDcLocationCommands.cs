/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendDcLocationCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendDcLocationCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendDcLocationCommands;
using System;

namespace M4PL.Business.Vendor
{
    public class VendDcLocationCommands : BaseCommands<VendDcLocation>, IVendDcLocationCommands
    {
        /// <summary>
        /// Gets list of venddclocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<VendDcLocation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific venddclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public VendDcLocation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new venddclocation record
        /// </summary>
        /// <param name="vendDcLocation"></param>
        /// <returns></returns>

        public VendDcLocation Post(VendDcLocation vendDcLocation)
        {
            return _commands.Post(ActiveUser, vendDcLocation);
        }

        /// <summary>
        /// Updates an existing venddclocation record
        /// </summary>
        /// <param name="vendDcLocation"></param>
        /// <returns></returns>

        public VendDcLocation Put(VendDcLocation vendDcLocation)
        {
            return _commands.Put(ActiveUser, vendDcLocation);
        }

        /// <summary>
        /// Deletes a specific venddclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of venddclocation record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public VendDcLocation Patch(VendDcLocation entity)
		{
			throw new NotImplementedException();
		}
	}
}