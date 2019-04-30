//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 SetCollection
//Purpose:                                      Used to Provide Custom  Serialization
//====================================================================================================================================================

using System;
using System.Collections;
using System.Collections.Generic;
using System.Dynamic;

namespace M4PL.DataAccess.SQLSerializer.Serializer
{
    public class SetCollection : DictionaryBase
    {
        private readonly List<string> _setNames = new List<string>();
        private readonly List<Type> _setTypes = new List<Type>();

        public IList this[Type type]
        {
            get { return this[_setNames[_setTypes.IndexOf(type)]]; }
        }

        public IList this[string name]
        {
            get { return (IList)Dictionary[name]; }
        }

        public IList this[int index]
        {
            get { return this[_setNames[index]]; }
        }

        public List<object> GetSet(string name)
        {
            return (List<object>)this[name];
        }

        public List<T> GetSet<T>()
        {
            return GetSet<T, T>();
        }

        public List<T> GetSet<T>(string name)
        {
            return (List<T>)this[name];
        }

        public List<TReturn> GetSet<TObject, TReturn>()
        {
            return (List<TReturn>)this[typeof(TObject)];
        }

        public void AddSet(string name = null)
        {
            AddSet<ExpandoObject, object>(name);
        }

        public void AddSet<T>(string name = null)
        {
            AddSet<T, T>(name);
        }

        public void AddSet<TObject, TReturn>(string name = null)
        {
            name = name ?? typeof(TObject).ToString();
            _setTypes.Add(typeof(TObject));
            _setNames.Add(name);
            Dictionary.Add(name, new List<TReturn>());
        }

        public Type GetSetType(int index)
        {
            return _setTypes[index];
        }
    }
}