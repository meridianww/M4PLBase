/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IValidationCommands
Purpose:                                      Set of rules for ValidationCommands
=============================================================================================================*/

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// performs basic CRUD operation on the Validation Entity
    /// </summary>
    public interface IValidationCommands : IBaseCommands<Validation>
    {
    }
}