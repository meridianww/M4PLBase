using Microsoft.Win32;
using System.ComponentModel;
using System.Configuration.Install;
using System.ServiceProcess;

namespace M4PL_Executor
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : System.Configuration.Install.Installer
    {
        public ProjectInstaller()
        {
            InitializeComponent();
        }

        private void serviceInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {
            // Here is where we set the bit on the value in the registry.
            // Grab the subkey to our service
            RegistryKey ckey = Registry.LocalMachine.OpenSubKey(@"SYSTEM\CurrentControlSet\Services\" + serviceInstaller1.ServiceName, true);
            // Good to always do error checking!
            if (ckey != null)
            {
                // Ok now lets make sure the "Type" value is there,and then do our bitwise operation on it.
                if (ckey.GetValue("Type") != null)
                {
                    ckey.SetValue("Type", ((int)ckey.GetValue("Type") | 256));
                }
            }

            new ServiceController(serviceInstaller1.ServiceName).Start();
        }
    }
}
