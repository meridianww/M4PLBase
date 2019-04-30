/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              06/06/2018
Program Name:                                 IDeliveryStatusCommands
Purpose:                                      Set of rules for DeliveryStatusCommands
=============================================================================================================*/

using M4PL.Entities.Administration;

namespace M4PL.Business.Administration
{
    /// <summary>
    /// Performs basic CRUD operation on the Delivery Status Entity
    /// </summary>
    public interface IDeliveryStatusCommands : IBaseCommands<DeliveryStatus>
    {
    }
}