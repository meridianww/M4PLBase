using System;

namespace M4PL.DataAccess.Serializer
{
    [AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
    public class EnumDisplayNameAttribute : Attribute
    {
        private readonly string _displayName;

        public string DisplayName
        {
            get
            {
                return this._displayName ?? string.Empty;
            }
        }

        public EnumDisplayNameAttribute(string displayName)
        {
            this._displayName = displayName;
        }
    }
}
