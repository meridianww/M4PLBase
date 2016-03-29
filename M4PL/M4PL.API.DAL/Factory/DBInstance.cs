//------------------------------------------------------------------------------ 
// <copyright file="DBInstance.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Collections.Generic;
using System.Text;

using Manthan.Depo.Common.Constants.DataAcecess;
using Manthan.Depo.Framework.DataAccess.Factory;

namespace Manthan.Depo.Framework.DataAccess
{
    public class DBInstance
    {
        #region Static Member Variables

        // Static instance of the SqlFrameworkDataAccessFactory class
        private static FrameworkDataAccessFactory currentInstance;

        #endregion

        #region Private Constructor

        private DBInstance()
        {
        }

        #endregion

        #region Static Methods

        /// <summary>
        ///		Get or set current instance of framework data access factory
        /// </summary>
        public static FrameworkDataAccessFactory CurrentInstance
        {
            get
            {
                if (currentInstance == null)
                {
                    switch (ConfigKeys.DATABASETYPE)
                    {
                        case (int)ConfigKeys.DatabaseType.SqlServer:
                            currentInstance = new SqlFrameworkDataAccessFactory();
                            break;


                    }
                }
                return currentInstance;
            }
            set { currentInstance = value; }
        }

        #endregion
    }
}
