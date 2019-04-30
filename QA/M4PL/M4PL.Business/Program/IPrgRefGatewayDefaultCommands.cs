/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IPrgRefGatewayDefaultCommands
Purpose:                                      Set of rules for PrgRefGatewayDefaultCommands
=============================================================================================================*/

using M4PL.Entities.Program;
using M4PL.Entities.Support;

namespace M4PL.Business.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgRefGatewayDefault Entity
    /// </summary>
    public interface IPrgRefGatewayDefaultCommands : IBaseCommands<PrgRefGatewayDefault>
    {
        PrgRefGatewayDefault PutWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault);
        PrgRefGatewayDefault PostWithSettings(SysSetting userSysSetting, PrgRefGatewayDefault prgRefGatewayDefault);
    }
}