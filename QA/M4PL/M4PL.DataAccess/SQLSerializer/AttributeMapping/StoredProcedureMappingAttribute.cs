#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
	/// <summary>
	///     Attribute used to map model classes to database stored procedures.
	///     This attribute can only be applied to classes. All the properties of this class are read only.
	/// </summary>
	[AttributeUsage(AttributeTargets.Class)]
	public class StoredProcedureMappingAttribute : Attribute
	{
		#region Member varaibles

		/// <summary>
		///     name of stored procedure used to add new entries to database.
		/// </summary>
		private readonly string procedureName;

		/// <summary>
		///     indicating what type of procedure we are calling
		/// </summary>
		private readonly DBProcedureType procedureType;

		/// <summary>
		///     Name of table valued parameter used for multiple insertion
		/// </summary>
		private readonly string tableValuedParameterName;

		/// <summary>
		///     Name of table valued parameter type
		/// </summary>
		private readonly string tableValuedParameterType;

		#endregion Member varaibles

		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		/// <param name="procedureType">
		///     Type of stored procedure, like Select, select multiple, insert, update delete
		/// </param>
		public StoredProcedureMappingAttribute(string procedureName, DBProcedureType procedureType)
		{
			this.procedureName = procedureName;
			this.procedureType = procedureType;
		}

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		/// <param name="procedureType">
		///     Type of stored procedure, like Select, select multiple, insert, update delete
		/// </param>
		/// <param name="tableValuedType">
		///     Type of Table valued parameter used in stored procedure
		/// </param>
		/// <param name="tableValuedParameter">
		///     Name of table valued input parameter
		/// </param>
		public StoredProcedureMappingAttribute(
			string procedureName,
			DBProcedureType procedureType,
			string tableValuedType,
			string tableValuedParameter)
		{
			this.procedureName = procedureName;
			this.procedureType = procedureType;
			tableValuedParameterType = tableValuedType;
			tableValuedParameterName = tableValuedParameter;
		}

		#endregion Constructor

		#region Accessor Methods

		/// <summary>
		///     Gets the name of the database procedure used for insert statemenPropanator.
		///     Procedure name is used for insert and update statemenPropanator.
		/// </summary>
		public string ProcedureName
		{
			get { return procedureName; }
		}

		/// <summary>
		///     Gets a boolean value indicating whether current procedure is insert procedure or not.
		/// </summary>
		public DBProcedureType ProcedureType
		{
			get { return procedureType; }
		}

		/// <summary>
		///     Gets the type name of table valued parameter used in the procedure
		/// </summary>
		public string TableValuedParameterType
		{
			get { return tableValuedParameterType; }
		}

		/// <summary>
		///     Gets the name of table valued input parameter used in the procedure
		/// </summary>
		public string TableValuedParameterName
		{
			get { return tableValuedParameterName; }
		}

		#endregion Accessor Methods
	}

	/// <summary>
	///     Attribute used to map model classes to database stored procedures.
	///     This attribute can only be applied to classes.
	///     All the properties of this class are read only.
	/// </summary>
	public sealed class InsertProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		public InsertProcedureMappingAttribute(string procedureName) :
			base(procedureName, DBProcedureType.INSERT)
		{
		}

		#endregion Constructor
	}

	/// <summary>
	///     Attribute used to map model classes to insert multiple stored procedures.
	///     This attribute can only be applied to classes.
	///     All the properties of this class are read only.
	/// </summary>
	public sealed class InsertMultipleProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name and and type in base class.
		/// </summary>
		/// <param name="procedureName">
		///     Name of insert procedure name.
		/// </param>
		public InsertMultipleProcedureMappingAttribute(string procedureName) :
			base(procedureName, DBProcedureType.INSERT_MULTIPLE)
		{
		}

		/// <summary>
		///     Constructor, set stored procedure name and and type in base class.
		/// </summary>
		/// <param name="procedureName">
		///     Name of insert procedure name.
		/// </param>
		/// <param name="tableValuedType">
		///     Type of Table valued parameter used in stored procedure
		/// </param>
		/// <param name="tableValuedParameter">
		///     Name of table valued input parameter
		/// </param>
		public InsertMultipleProcedureMappingAttribute(
			string procedureName,
			string tableValuedType,
			string tableValuedParameter) :
			base(procedureName, DBProcedureType.INSERT_MULTIPLE, tableValuedType, tableValuedParameter)
		{
		}

		#endregion Constructor
	}

	/// <summary>
	///     Attribute used to map model classes to database stored procedures.
	///     This attribute can only be applied to classes.
	///     All the properties of this class are read only.
	/// </summary>
	public sealed class UpdateProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		public UpdateProcedureMappingAttribute(string procedureName)
			: base(procedureName, DBProcedureType.UPDATE)
		{
		}

		#endregion Constructor
	}

	/// <summary>
	///     Attribute used to map model classes to database stored procedures.
	///     This attribute can only be applied to classes.
	///     All the properties of this class are read only.
	/// </summary>
	public sealed class DeleteProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		public DeleteProcedureMappingAttribute(string procedureName) :
			base(procedureName, DBProcedureType.DELETE)
		{
		}

		#endregion Constructor
	}

	/// <summary>
	///     Attribute used to map model classes to database stored procedures.
	///     This attribute can only be applied to classes.
	///     All the properties of this class are read only.
	/// </summary>
	public sealed class SelectProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set stored procedure name
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		public SelectProcedureMappingAttribute(string procedureName) :
			base(procedureName, DBProcedureType.SELECT)
		{
		}

		#endregion Constructor
	}

	/// <summary>
	///     Attribute used to map model classes to database select multiple stored procedures.
	///     This attribute can only be applied to classes. All the properties of this class are read only.
	/// </summary>
	public sealed class SelectMultipleProcedureMappingAttribute : StoredProcedureMappingAttribute
	{
		#region Constructor

		/// <summary>
		///     Constructor, set select stored procedure name and procedure type of base class
		/// </summary>
		/// <param name="procedureName">
		///     Name of stored procedure name
		/// </param>
		public SelectMultipleProcedureMappingAttribute(string procedureName) :
			base(procedureName, DBProcedureType.SELECT_MULTIPLE)
		{
		}

		#endregion Constructor
	}
}