/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 FilterConfig
Purpose:                                      Contains the Configuration related to Filter
==========================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }

        //public class HandleErrorAttributeEx : HandleErrorAttribute
        //{
        //    public HandleErrorAttributeEx() : base() { }
        //    public override void OnException(ExceptionContext filterContext)
        //    {
        //        base.OnException(filterContext);
        //        filterContext.ExceptionHandled = false;
        //    }
        //}
    }
}