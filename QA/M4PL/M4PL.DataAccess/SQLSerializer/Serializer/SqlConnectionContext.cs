#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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