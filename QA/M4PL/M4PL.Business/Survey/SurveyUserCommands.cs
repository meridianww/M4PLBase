using M4PL.Entities.Support;
using M4PL.Entities.Survey;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Xml;
using _commands = M4PL.DataAccess.Survey.SurveyUserCommands;

namespace M4PL.Business.Survey
{
    public class SurveyUserCommands : BaseCommands<SurveyUser>, ISurveyUserCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public SurveyUser Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<SurveyUser> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public SurveyUser Patch(SurveyUser entity)
        {
            throw new NotImplementedException();
        }

        public SurveyUser Post(SurveyUser entity)
        {
            try { entity = GetVOCAdditionalInfo(entity); }
            catch { }

            return _commands.Post(ActiveUser, entity);
        }

        public SurveyUser Put(SurveyUser entity)
        {
            return _commands.Put(ActiveUser, entity);
        }

        public SurveyUser GetVOCAdditionalInfo(SurveyUser entity)
        {
            string serviceCall = string.Format("{0}?&JobNo={1}", M4PBusinessContext.ComponentSettings.GetVOCJobURL, entity.EntityTypeId);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
            request.KeepAlive = false;
            WebResponse response = request.GetResponse();
            using (Stream navPriceCodeResponseStream = response.GetResponseStream())
            {
                using (TextReader txtCarrierSyncReader = new StreamReader(navPriceCodeResponseStream))
                {
                    string responceString = txtCarrierSyncReader.ReadToEnd();
                    responceString = responceString.Replace("<string>", string.Empty);
                    responceString = responceString.Replace("&lt;", "<");
                    responceString = responceString.Replace("&gt;", ">");
                    responceString = responceString.Replace("<string xmlns=\"Copyright © Programmed Business Solutions - October 2010\">", string.Empty);
                    responceString = responceString.Replace("</string>", string.Empty);
                    using (var stringReader = new StringReader(responceString))
                    {
                        XmlDocument doc = new XmlDocument();
                        doc.LoadXml(responceString);
                        XmlNodeList xNodeList = doc.SelectNodes("/NewDataSet/Table");
                        if (xNodeList != null && xNodeList.Count > 0)
                        {
                            foreach (XmlNode xNode in xNodeList)
                            {
                                entity.DriverNo = xNode["DriverNo"]?.InnerText;
                                entity.Driver = xNode["Driver"]?.InnerText;
                                entity.Contract = xNode["Contract"]?.InnerText;
                                entity.Location = xNode["Location"]?.InnerText;
                                entity.CustName = xNode["Customer"]?.InnerText;
                                entity.Delivered = xNode["Delivered"]?.InnerText;
                            }
                        }
                    }
                }
            }

            return entity;
        }
    }
}
