/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ICustDcLocationCommands
Purpose:                                      Set of rules for CustDcLocationCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Customer;

namespace M4PL.APIClient.Customer
{
    /// <summary>
    /// Performs basic CRUD operation on the CustDcLocation Entity
    /// </summary>
    public interface ICustDcLocationCommands : IBaseCommands<CustDcLocationView>
    {
    }
}