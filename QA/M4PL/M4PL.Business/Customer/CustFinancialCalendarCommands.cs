/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustFinancialCalendarCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustFinancialCalendarCommands
===================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustFinancialCalendarCommands;
using System;

namespace M4PL.Business.Customer
{
    public class CustFinancialCalendarCommands : BaseCommands<CustFinancialCalendar>, ICustFinancialCalendarCommands
    {
        /// <summary>
        /// Get list of customer financial calender data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustFinancialCalendar> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific  customer financial calender record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustFinancialCalendar Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new  customer financial calender record
        /// </summary>
        /// <param name="custFinancialCalendar"></param>
        /// <returns></returns>

        public CustFinancialCalendar Post(CustFinancialCalendar custFinancialCalendar)
        {
            return _commands.Post(ActiveUser, custFinancialCalendar);
        }

        /// <summary>
        /// Updates an existing customer financial calender record
        /// </summary>
        /// <param name="custFinancialCalendar"></param>
        /// <returns></returns>

        public CustFinancialCalendar Put(CustFinancialCalendar custFinancialCalendar)
        {
            return _commands.Put(ActiveUser, custFinancialCalendar);
        }

        /// <summary>
        /// Deletes a specific customer financial calender record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of customer financial calender record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<CustFinancialCalendar> Get()
        {
            throw new NotImplementedException();
        }
    }
}