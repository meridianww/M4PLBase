//------------------------------------------------------------------------------ 
// <copyright file="SampleDataset.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Reflection;

using M4PL.DataAccess.Models;
using M4PL.DataAccess.Models.Mapping;

namespace M4PL.DataAccess.Factory.Converter
{
    /// <summary>
    /// This class converts data reader object to corresponding model or array of models.
    /// </summary>
    public struct DataReaderConverter
    {
        #region Member Variables

        /// <summary>
        ///     Details of model mappers
        /// </summary>
        private ModelDataMap mapping;

        #endregion Member Variables

        #region Constructors

        /// <summary>
        /// Constructor of DataReaderConverter class. It accepts model type.
        /// </summary>
        /// <param name="modelType">
        /// The type of model to be associated with the new instance of DataReaderConverter
        /// </param>
        public DataReaderConverter(Type modelType)
        {
            this.mapping = ModelDataMap.GetDataMap(modelType);
        }

        /// <summary>
        /// Constructor of DataReaderConverter class. It accepts object of ModelDataMap class.
        /// </summary>
        /// <param name="mapping">
        /// Object of ModelDataMap class.
        /// </param>
        public DataReaderConverter(ModelDataMap mapping)
        {
            this.mapping = mapping;
        }

        #endregion Constructors

        #region Member Methods

        /// <summary>
        /// This method is used to read a set of rows from a datareader and convert them into an
        /// array of the model.
        /// </summary>
        /// <param name="dataReader">
        /// The dataReader that will be used to construct the models
        /// </param>
        /// <returns>
        /// An array of model instances
        /// </returns>
        public IModel[] ConvertDatReaderToModels(IDataReader dataReader)
        {
            ArrayList modelList = new ArrayList();
            IModel[] models = null;

            // open the data reader
            while (dataReader.Read())
            {
                // convert data reader to a model
                IModel model = this.ConvertDataReaderToModel(dataReader);
                modelList.Add(model);
            }

            // convert array list to model array
            models = (IModel[])modelList.ToArray(this.mapping.ModelType);
            return models;
        }

        /// <summary>
        ///     This method is used to read a set of rows from a data reader and convert them into an
        ///     array of the model.
        /// </summary>
        /// <typeparam name="T">
        ///     Any object that implements Imodel interface
        /// </typeparam>
        /// <param name="dataReader">
        ///     The dataReader that will be used to construct the models
        /// </param>
        /// <returns>
        ///     A collection of model instances
        /// </returns>
        public List<T> ConvertDataReaderToModels<T>(IDataReader dataReader) where T : IModel
        {
            List<T> models = null;

            if (dataReader != null && !dataReader.IsClosed)
            {
                models = new List<T>();

                // open the data reader
                while (dataReader.Read())
                {
                    // convert data reader to a model
                    IModel model = this.ConvertDataReaderToModel(dataReader);
                    models.Add((T)model);
                }
            }

            return models;
        }

        /// <summary>
        /// This method is used to read the current row from a datareader and convert it into an
        /// instance of the model.
        /// This method assumes dataReader.Read() has already been called
        /// and the reader is advanced to the correct row to read.
        /// </summary>
        /// <param name="dataReader">
        /// The dataReader that will be used to construct the model
        /// </param>
        /// <returns>
        /// An instance of the model
        /// </returns>
        public IModel ConvertDataReaderToModel(IDataReader dataReader)
        {
            IModel model = null;
            model = (IModel)this.mapping.Constructor.Invoke(null);

            // Create the model here
            if (dataReader != null)
            {
                object val;
                foreach (ModelColumnMap column in this.mapping.Columns.Values)
                {
                    try
                    {
                        val = dataReader[column.ColumnName];
                    }
                    catch (IndexOutOfRangeException)
                    {
                        val = null;
                    }

                    // set the value for model property
                    if (column.Field != null)
                    {
                        this.SetFieldValue(model, column, val);
                    }
                    else
                    {
                        this.SetFieldValue(model, column.Property, val);
                    }
                }
            }

            return model;
        }

        /// <summary>
        ///	This method is used to set the property of the model field.
        /// </summary>
        /// <param name="model">
        ///	Model whose property to be set.
        /// </param>
        /// <param name="field">
        /// Property to be set.
        /// </param>
        /// <param name="val">
        /// Value of the property
        /// </param>
        public void SetFieldValue(object model, FieldInfo field, object val)
        {
            ModelColumnMap column = (ModelColumnMap)this.mapping.Columns[field.Name];
            this.SetFieldValue(model, column, val);
        }

        /// <summary>
        /// This method is used to set the property of the model using ModelColumnMap class.
        /// </summary>
        /// <param name="model">
        /// Model whose property to be set.
        /// </param>
        /// <param name="column">
        /// Object of ModelColumnMap class
        /// </param>
        /// <param name="val">
        ///	Value to be set.
        /// </param>
        public void SetFieldValue(object model, ModelColumnMap column, object val)
        {
            // set value to null if it is null or DBNull
            if (val == null || val == DBNull.Value)
            {
                val = null;
            }
            else if (column.Field.FieldType.IsEnum)
            {
                val = Enum.ToObject(column.FieldType, val);
            }
            else
            {
                // get the value from the field
                Type valType = val.GetType();
                if (valType != column.FieldType)
                {
                    Type[] typeArray = new Type[1];
                    object[] valueArray = new object[1];
                    typeArray[0] = valType;
                    ConstructorInfo ci;
                    ci = column.FieldType.GetConstructor(typeArray);
                    if (ci != null)
                    {
                        valueArray[0] = val;
                        val = ci.Invoke(valueArray);
                    }
                    else
                    {
                        try
                        {
                            val = Convert.ChangeType(val, column.FieldType);
                        }
                        catch (Exception ex)
                        {
                            string message = ex.Message;
                        }
                    }
                }
            }

            // set the value to the model's field
            column.Field.SetValue(model, val);
        }

        /// <summary>
        /// This method is used to set the property of the model using ModelColumnMap class.
        /// </summary>
        /// <param name="model">
        /// Model whose property to be set.
        /// </param>
        /// <param name="property">
        /// Object of ModelColumnMap class
        /// </param>
        /// <param name="val">
        ///	Value to be set.
        /// </param>
        public void SetFieldValue(object model, PropertyInfo property, object val)
        {
            // set value to null if it is null or DBNull
            if (val == null || val == DBNull.Value)
            {
                val = null;
            }
            else if (property.PropertyType.IsEnum)
            {
                val = Enum.ToObject(property.PropertyType, val);
            }
            else
            {
                // get the value from the field
                Type valType = val.GetType();
                if (valType != property.PropertyType)
                {
                    Type[] typeArray = new Type[1];
                    object[] valueArray = new object[1];
                    typeArray[0] = valType;
                    ConstructorInfo ci;
                    ci = property.PropertyType.GetConstructor(typeArray);
                    if (ci != null)
                    {
                        valueArray[0] = val;
                        val = ci.Invoke(valueArray);
                    }
                    else
                    {
                        val = Convert.ChangeType(val, property.PropertyType);
                    }
                }
            }

            // set the value to the model's field
            property.SetValue(model, val, null);
        }

        #endregion Member Methods
    }
}