using System;

namespace M4PL.DataAccess.Serializer
{    

    public class FCLDataException : Exception
    {
        public string ErrorCode { get; private set; }

        public FCLDataException(string errorCode, string message, Exception innerException)
            : base(message, innerException)
        {
            this.ErrorCode = errorCode;
        }
    }
}
