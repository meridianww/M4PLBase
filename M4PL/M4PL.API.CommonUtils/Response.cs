using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_CommonUtils
{
    /// <summary>
    /// This is a response object for the all the API calls
    /// </summary>
    /// <typeparam name="T">This is used for the list property only, if List property is not used just send the object class</typeparam>
    public class Response<T>
    {
        public bool Status { get; set; }

        public string Message { get; set; }

        public T Data { get; set; }

        public List<T> DataList { get; set; }

        public MessageTypes MessageType { get; set; }
    }
}
