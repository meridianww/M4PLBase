/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustDcLocationCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustDcLocationCommands
===================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustDcLocationCommands;
using System;

namespace M4PL.Business.Customer
{
    public class CustDcLocationCommands : BaseCommands<CustDcLocation>, ICustDcLocationCommands
    {
        /// <summary>
        /// Get list of customer dclocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustDcLocation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific customer dclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustDcLocation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new customer dclocation record
        /// </summary>
        /// <param name="custDcLocation"></param>
        /// <returns></returns>

        public CustDcLocation Post(CustDcLocation custDcLocation)
        {
            return _commands.Post(ActiveUser, custDcLocation);
        }

        /// <summary>
        /// Updates an existing customer dclocation record
        /// </summary>
        /// <param name="custDcLocation"></param>
        /// <returns></returns>

        public CustDcLocation Put(CustDcLocation custDcLocation)
        {
            return _commands.Put(ActiveUser, custDcLocation);
        }

        /// <summary>
        /// Deletes a specific customer dclocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of customer dclocation record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

		public CustDcLocation Patch(CustDcLocation entity)
		{
			throw new NotImplementedException();
		}
	}
}