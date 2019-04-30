/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                ITreeControl
//Programmer:                                   Akhil
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