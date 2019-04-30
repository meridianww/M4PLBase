/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ISystemMessageCommands
Purpose:                                      Set of rules for SystemMessageCommands
=============================================================================================================*/

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// Perfomrs delete operation based on the system message code
    /// Gets system message based on the system message code
    /// </summary>
    public interface ISystemMessageCommands : IBaseCommands<SystemMessage>
    {
        SystemMessage GetBySysMessageCode(string sysMsgCode);

        SystemMessage DeleteBySysMessageCode(string sysMsgCode);
    }
}