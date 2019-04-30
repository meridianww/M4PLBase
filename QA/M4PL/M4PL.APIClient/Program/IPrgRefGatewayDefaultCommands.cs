/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IPrgRefGatewayDefaultCommands
Purpose:                                      Set of rules for PrgRefGatewayDefaultCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Program;
using System.Collections.Generic;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgRefGatewayDefault Entity
    /// </summary>
    public interface IPrgRefGatewayDefaultCommands : IBaseCommands<PrgRefGatewayDefaultView>
    {
        IList<Entities.TreeModel> ProgramGatewayTree(long programId);
        PrgRefGatewayDefaultView PutWithSettings(PrgRefGatewayDefaultView prgRefGatewayDefaultView);
        PrgRefGatewayDefaultView PostWithSettings(PrgRefGatewayDefaultView prgRefGatewayDefaultView);
    }
}