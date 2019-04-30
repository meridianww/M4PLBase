//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              06/06/2018
//Program Name:                                 DeliveryStatusCommands
//Purpose:                                      Client to consume M4PL API called DeliveryStatusesController
//===================================================================================================================

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Route to call column alias
    /// </summary>
    public class StatusLogCommands : BaseCommands<StatusLogView>,
        IStatusLogCommands
    {
        public override string RouteSuffix
        {
            get { return "StatusLogs"; }
        }
    }
}