/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 IPrgBillableLocationCommands
Purpose:                                      Set of rules for IPrgBillableLocationCommands
=============================================================================================================*/
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Program
{
    public interface IPrgBillableLocationCommands : IBaseCommands<PrgBillableLocation>
    {
        IList<TreeModel> BillableLocationTree(long orgId, bool isAssignedBillableLocation, long programId, long? parentId, bool isChild);
        bool MapVendorBillableLocations(ActiveUser activeUser, ProgramVendorMap programVendorMap);
    }
}
