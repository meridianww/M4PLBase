/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   KIRTY ANURAG
//Date Programmed:                              13/05/2020
//====================================================================================================================================================*/
using System;

namespace M4PL.Utilities
{
    /// <summary>
    /// Single object creation/initialization
    /// </summary>
    public sealed class SingleInstance
    {
        private SingleInstance()
        { }

        private static SingleInstance Instance = null;
        public static string BundleConfigKey = string.Empty;

        public static SingleInstance GetInstance
        {
            get
            {
                if (Instance == null)
                {
                    BundleConfigKey = Guid.NewGuid().ToString();
                }
                return Instance;
            }
        }
    }
}
