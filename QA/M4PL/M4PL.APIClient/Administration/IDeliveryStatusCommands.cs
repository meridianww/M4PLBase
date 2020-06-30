/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              06/06/2018
Program Name:                                 IDeliveryStatusCommands
Purpose:                                      Set of rules for DeliveryStatusCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the DeliveryStatusView Entity
    /// </summary>
    public interface IDeliveryStatusCommands : IBaseCommands<DeliveryStatusView>
    {
    }
}