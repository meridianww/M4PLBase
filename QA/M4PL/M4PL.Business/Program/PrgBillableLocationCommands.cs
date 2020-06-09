/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgBillableLocationCommands
Purpose:                                      Contains commands to call DAL logic
=============================================================================================================*/
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgBillableLocationCommands;

namespace M4PL.Business.Program
{
    public class PrgBillableLocationCommands : BaseCommands<PrgBillableLocation>, IPrgBillableLocationCommands
    {
        /// <summary>
        /// Gets list of prgBillableLocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgBillableLocation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgBillableLocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgBillableLocation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgBillableLocation record
        /// </summary>
        /// <param name="prgBillableLocation"></param>
        /// <returns></returns>

        public PrgBillableLocation Post(PrgBillableLocation prgBillableLocation)
        {
            return _commands.Post(ActiveUser, prgBillableLocation);
        }

        /// <summary>
        /// Updates an existing prgBillableLocation record
        /// </summary>
        /// <param name="prgBillableLocation"></param>
        /// <returns></returns>

        public PrgBillableLocation Put(PrgBillableLocation prgBillableLocation)
        {
            return _commands.Put(ActiveUser, prgBillableLocation);
        }

        /// <summary>
        /// Deletes a specific prgBillableLocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of prgBillableLocation record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public IList<TreeModel> BillableLocationTree(long orgId, bool isAssignedBillableLocation, long programId, long? parentId, bool isChild)
        {
            return _commands.BillableLocationTree(orgId, isAssignedBillableLocation, programId, parentId, isChild);
        }
        public bool MapVendorBillableLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
        {
            return _commands.MapVendorBillableLocations(activeUser, programVendorMap);
        }
        public PrgBillableLocation Patch(PrgBillableLocation entity)
        {
            throw new NotImplementedException();
        }
    }
}
