//------------------------------------------------------------------------------ 
// <copyright file="ModelParameterMap.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;
using System.Reflection;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     This class is used of stored procedure parameter mapping
    /// </summary>
    public class ModelParameterMap
    {
        #region Member Variables

        /// <summary>
        ///     Details of stored procedure parameter mapping attribute
        /// </summary>
        private StoredProcedureParameterMappingAttribute parameterAttribute;

        /// <summary>
        ///     Type of stored procedure mapping attribute
        /// </summary>
        private DbType dbType;

        /// <summary>
        ///     Allow null or not
        /// </summary>
        private bool isDbTypeNull;

        /// <summary>
        ///     Details model property
        /// </summary>
        private PropertyInfo property;

        #endregion

        #region Constructor

        /// <summary>
        ///		Constructor, that maps model datatype with database field type
        /// </summary>
        /// <param name="property">
        ///		The reflection information about the model's property
        /// </param>
        /// <param name="parameterAttr">
        ///		The column attribute associated with the field
        /// </param>
        public ModelParameterMap(PropertyInfo property, StoredProcedureParameterMappingAttribute parameterAttr)
        {
            this.property = property;
            this.parameterAttribute = parameterAttr;
            this.isDbTypeNull = false;

            // checks whether parameter attribute is null or not
            if (!parameterAttr.IsDatabaseTypeNull)
            {
                this.dbType = parameterAttr.DatabaseType;
            }
            else
            {
                // Maps model property type with database field type
                if (property.PropertyType == typeof(int))
                {
                    this.dbType = DbType.Int32;
                }
                else if (property.PropertyType == typeof(long))
                {
                    this.dbType = DbType.Int64;
                }
                else if (property.PropertyType == typeof(DateTime))
                {
                    this.dbType = DbType.DateTime;
                }
                else if (property.PropertyType == typeof(string))
                {
                    this.dbType = DbType.String;
                }
                else if (property.PropertyType == typeof(bool))
                {
                    this.dbType = DbType.Boolean;
                }
                else if (property.PropertyType == typeof(double))
                {
                    this.dbType = DbType.Double;
                }
                else
                {
                    this.isDbTypeNull = true;
                }
            }
        }

        #endregion

        #region Accessor Methods

        /// <summary>
        ///		Gets column name
        /// </summary>
        public string ParameterName
        {
            get
            {
                return this.parameterAttribute.ParameterName;
            }
        }

        /// <summary>
        ///		Gets  column size
        /// </summary>
        public int ParameterSize
        {
            get
            {
                return this.parameterAttribute.Size;
            }
        }

        /// <summary>
        ///		Gets input parameter index of stored procedure.
        /// </summary>
        public int ParameterIndex
        {
            get
            {
                return this.parameterAttribute.ParameterIndex;
            }
        }

        /// <summary>
        ///		Gets property name
        /// </summary>
        public string PropertyName
        {
            get
            {
                return this.property.Name;
            }
        }

        /// <summary>
        ///		Gets property type
        /// </summary>
        public Type PropertyType
        {
            get
            {
                return this.property.PropertyType;
            }
        }

        /// <summary>
        ///		Gets property info
        /// </summary>
        public PropertyInfo Property
        {
            get
            {
                return this.property;
            }
        }

        /// <summary>
        ///		Gets database type.
        /// </summary>
        public DbType DatabaseType
        {
            get
            {
                return (DbType)this.dbType;
            }
        }

        /// <summary>
        ///		Gets a value indicating whether database type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get
            {
                return this.isDbTypeNull;
            }
        }

        /// <summary>
        ///     Gets type of procedure like Select, Insert etc
        /// </summary>
        public DBProcedureType ParameterAction
        {
            get
            {
                return this.parameterAttribute.ParameterActionType;
            }
        }
        #endregion
    }
}
