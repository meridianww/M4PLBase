/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgMvocRefQuestionCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgMvocRefQuestionCommands
===================================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgMvocRefQuestionCommands;
using System;

namespace M4PL.Business.Program
{
    public class PrgMvocRefQuestionCommands : BaseCommands<PrgMvocRefQuestion>, IPrgMvocRefQuestionCommands
    {
        /// <summary>
        /// Gets list of prgmvocrefquestion data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgMvocRefQuestion> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgmvocrefquestion record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgMvocRefQuestion Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgmvocrefquestion record
        /// </summary>
        /// <param name="mvocRefQuestion"></param>
        /// <returns></returns>

        public PrgMvocRefQuestion Post(PrgMvocRefQuestion mvocRefQuestion)
        {
            return _commands.Post(ActiveUser, mvocRefQuestion);
        }

        /// <summary>
        /// Updates an existing prgmvocrefquestion record
        /// </summary>
        /// <param name="mvocRefQuestion"></param>
        /// <returns></returns>

        public PrgMvocRefQuestion Put(PrgMvocRefQuestion mvocRefQuestion)
        {
            return _commands.Put(ActiveUser, mvocRefQuestion);
        }

        /// <summary>
        /// Deletes a specific prgmvocrefquestion record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgmvocrefquestion record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<PrgMvocRefQuestion> Get()
        {
            throw new NotImplementedException();
        }

		public PrgMvocRefQuestion Patch(PrgMvocRefQuestion entity)
		{
			throw new NotImplementedException();
		}
	}
}