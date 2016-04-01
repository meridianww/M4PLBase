using System;
using System.Collections;
using System.Collections.Generic;
using System.Dynamic;

namespace M4PL.DataAccess.Serializer
{
    public class SetCollection : DictionaryBase
    {
        private readonly List<Type> _setTypes = new List<Type>();
        private readonly List<string> _setNames = new List<string>();

        public IList this[Type type]
        {
            get
            {
                return this[this._setNames[this._setTypes.IndexOf(type)]];
            }
        }

        public IList this[string name]
        {
            get
            {
                return (IList)this.Dictionary[(object)name];
            }
        }

        public IList this[int index]
        {
            get
            {
                return this[this._setNames[index]];
            }
        }

        public List<object> GetSet(string name)
        {
            return (List<object>)this[name];
        }

        public List<T> GetSet<T>()
        {
            return this.GetSet<T, T>();
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
            this.AddSet<ExpandoObject, object>(name);
        }

        public void AddSet<T>(string name = null)
        {
            this.AddSet<T, T>(name);
        }

        public void AddSet<TObject, TReturn>(string name = null)
        {
            name = name ?? typeof(TObject).ToString();
            this._setTypes.Add(typeof(TObject));
            this._setNames.Add(name);
            this.Dictionary.Add((object)name, (object)new List<TReturn>());
        }

        public Type GetSetType(int index)
        {
            return this._setTypes[index];
        }
    }
}
