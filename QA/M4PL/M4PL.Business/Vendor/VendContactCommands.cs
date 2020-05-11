/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendContactCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendContactCommands
===================================================================================================================*/

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendContactCommands;
using System;

namespace M4PL.Business.Vendor
{
    public class VendContactCommands : BaseCommands<VendContact>, IVendContactCommands
    {
        /// <summary>
        /// Gets list of vendcontact data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<VendContact> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific vendcontact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public VendContact Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new vendcontact record
        /// </summary>
        /// <param name="vendContact"></param>
        /// <returns></returns>

        public VendContact Post(VendContact vendContact)
        {
            return _commands.Post(ActiveUser, vendContact);
        }

        /// <summary>
        /// Updates an existing vendcontact record
        /// </summary>
        /// <param name="vendContact"></param>
        /// <returns></returns>

        public VendContact Put(VendContact vendContact)
        {
            return _commands.Put(ActiveUser, vendContact);
        }

        /// <summary>
        /// Deletes a specific vendcontact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of vendcontact record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<VendContact> GetAllData()
        {
            throw new NotImplementedException();
        }

		public VendContact Patch(VendContact entity)
		{
			throw new NotImplementedException();
		}
	}
}