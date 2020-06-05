/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              11/11/2017
Program Name:                                 AttachmentCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DataAccess.Attachment.AttachmentCommands;
===================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Attachment.AttachmentCommands;
using M4PL.Entities;
using System;

namespace M4PL.Business.Attachment
{
    public class AttachmentCommands : BaseCommands<Entities.Attachment>, IAttachmentCommands
    {
        /// <summary>
        /// Get list of contacts data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Attachment> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific contact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Attachment Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public List<Entities.Attachment> GetAttachmentsByJobId(long jobId)
        {
            return _commands.GetAttachmentsByJobId(ActiveUser, jobId); 
        }

        /// <summary>
        /// Creates a new contact record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Attachment Post(Entities.Attachment contact)
        {
            return _commands.Post(ActiveUser, contact);
        }

        /// <summary>
        /// Updates an existing contact record
        /// </summary>
        /// <param name="contact"></param>
        /// <returns></returns>

        public Entities.Attachment Put(Entities.Attachment contact)
        {
            return _commands.Put(ActiveUser, contact);
        }

        /// <summary>
        /// Deletes a specific contact record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of contacts records
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<IdRefLangName> DeleteAndUpdateAttachmentCount(List<long> ids, int statusId, string parentTable, string fieldName)
        {
            return _commands.DeleteAndUpdateAttachmentCount(ActiveUser, ids, statusId, parentTable, fieldName);
        }

		public Entities.Attachment Patch(Entities.Attachment entity)
		{
			throw new NotImplementedException();
		}
	}
}