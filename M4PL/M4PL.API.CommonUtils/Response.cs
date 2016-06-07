using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities;

namespace M4PL_API_CommonUtils
{
    /// <summary>
    /// This is a response object for the all the API calls
    /// </summary>
    /// <typeparam name="T">This is used for the list property only, if List property is not used just send the object class</typeparam>
    public class Response<T>
    {
        public bool Status { get; set; }
        public T Data { get; set; }
        public List<T> DataList { get; set; }

        //public Messages Messages { get; set; }
        public string Message { get; set; }
        public MessageTypes MessageType { get; set; }

        //Message Templatee
        public disMessages SystemMessages { get; set; }

        public bool ShowFilterRow { get; set; }
        public bool AllowGroup { get; set; }

        public Response() { }
        public Response(T data, List<T> dataList, bool status = false, MessageTypes messageType = MessageTypes.Success, string message = "", bool showFilterRow = false, bool allowGroup = false)
        {
            this.Data = data;
            this.DataList = new List<T>();
            this.Status = status;
            this.MessageType = messageType;
            this.Message = message;
            this.ShowFilterRow = showFilterRow;
            this.AllowGroup = allowGroup;
        }
    }
}
