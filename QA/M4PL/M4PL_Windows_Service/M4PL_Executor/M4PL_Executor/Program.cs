using System.ServiceProcess;

namespace M4PL_Executor
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new M4PL_Executor()
            };
            ServiceBase.Run(ServicesToRun);
        }
    }
}
