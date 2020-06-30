/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IOrganizationCommands
Purpose:                                      Set of rules for OrganizationCommands
=============================================================================================================*/

namespace M4PL.Business.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the Organization Entity
    /// </summary>
    public interface IOrganizationCommands : IBaseCommands<Entities.Organization.Organization>
    {
    }
}