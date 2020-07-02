#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              11/13/2019
// Program Name:                                 INavOrderItemCommands
// Purpose:                                      Set of rules for INavOrderItemCommands
//================================================================================================================
using M4PL.Entities.Finance.OrderItem;

namespace M4PL.Business.Finance.OrderItem
{
    public interface INavOrderItemCommands : IBaseCommands<NAVOrderItemResponse>
    {
    }
}
