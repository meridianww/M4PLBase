﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                ITreeControl
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 ITreeControl
//Purpose:                                      sets the rules for TreeControl
//====================================================================================================================================================*/

using System.Web.Mvc;

namespace M4PL.Web.Interfaces
{
    internal interface ITreeControl
    {
        #region TreeView

        ActionResult TreeCallback(string nodes = null, string selectedNode = null);

        ActionResult TreeView();

        #endregion TreeView
    }
}