#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/11/2019
// Program Name:                                 ICompanyAddressCommands
// Purpose:                                      Set of rules for CompanyAddressCommands
//====================================================================================================================================================

using M4PL.APIClient.ViewModels.CompanyAddress;

namespace M4PL.APIClient.CompanyAddress
{
    /// <summary>
    /// Performs basic CRUD operation on the Company Address Entity
    /// </summary>
    public interface ICompanyAddressCommands : IBaseCommands<CompanyAddressView>
    {
    }
}
