/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ConReportCommands
Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Contact.ConReportCommands
===================================================================================================================*/

using M4PL.Entities.Contact;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Contact.ConReportCommands;
using System;

namespace M4PL.Business.Contact
{
    public class ConReportCommands : BaseCommands<ConReport>, IConReportCommands
    {
        /// <summary>
        /// Get list of memu driver data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<ConReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific ConReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public ConReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new ConReport record
        /// </summary>
        /// <param name="conReport"></param>
        /// <returns></returns>

        public ConReport Post(ConReport conReport)
        {
            return _commands.Post(ActiveUser, conReport);
        }

        /// <summary>
        /// Updates an existing ConReport record
        /// </summary>
        /// <param name="conReport"></param>
        /// <returns></returns>

        public ConReport Put(ConReport conReport)
        {
            return _commands.Put(ActiveUser, conReport);
        }

        /// <summary>
        /// Deletes a specific ConReport record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of ConReport record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<ConReport> Get()
        {
            throw new NotImplementedException();
        }

		public ConReport Patch(ConReport entity)
		{
			throw new NotImplementedException();
		}
	}
}