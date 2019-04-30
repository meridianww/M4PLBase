/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                IPageControl
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 IPageControl
//Purpose:                                      sets the rules for PageControl
//====================================================================================================================================================*/

using System.Web.Mvc;

namespace M4PL.Web.Interfaces
{
    public interface IPageControl
    {
        ActionResult TabViewCallBack(string strRoute);
    }
}