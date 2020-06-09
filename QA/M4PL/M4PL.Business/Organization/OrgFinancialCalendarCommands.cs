/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like MenuDriverCommands
Purpose:                                      Contains commands to call DAL logic for {Namespace:Class name} like M4PL.DAL.Administration.MenuDriverCommands
===================================================================================================================*/

using M4PL.Entities.Organization;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Organization.OrgFinancialCalendarCommands;

namespace M4PL.Business.Organization
{
    public class OrgFinancialCalendarCommands : BaseCommands<OrgFinancialCalendar>, IOrgFinancialCalendarCommands
    {
        /// <summary>
        /// Gets list of orgfinancialcalendar data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<OrgFinancialCalendar> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific orgfinancialcalendar record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public OrgFinancialCalendar Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new orgfinancialcalendar record
        /// </summary>
        /// <param name="orgFinancialCalendar"></param>
        /// <returns></returns>

        public OrgFinancialCalendar Post(OrgFinancialCalendar orgFinancialCalendar)
        {
            return _commands.Post(ActiveUser, orgFinancialCalendar);
        }

        /// <summary>
        /// Updates an existing orgfinancialcalendar record
        /// </summary>
        /// <param name="orgFinancialCalendar"></param>
        /// <returns></returns>

        public OrgFinancialCalendar Put(OrgFinancialCalendar orgFinancialCalendar)
        {
            return _commands.Put(ActiveUser, orgFinancialCalendar);
        }

        /// <summary>
        /// Deletes a specific orgfinancialcalendar record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of orgfinancialcalendar record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public OrgFinancialCalendar Patch(OrgFinancialCalendar entity)
        {
            throw new NotImplementedException();
        }
    }
}