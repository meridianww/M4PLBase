/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustDocReferenceCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustDocReferenceCommands
===================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustDocReferenceCommands;

namespace M4PL.Business.Customer
{
    public class CustDocReferenceCommands : BaseCommands<CustDocReference>, ICustDocReferenceCommands
    {
        /// <summary>
        /// Get list of customer document reference data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustDocReference> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific customer document reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustDocReference Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new customer document reference record
        /// </summary>
        /// <param name="customerDocumentReference"></param>
        /// <returns></returns>

        public CustDocReference Post(CustDocReference customerDocumentReference)
        {
            return _commands.Post(ActiveUser, customerDocumentReference);
        }

        /// <summary>
        /// Updates an existingcustomer document reference record
        /// </summary>
        /// <param name="customerDocumentReference"></param>
        /// <returns></returns>

        public CustDocReference Put(CustDocReference customerDocumentReference)
        {
            return _commands.Put(ActiveUser, customerDocumentReference);
        }

        /// <summary>
        /// Deletes a specific customer document reference record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of customer document reference record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public CustDocReference Patch(CustDocReference entity)
        {
            throw new NotImplementedException();
        }
    }
}