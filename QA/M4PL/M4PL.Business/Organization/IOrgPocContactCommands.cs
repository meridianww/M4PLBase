/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IOrgPocContactCommands
Purpose:                                      Set of rules for OrgPocContactCommands
=============================================================================================================*/

using M4PL.Entities.Organization;

namespace M4PL.Business.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgPocContact Entity
    /// </summary>
    public interface IOrgPocContactCommands : IBaseCommands<OrgPocContact>
    {
    }
}