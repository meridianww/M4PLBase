using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Transactions;


namespace M4PL.DataAccess.Serializer
{
    internal class SqlConnectionContext : IDisposable
    {
        private readonly SqlConnection _connection;
        private readonly SqlCommand _command;
        private readonly TransactionScope _innerTransactionScope;
        private readonly bool _auditCodeAppended;
        private readonly Parameter[] _parameters;

        internal SqlConnectionContext(SqlConnection connection, SqlCommand command, Parameter[] parameters)
        {
            this._connection = connection;
            this._command = command;
            this._parameters = parameters;
        }

        public void Dispose()
        {            
            this._connection.Close();
        }
    }
}
