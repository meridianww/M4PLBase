
/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 IPrgBillableLocationCommands
Purpose:                                      Set of rules for IPrgBillableLocationCommands
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Program;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
    public interface IPrgBillableLocationCommands : IBaseCommands<PrgBillableLocationView>
    {
        IList<TreeModel> BillableLocationTree(bool isAssignedBillableLocation, long programId, long? parentId, bool isChild);
        bool MapVendorPriceLocations(bool assign, long parentId, List<PrgCostLocationView> ids);
        bool MapVendorBillableLocations(ProgramVendorMap programVendorMap);
    }
}
