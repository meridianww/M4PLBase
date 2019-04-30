using Microsoft.Win32;
using System.Collections.Generic;
using System.Linq;

namespace M4PL_Executor
{
    public class CheckAppRegistry
    {
        public enum ProgramVersion
        {
            x86,
            x64
        }

        private static IEnumerable<string> GetRegisterSubkeys(RegistryKey registryKey)
        {
            return registryKey.GetSubKeyNames()
                    .Select(registryKey.OpenSubKey)
                    .Select(subkey => subkey.GetValue("DisplayName") as string);
        }

        private static bool CheckNode(RegistryKey registryKey, string applicationName, ProgramVersion? programVersion)
        {
            return GetRegisterSubkeys(registryKey).Any(displayName => displayName != null
                                                                      && displayName.Contains(applicationName)
                                                                      && displayName.Contains(programVersion.ToString()));
        }

        private static bool CheckApplication(string registryKey, string applicationName, ProgramVersion? programVersion)
        {
            RegistryKey key = Registry.LocalMachine.OpenSubKey(registryKey);

            if (key != null)
            {
                if (CheckNode(key, applicationName, programVersion))
                    return true;

                key.Close();
            }

            return false;
        }

        public static bool IsSoftwareInstalled(string applicationName, ProgramVersion? programVersion)
        {
            string[] registryKey = new[] {
            @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            @"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        };

            return registryKey.Any(key => CheckApplication(key, applicationName, programVersion));
        }
    }
}
