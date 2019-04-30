//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ModelParameterMap
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

using System;
using System.Data;
using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     This class is used of stored procedure parameter mapping
    /// </summary>
    public class ModelParameterMap
    {
        #region Constructor

        /// <summary>
        ///     Constructor, that maps model datatype with database field type
        /// </summary>
        /// <param name="property">
        ///     The reflection information about the model's property
        /// </param>
        /// <param name="parameterAttr">
        ///     The column attribute associated with the field
        /// </param>
        public ModelParameterMap(PropertyInfo property, StoredProcedureParameterMappingAttribute parameterAttr)
        {
            this.property = property;
            parameterAttribute = parameterAttr;
            isDbTypeNull = false;

            // checks whether parameter attribute is null or not
            if (!parameterAttr.IsDatabaseTypeNull)
            {
                dbType = parameterAttr.DatabaseType;
            }
            else
            {
                // Maps model property type with database field type
                if (property.PropertyType == typeof(int))
                    dbType = DbType.Int32;
                else if (property.PropertyType == typeof(long))
                    dbType = DbType.Int64;
                else if (property.PropertyType == typeof(DateTime))
                    dbType = DbType.DateTime;
                else if (property.PropertyType == typeof(string))
                    dbType = DbType.String;
                else if (property.PropertyType == typeof(bool))
                    dbType = DbType.Boolean;
                else if (property.PropertyType == typeof(double))
                    dbType = DbType.Double;
                else
                    isDbTypeNull = true;
            }
        }

        #endregion Constructor

        #region Member Variables

        /// <summary>
        ///     Details of stored procedure parameter mapping attribute
        /// </summary>
        private readonly StoredProcedureParameterMappingAttribute parameterAttribute;

        /// <summary>
        ///     Type of stored procedure mapping attribute
        /// </summary>
        private readonly DbType dbType;

        /// <summary>
        ///     Allow null or not
        /// </summary>
        private readonly bool isDbTypeNull;

        /// <summary>
        ///     Details model property
        /// </summary>
        private readonly PropertyInfo property;

        #endregion Member Variables

        #region Accessor Methods

        /// <summary>
        ///     Gets column name
        /// </summary>
        public string ParameterName
        {
            get { return parameterAttribute.ParameterName; }
        }

        /// <summary>
        ///     Gets  column size
        /// </summary>
        public int ParameterSize
        {
            get { return parameterAttribute.Size; }
        }

        /// <summary>
        ///     Gets input parameter index of stored procedure.
        /// </summary>
        public int ParameterIndex
        {
            get { return parameterAttribute.ParameterIndex; }
        }

        /// <summary>
        ///     Gets property name
        /// </summary>
        public string PropertyName
        {
            get { return property.Name; }
        }

        /// <summary>
        ///     Gets property type
        /// </summary>
        public Type PropertyType
        {
            get { return property.PropertyType; }
        }

        /// <summary>
        ///     Gets property info
        /// </summary>
        public PropertyInfo Property
        {
            get { return property; }
        }

        /// <summary>
        ///     Gets database type.
        /// </summary>
        public DbType DatabaseType
        {
            get { return dbType; }
        }

        /// <summary>
        ///     Gets a value indicating whether database type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get { return isDbTypeNull; }
        }

        /// <summary>
        ///     Gets type of procedure like Select, Insert etc
        /// </summary>
        public DBProcedureType ParameterAction
        {
            get { return parameterAttribute.ParameterActionType; }
        }

        #endregion Accessor Methods
    }
}