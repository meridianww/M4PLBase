/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 VendFinancialCalendarCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Vendor.VendFinancialCalendar
===================================================================================================================*/

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Vendor.VendFinancialCalendarCommands;

namespace M4PL.Business.Vendor
{
    public class VendFinancialCalendarCommands : BaseCommands<VendFinancialCalendar>, IVendFinancialCalendarCommands
    {
        /// <summary>
        /// Gets list of vendfinancialcalendar data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<VendFinancialCalendar> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific vendfinancialcalendar record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public VendFinancialCalendar Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new vendfinancialcalendar record
        /// </summary>
        /// <param name="vendFinancialCalendar"></param>
        /// <returns></returns>

        public VendFinancialCalendar Post(VendFinancialCalendar vendFinancialCalendar)
        {
            return _commands.Post(ActiveUser, vendFinancialCalendar);
        }

        /// <summary>
        /// Updates an existing vendfinancialcalendar record
        /// </summary>
        /// <param name="vendFinancialCalendar"></param>
        /// <returns></returns>

        public VendFinancialCalendar Put(VendFinancialCalendar vendFinancialCalendar)
        {
            return _commands.Put(ActiveUser, vendFinancialCalendar);
        }

        /// <summary>
        /// Deletes a specific vendfinancialcalendar record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of vendfinancialcalendar record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public VendFinancialCalendar Patch(VendFinancialCalendar entity)
        {
            throw new NotImplementedException();
        }
    }
}