/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustReportCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustReportCommands
===================================================================================================================*/
using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustReportCommands;

namespace M4PL.Business.Customer
{
    public class CustReportCommands : BaseCommands<CustReport>, ICustReportCommands
    {
        /// <summary>
        /// Get list of memu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific custReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new custReport record
        /// </summary>
        /// <param name="custReport"></param>
        /// <returns></returns>

        public CustReport Post(CustReport custReport)
        {
            return _commands.Post(ActiveUser, custReport);
        }

        /// <summary>
        /// Updates an existing custReport record
        /// </summary>
        /// <param name="custReport"></param>
        /// <returns></returns>

        public CustReport Put(CustReport custReport)
        {
            return _commands.Put(ActiveUser, custReport);
        }

        /// <summary>
        /// Deletes a specific custReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of custReport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }
    }
}