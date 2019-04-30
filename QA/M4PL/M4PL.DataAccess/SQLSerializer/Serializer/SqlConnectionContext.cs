//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 SqlConnectionContext
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;
using System.Data.SqlClient;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    internal class SqlConnectionContext : IDisposable
    {
        private readonly SqlCommand _command;
        private readonly SqlConnection _connection;
        private readonly Parameter[] _parameters;

        internal SqlConnectionContext(SqlConnection connection, SqlCommand command, Parameter[] parameters)
        {
            _connection = connection;
            _command = command;
            _parameters = parameters;
        }

        public void Dispose()
        {
            _connection.Close();
        }
    }
}