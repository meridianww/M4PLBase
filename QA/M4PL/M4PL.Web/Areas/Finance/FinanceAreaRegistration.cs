using System.Web.Mvc;

namespace M4PL.Web.Areas.Finance
{
    public class FinanceAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Finance";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Finance_default",
                "Finance/{controller}/{action}/{id}",
                new { MvcConstants.ActionIndex, id = UrlParameter.Optional }
            );
        }
    }
}