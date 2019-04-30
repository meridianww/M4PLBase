using System.ServiceProcess;
using System.Web.Http;
using System.Web.Http.SelfHost;

namespace M4PL_Executor
{
    public partial class M4PL_Executor : ServiceBase
    {
        public M4PL_Executor()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            var config = new HttpSelfHostConfiguration("http://localhost:56147");

            config.EnableCors();

            config.Routes.MapHttpRoute(
               name: "API",
               routeTemplate: "{controller}/{action}/{id}",
               defaults: new { id = RouteParameter.Optional }
           );

            HttpSelfHostServer server = new HttpSelfHostServer(config);
            server.OpenAsync().Wait();
        }

        protected override void OnStop()
        {
        }
    }
}
