//------------------------------------------------------------------------------ 
// <copyright file="StoredProcedureParameterMappingAttribute.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     Used for stored procedure parameter mapping
    /// </summary>   
    public class StoredProcedureParameterMappingAttribute : Attribute
    {
        #region Member Varibles

        /// <summary>
        ///     name of stored procedure parameter
        /// </summary>
        private string parameterName;

        /// <summary>
        ///     size of stored procedure parameter
        /// </summary>
        private int size;

        /// <summary>
        ///     data type of stored procedure parameter
        /// </summary> 
        private object dbType = null;

        /// <summary>
        ///     DB action for store procedure parameter
        /// </summary>
        private DBProcedureType procedureType = 0;

        /// <summary>
        ///     Input parameter position in stored procedure
        /// </summary>
        private int parameterIndex = 0;

        #endregion

        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public StoredProcedureParameterMappingAttribute(string parameterName)
        {
            this.parameterName = parameterName;
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        /// <param name="parameterIndex">
        ///		Position of input parameter in stored procedure.
        /// </param>
        public StoredProcedureParameterMappingAttribute(string parameterName, int parameterIndex)
        {
            this.parameterName = parameterName;
            this.parameterIndex = parameterIndex;
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="procedureType">
        ///		stored procedure type (insert, update, delete, select)
        /// </param>
        public StoredProcedureParameterMappingAttribute(string parameterName, DBProcedureType procedureType)
        {
            this.parameterName = parameterName;
            this.procedureType = procedureType;
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="procedureType">
        ///		stored procedure type (insert, update, delete, select)
        /// </param>
        /// <param name="parameterIndex">
        ///		Position of input parameter in stored procedure.
        /// </param>
        public StoredProcedureParameterMappingAttribute(string parameterName, DBProcedureType procedureType, int parameterIndex)
        {
            this.parameterName = parameterName;
            this.procedureType = procedureType;
            this.parameterIndex = parameterIndex;
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>	
        /// <param name="procedureType">
        /// Parameter for store procedure performing procedureType action 
        /// </param>		
        public StoredProcedureParameterMappingAttribute(string parameterName, int size, DBProcedureType procedureType)
        {
            this.parameterName = parameterName;
            this.size = size;
            this.procedureType = procedureType;
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>	
        /// <param name="procedureType">
        ///     Parameter for store procedure performing procedureType action 
        /// </param>
        /// <param name="parameterIndex">
        ///		position of input parameter in stored procedure.
        /// </param>
        public StoredProcedureParameterMappingAttribute(string parameterName, int size, DBProcedureType procedureType, int parameterIndex)
        {
            this.parameterName = parameterName;
            this.size = size;
            this.procedureType = procedureType;
            this.parameterIndex = parameterIndex;
        }

        #endregion

        #region Accessor Methods

        /// <summary>
        ///		Gets the parameter name in the stored procedure 
        ///		that is related to the property in the model.
        /// </summary>
        public string ParameterName
        {
            get
            {
                return this.parameterName;
            }
        }

        /// <summary>
        ///		Gets size of database columns, size is an optional field 
        ///		that may be specified on certain data types, like strings
        ///		for example, to specify the database size of the column.
        /// </summary>
        public int Size
        {
            get
            {
                return this.size;
            }
        }

        /// <summary>
        ///		Gets database type
        /// </summary>
        public DbType DatabaseType
        {
            get
            {
                return (DbType)this.dbType;
            }
        }

        /// <summary>
        ///		Gets a value indicating whether db type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get
            {
                return this.dbType == null;
            }
        }

        /// <summary>
        ///		Gets the type of stored procedure which has associated with this parameter.
        /// </summary>
        public DBProcedureType ParameterActionType
        {
            get
            {
                return this.procedureType;
            }
        }

        /// <summary>
        ///		Gets input parameter index of stored procedure.
        /// </summary>
        public int ParameterIndex
        {
            get
            {
                return this.parameterIndex;
            }
        }

        #endregion
    }

    /// <summary>
    ///     Attribute used to map value object fields and properties to stored procedure parameters.
    ///     This attribute can only be applied to parameter. All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class InsertParameterMappingAttribute : StoredProcedureParameterMappingAttribute
    {
        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public InsertParameterMappingAttribute(
            string parameterName)
            : base(parameterName, DBProcedureType.INSERT)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="parameterIndex">
        ///		Stored procedure parameter index
        /// </param>
        public InsertParameterMappingAttribute(string parameterName, int parameterIndex)
            : base(parameterName, DBProcedureType.INSERT, parameterIndex)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>
        public InsertParameterMappingAttribute(
            string parameterName, float size)
            : base(parameterName, (int)size, DBProcedureType.INSERT)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>
        /// <param name="parameterIndex">
        ///		Stored procedure parameter index
        /// </param>
        public InsertParameterMappingAttribute(
            string parameterName, int size, int parameterIndex)
            : base(parameterName, size, DBProcedureType.INSERT, parameterIndex)
        {
        }

        #endregion
    }

    /// <summary>
    /// Attribute used to map value object fields and properties to stored procedure parameters.
    /// This attribute can only be applied to parameter. All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class UpdateParameterMappingAttribute : StoredProcedureParameterMappingAttribute
    {
        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public UpdateParameterMappingAttribute(string parameterName) :
            base(parameterName, DBProcedureType.UPDATE)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>	
        /// <param name="parameterIndex">
        ///		Parameter Index
        /// </param>
        public UpdateParameterMappingAttribute(string parameterName, int parameterIndex) :
            base(parameterName, DBProcedureType.UPDATE, parameterIndex)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>
        public UpdateParameterMappingAttribute(string parameterName, float size) :
            base(parameterName, (int)size, DBProcedureType.UPDATE)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="size">
        ///		Parameter data type size
        /// </param>
        /// <param name="parameterIndex">
        ///		Stored procedure parameter index.
        /// </param>
        public UpdateParameterMappingAttribute(string parameterName, float size, int parameterIndex)
            : base(parameterName, (int)size, DBProcedureType.UPDATE, parameterIndex)
        {
        }

        #endregion
    }

    /// <summary>
    /// Attribute used to map value object fields and properties to stored procedure parameters.
    /// This attribute can only be applied to parameter. All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class DeleteParameterMappingAttribute : StoredProcedureParameterMappingAttribute
    {
        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public DeleteParameterMappingAttribute(
            string parameterName)
            : base(parameterName, DBProcedureType.DELETE)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="index">
        ///		Parameter input index.
        /// </param>
        public DeleteParameterMappingAttribute(string parameterName, int index)
            : base(parameterName, DBProcedureType.DELETE, index)
        {
        }

        #endregion
    }

    /// <summary>
    /// Attribute used to map value object fields and properties to stored procedure parameters.
    /// This attribute can only be applied to parameter. All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class SelectParameterMappingAttribute : StoredProcedureParameterMappingAttribute
    {
        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public SelectParameterMappingAttribute(string parameterName)
            : base(parameterName, DBProcedureType.SELECT)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="index">
        ///		Stored procedure input parameter index
        /// </param>
        public SelectParameterMappingAttribute(string parameterName, int index)
            : base(parameterName, DBProcedureType.SELECT, index)
        {
        }

        #endregion
    }

    /// <summary>
    /// Attribute used to map value object fields and properties to stored procedure parameters.
    /// This attribute can only be applied to parameter. All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class SelectMultipleParameterMappingAttribute : StoredProcedureParameterMappingAttribute
    {
        #region Constructors

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>			
        public SelectMultipleParameterMappingAttribute(
            string parameterName)
            : base(parameterName, DBProcedureType.SELECT_MULTIPLE)
        {
        }

        /// <summary>
        ///		Construct a parameter mapping attribute
        /// </summary>
        /// <param name="parameterName">
        ///		Name of stored procedure parameter
        /// </param>
        /// <param name="index">
        ///		Stored procedure input parameter index
        /// </param>
        public SelectMultipleParameterMappingAttribute(
            string parameterName, int index)
            : base(parameterName, DBProcedureType.SELECT_MULTIPLE, index)
        {
        }

        #endregion
    }
}
