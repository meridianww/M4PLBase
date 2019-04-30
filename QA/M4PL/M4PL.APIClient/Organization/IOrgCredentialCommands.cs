﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IOrgCredentialCommands
Purpose:                                      Set of rules for OrgCredentialCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgCredential Entity
    /// </summary>
    public interface IOrgCredentialCommands : IBaseCommands<OrgCredentialView>
    {
    }
}