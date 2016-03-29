//------------------------------------------------------------------------------ 
// <copyright file="ModelDataMap.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    ///     Class used for attribute mapping
    /// </summary>
    public class ModelDataMap
    {
        #region Member Variables

        /// <summary>
        ///     Details of model type
        /// </summary>
        private readonly Type modelType;

        /// <summary>
        ///     Constructor info for invoking constructor of model
        /// </summary>
        private readonly ConstructorInfo constructor;

        /// <summary>
        ///     Details of mapping tables
        /// </summary>
        private static Hashtable mappingTable;

        /// <summary>
        ///     Details of table mapping attribute.
        /// </summary>
        private TableMappingAttribute tableAttribute;

        /// <summary>
        ///     Name of primary key column
        /// </summary>
        private string keyColumn;

        /// <summary>
        ///     Name of primary key field
        /// </summary>
        private FieldInfo keyField;

        /// <summary>
        ///     Name of primary key property
        /// </summary>
        private PropertyInfo keyProperty;

        /// <summary>
        ///     Collection of column mapping attributes       
        /// </summary>
        private Hashtable columnMap;

        /// <summary>
        ///     Collection of procedure mapping attributes
        /// </summary>
        private Dictionary<DBProcedureType, StoredProcedureMappingAttribute> procedureAttributes;

        /// <summary>
        ///     Collection stored procedure parameter mapping attributes
        /// </summary>
        private Hashtable parameterMap;

        #endregion

        #region Constructor

        /// <summary>
        ///		Creates instance of ModelDataMap
        /// </summary>
        /// <param name="modelType">
        ///		Type of model object.
        /// </param>
        private ModelDataMap(Type modelType)
        {
            this.modelType = modelType;
            this.constructor = modelType.GetConstructor(Type.EmptyTypes);

            this.SetTableAttribute();
            this.CreateColumnMapping();
            this.SetProcedureAttribute();
            this.CreateParameterMapping();
        }

        #endregion

        #region Properties

        /// <summary>
        ///		Gets or sets System.Collections.Hashtable that contais 
        ///		table mapping details.
        /// </summary>
        public static Hashtable MappingTable
        {
            get
            {
                return mappingTable;
            }

            set
            {
                mappingTable = value;
            }
        }

        /// <summary>
        ///		Gets table name.
        /// </summary>
        public string TableName
        {
            get
            {
                return this.tableAttribute.TableName;
            }
        }

        /// <summary>
        ///		Gets view name
        /// </summary>
        public string ViewName
        {
            get
            {
                return this.tableAttribute.ViewName;
            }
        }

        /// <summary>
        ///		Gets primary key field
        /// </summary>
        public FieldInfo KeyField
        {
            get
            {
                return this.keyField;
            }
        }

        /// <summary>
        ///		Gets key property info.
        /// </summary>
        public PropertyInfo KeyProperty
        {
            get
            {
                return this.keyProperty;
            }
        }

        /// <summary>
        ///		Gets key column
        /// </summary>
        public string KeyColumn
        {
            get
            {
                return this.keyColumn;
            }
        }

        /// <summary>
        ///		Gets type of model
        /// </summary>
        public Type ModelType
        {
            get
            {
                return this.modelType;
            }
        }

        /// <summary>
        ///		Gets constructor info
        /// </summary>
        public ConstructorInfo Constructor
        {
            get
            {
                return this.constructor;
            }
        }

        /// <summary>
        ///     Gets collection of procedures
        /// </summary>
        public IDictionary Procedures
        {
            get
            {
                return this.procedureAttributes;
            }
        }

        /// <summary>
        ///     Gets collection of parameters
        /// </summary>
        public IDictionary Parameters
        {
            get
            {
                return this.parameterMap;
            }
        }

        /// <summary>
        /// Gets a map of columns defined for the associated model type. The keys of this
        /// map are the names of the model's properties. The values stored in this map are
        /// ModelColumnMap instances.
        /// </summary>
        public IDictionary Columns
        {
            get
            {
                return this.columnMap;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        ///		Get data map of specified model type.
        /// </summary>
        /// <param name="modelType">
        ///		Type of model object.
        /// </param>
        /// <returns>
        ///		GlobalTranz.Framework.Common.Models.ModelDataMap object.
        /// </returns>
        public static ModelDataMap GetDataMap(Type modelType)
        {
            if (mappingTable == null)
            {
                mappingTable = new Hashtable();
            }

            ModelDataMap mapping = (ModelDataMap)mappingTable[modelType.FullName];
            if (mapping == null)
            {
                mapping = new ModelDataMap(modelType);
                mappingTable[modelType.FullName] = mapping;
            }

            return mapping;
        }

        /// <summary>
        ///		Set table attribute.
        /// </summary>
        private void SetTableAttribute()
        {
            object[] mappings;
            mappings = this.modelType.GetCustomAttributes(typeof(TableMappingAttribute), true);

            if (mappings != null && mappings.Length > 0)
            {
                this.tableAttribute = (TableMappingAttribute)mappings[0];

                if (this.tableAttribute.KeyFieldName != null)
                {
                    // Todo: uncomment when use filed mapping
                    // this.keyField = this.modelType.GetField(
                    //    this.tableAttribute.KeyFieldName,
                    //    BindingFlags.SuppressChangeType | BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
                    // if (this.KeyField == null)
                    // {
                    //    this.keyProperty = this.modelType.GetProperty(this.tableAttribute.KeyFieldName);
                    // }
                    this.keyProperty = this.modelType.GetProperty(this.tableAttribute.KeyFieldName);
                }

                if (this.keyField != null || this.keyProperty != null)
                {
                    // Todo: uncomment when use filed mapping
                    // if (this.KeyField != null)
                    // {
                    //    mappings = this.keyField.GetCustomAttributes(typeof(ColumnMappingAttribute), true);
                    // }
                    // else if (this.keyProperty != null)
                    // {
                    //    mappings = this.keyProperty.GetCustomAttributes(typeof(ColumnMappingAttribute), true);
                    // }
                    mappings = this.keyProperty.GetCustomAttributes(typeof(ColumnMappingAttribute), true);

                    ColumnMappingAttribute attr = (ColumnMappingAttribute)mappings[0];
                    this.keyColumn = attr.ColumnName;
                }
                else
                {
                    this.keyColumn = this.tableAttribute.KeyFieldName;
                }
            }
        }

        /// <summary>
        ///		Create column mapping
        /// </summary>
        private void CreateColumnMapping()
        {
            this.columnMap = new Hashtable();

            // FieldInfo[] fields = modelType.GetFields(BindingFlags.IgnoreCase | BindingFlags.SuppressChangeType | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            PropertyInfo[] properties = this.modelType.GetProperties();
            object[] mappings;
            ColumnMappingAttribute attr;

            if (properties.GetLength(0) > 0)
            {
                foreach (PropertyInfo p in properties)
                {
                    mappings = p.GetCustomAttributes(typeof(ColumnMappingAttribute), true);

                    if (mappings != null && mappings.Length > 0)
                    {
                        attr = (ColumnMappingAttribute)mappings[0];
                        ModelColumnMap test = new ModelColumnMap(p, attr);
                        this.columnMap.Add(p.Name, new ModelColumnMap(p, attr));
                    }
                }
            }
        }

        /// <summary>
        ///		Set procedure attribute.
        /// </summary>
        private void SetProcedureAttribute()
        {
            object[] mappings;
            this.procedureAttributes = new Dictionary<DBProcedureType, StoredProcedureMappingAttribute>();

            // Retrieves 
            mappings = this.modelType.GetCustomAttributes(typeof(StoredProcedureMappingAttribute), true);

            if (mappings != null && mappings.Length > 0)
            {
                foreach (object map in mappings)
                {
                    StoredProcedureMappingAttribute procedure = (StoredProcedureMappingAttribute)map;
                    this.procedureAttributes.Add(procedure.ProcedureType, procedure);
                }
            }
        }

        /// <summary>
        ///		Create column mapping
        /// </summary>
        private void CreateParameterMapping()
        {
            this.parameterMap = new Hashtable();
            PropertyInfo[] properties = this.modelType.GetProperties();
            object[] mappings;
            StoredProcedureParameterMappingAttribute parameterAttribute;

            if ((properties.GetLength(0) > 0))
            {
                foreach (PropertyInfo property in properties)
                {
                    mappings = property.GetCustomAttributes(typeof(StoredProcedureParameterMappingAttribute), true);

                    if (mappings != null && mappings.Length > 0)
                    {
                        ArrayList modelparamenteMap = new ArrayList();

                        foreach (object map in mappings)
                        {
                            parameterAttribute = (StoredProcedureParameterMappingAttribute)map;
                            modelparamenteMap.Add(new ModelParameterMap(property, parameterAttribute));
                        }

                        this.parameterMap.Add(property.Name, modelparamenteMap);
                    }
                }
            }
        }

        #endregion
    }
}
