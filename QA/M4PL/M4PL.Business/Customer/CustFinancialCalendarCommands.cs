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
// Program Name:                                 CustFinancialCalendarCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustFinancialCalendarCommands
//====================================================================================================================

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustFinancialCalendarCommands;

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

        public CustFinancialCalendar Patch(CustFinancialCalendar entity)
        {
            throw new NotImplementedException();
        }
    }
}