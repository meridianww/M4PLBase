#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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