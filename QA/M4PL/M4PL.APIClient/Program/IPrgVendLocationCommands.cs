/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IPrgVendLocationCommands
Purpose:                                      Set of rules for PrgVendLocationCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgVendLocation Entity
    /// </summary>
    public interface IPrgVendLocationCommands : IBaseCommands<PrgVendLocationView>
    {
        IList<TreeModel> ProgramVendorTree(bool isAssignedprgVendor, long programId, long? parentId, bool isChild);

        bool MapVendorLocations(bool assign, long parentId, List<PrgVendLocationView> ids);

        bool MapVendorLocations(ProgramVendorMap programVendorMap);
    }
}