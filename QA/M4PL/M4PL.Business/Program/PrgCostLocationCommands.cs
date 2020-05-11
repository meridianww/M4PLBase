/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgCostLocationCommands
Purpose:                                      Contains commands to call DAL logic
=============================================================================================================*/
using M4PL.Entities.Program;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Program.PrgCostLocationCommands;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;
using M4PL.Entities;

namespace M4PL.Business.Program
{
   public class PrgCostLocationCommands : BaseCommands<PrgCostLocation>,IPrgCostLocationCommands
    {
        /// <summary>
        /// Gets list of prgvendlocation data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<PrgCostLocation> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific prgvendlocation record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public PrgCostLocation Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new prgvendlocation record
        /// </summary>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public PrgCostLocation Post(PrgCostLocation prgVendLocation)
        {
            return _commands.Post(ActiveUser, prgVendLocation);
        }

        /// <summary>
        /// Updates an existing prgvendlocation record
        /// </summary>
        /// <param name="prgVendLocation"></param>
        /// <returns></returns>

        public PrgCostLocation Put(PrgCostLocation prgVendLocation)
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

     
        public IList<PrgCostLocation> GetAllData()
        {
            throw new NotImplementedException();
        }

        public IList<TreeModel> CostLocationTree(long orgId, bool isAssignedCostLocation, long programId, long? parentId, bool isChild)
        {
            return _commands.CostLocationTree(orgId, isAssignedCostLocation, programId, parentId, isChild);
        }

		public bool MapVendorCostLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap)
		{
			return _commands.MapVendorCostLocations(activeUser, programVendorMap);
		}

		public PrgCostLocation Patch(PrgCostLocation entity)
		{
			throw new NotImplementedException();
		}

    }
}
