/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ProgramCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.ProgramCommands
===================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.ProgramCommands;

namespace M4PL.Business.Program
{
    public class ProgramCommands : BaseCommands<Entities.Program.Program>, IProgramCommands
    {
        /// <summary>
        /// Gets list of program data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<Entities.Program.Program> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific program record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public Entities.Program.Program Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new program record
        /// </summary>
        /// <param name="program"></param>
        /// <returns></returns>

        public Entities.Program.Program Post(Entities.Program.Program program)
        {
            if (program.PrgOrgID == 0)
                program.PrgOrgID = ActiveUser.OrganizationId;
            return _commands.Post(ActiveUser, program);
        }

        /// <summary>
        /// Updates an existing program record
        /// </summary>
        /// <param name="program"></param>
        /// <returns></returns>

        public Entities.Program.Program Put(Entities.Program.Program program)
        {
            if (program.PrgOrgID == 0)
                program.PrgOrgID = ActiveUser.OrganizationId;
            return _commands.Put(ActiveUser, program);
        }

        /// <summary>
        /// Deletes a specific program record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of program record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        //public IList<TreeModel> ProgramTree(long orgId, long? parentId, string model)
        //{
        //    return _commands.GetProgramTree(orgId, parentId, model);
        //}

        public IList<TreeModel> ProgramTree(ActiveUser activeuser, long orgId, long? parentId, bool isCustNode)
        {
            return _commands.GetProgramTree(activeuser, orgId, parentId, isCustNode);
        }

        public Entities.Program.Program GetProgram(ActiveUser activeuser, long id, long? parentId)
        {
            return _commands.Get(activeuser, id, parentId);
        }

        public IList<TreeModel> ProgramCopyTree(ActiveUser activeuser, long programId, long? parentId, bool isCustNode, bool isSource)
        {
            return _commands.GetProgramCopyTree(activeuser, programId, parentId, isCustNode, isSource);
        }

        public async System.Threading.Tasks.Task<bool> CopyPPPModel(CopyPPPModel copyPPPMopdel, ActiveUser activeUser)
        {
            return await _commands.CopyPPPModel(copyPPPMopdel, activeUser);
        }

        public Entities.Program.Program Patch(Entities.Program.Program entity)
        {
            throw new NotImplementedException();
        }

        public List<Entities.Program.Program> GetProgramsByCustomer(long custId)
        {
            return _commands.GetProgramsByCustomer(custId);

        }

    }
}