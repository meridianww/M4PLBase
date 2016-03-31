//------------------------------------------------------------------------------ 
// <copyright file="DataSource.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Configuration;

namespace M4PL.DataAccess.Factory.Common
{
    /// <summary>
    ///		This class implements methods related to database connections.
    ///		It is singleton class
    /// </summary>
    public class DataSource
    {
        #region Singleton

        /// <summary>
        ///		Creating the instance of the DataSource. This is called creating a singleton class
        /// </summary>
        public static readonly DataSource Instance = new DataSource();

        #endregion

        #region Constants

        #region String Constants

        /// <summary>
        ///     Constant used for connection string
        /// </summary>
        private const string CONNECTION_STRING = "Connection";

        #endregion

        #region int Constants

        /// <summary>
        ///     for successful new password setting in database
        /// </summary>
        private const int SUCCESS = 0;

        #endregion

        #endregion

        #region Constructor

        /// <summary>
        ///		Default constructor of class
        /// </summary>
        private DataSource()
        {
        }

        #endregion

        #region Functions to Get the Connection String

        /// <summary>
        ///		Function called to get the connection string for the server to which the application is connected.
        /// </summary>
        /// <returns>
        ///		Connection string for creating new database connection
        /// </returns>
        public string GetConnectionString()
        {
            string connectionString;
            connectionString = ConfigurationManager.ConnectionStrings["BuildTrailConnection"].ConnectionString;
                //Propanator.Common.Utils.SecureString.Decrypt(ConfigurationManager.ConnectionStrings[ConfigKeys.DATABASE_CONNECTION].ConnectionString);
            // returns the connection string
            return connectionString;
        }

        /// <summary>
        /// Function called to get the connection string for the file upload
        /// </summary>
        /// <returns>Connection string</returns>
        public string GetConnectionString(string sourceFile, string FolderPath, string fileextn)
        {
            string strConn;

            try
            {
                if (fileextn == ".csv")
                {
                    //connection string for CSV files
                    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="
                        + FolderPath + ";Extended Properties=\"text;HDR=Yes;FMT=Delimited\"";
                }
                else
                {
                    //connection string for excel files
                    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="
                        + FolderPath + sourceFile + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=1;\"";
                }
            }
            catch (Exception ex)
            {
                throw new ApplicationException("", ex);
            }

            // returns the connection string
            return strConn;
        }

        #endregion
    }
}
