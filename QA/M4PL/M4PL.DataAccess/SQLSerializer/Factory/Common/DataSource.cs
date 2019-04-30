//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 DataSource
//Purpose:                                      Represents the data source for a Rule property.
//====================================================================================================================================================

using System;
using System.Configuration;

namespace M4PL.DataAccess.SQLSerializer.Factory.Common
{
    /// <summary>
    ///     This class implements methods related to database connections.
    ///     It is singleton class
    /// </summary>
    public class DataSource
    {
        #region Singleton

        /// <summary>
        ///     Creating the instance of the DataSource. This is called creating a singleton class
        /// </summary>
        public static readonly DataSource Instance = new DataSource();

        #endregion Singleton

        #region Constructor

        /// <summary>
        ///     Default constructor of class
        /// </summary>
        private DataSource()
        {
        }

        #endregion Constructor

        #region Constants

        #region String Constants

        /// <summary>
        ///     Constant used for connection string
        /// </summary>
        private const string CONNECTION_STRING = "Connection";

        #endregion String Constants

        #region int Constants

        /// <summary>
        ///     for successful new password setting in database
        /// </summary>
        private const int SUCCESS = 0;

        #endregion int Constants

        #endregion Constants

        #region Functions to Get the Connection String

        /// <summary>
        ///     Function called to get the connection string for the server to which the application is connected.
        /// </summary>
        /// <returns>
        ///     Connection string for creating new database connection
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
        ///     Function called to get the connection string for the file upload
        /// </summary>
        /// <returns>Connection string</returns>
        public string GetConnectionString(string sourceFile, string FolderPath, string fileextn)
        {
            string strConn;

            try
            {
                if (fileextn == ".csv")
                    strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="
                              + FolderPath + ";Extended Properties=\"text;HDR=Yes;FMT=Delimited\"";
                else
                    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="
                              + FolderPath + sourceFile + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=1;\"";
            }
            catch (Exception ex)
            {
                throw new ApplicationException(string.Empty, ex);
            }

            // returns the connection string
            return strConn;
        }

        #endregion Functions to Get the Connection String
    }
}