/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IPrgEdiMappingCommands
Purpose:                                      Set of rules for PrgEdiMappingCommands
=============================================================================================================*/

using M4PL.Entities.Program;

namespace M4PL.Business.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the PrgEdiMappings Entity
    /// </summary>
    public interface IPrgEdiMappingCommands : IBaseCommands<PrgEdiMapping>
    {
    }
}