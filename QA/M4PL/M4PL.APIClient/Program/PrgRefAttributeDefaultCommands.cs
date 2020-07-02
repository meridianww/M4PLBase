﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 PrgRefAttributeDefaultCommands
// Purpose:                                      Client to consume M4PL API called PrgRefAttributeDefaultController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgRefAttributeDefaultCommands : BaseCommands<PrgRefAttributeDefaultView>, IPrgRefAttributeDefaultCommands
    {
        /// <summary>
        /// Route to call PrgRefAttributeDefaults
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgRefAttributeDefaults"; }
        }
    }
}