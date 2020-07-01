/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgVendLocationComments
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Program.PrgVendLocationCommands
===================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgVendLocationComments;

namespace M4PL.Business.Program
{
    public class PrgVendLocationCommands : BaseCommands<PrgVendLocation>, IPrgVendLocationCommands
    {
        /// <summary>
        /// Gets list of prgvendlocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgVendLocation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgvendlocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgVendLocation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgvendlocation record
        /// </summary>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public PrgVendLocation Post(PrgVendLocation prgVendLocation)
        {
            return _commands.Post(ActiveUser, prgVendLocation);
        }

        /// <summary>
        /// Updates an existing prgvendlocation record
        /// </summary>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public PrgVendLocation Put(PrgVendLocation prgVendLocation)
        {
            return _commands.Put(ActiveUser, prgVendLocation);
        }

        /// <summary>
        /// Deletes a specific prgvendlocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgvendlocation record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<TreeModel> ProgramVendorTree(ActiveUser activeUser, long orgId, bool isAssignedPrgVendor, long programId, long? parentId, bool isChild)
        {
            return _commands.ProgramVendorTree(activeUser, orgId, isAssignedPrgVendor, programId, parentId, isChild);
        }

        public bool MapVendorLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
        {
            return _commands.MapVendorLocations(activeUser, programVendorMap);
        }

        public PrgVendLocation Patch(PrgVendLocation entity)
        {
            throw new NotImplementedException();
        }
    }
}