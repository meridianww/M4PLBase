#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/31/2019
// Program Name:                                 NavPriceCodeCommands
// Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Finance.NavPriceCodeCommands
//==============================================================================================================
using M4PL.Business.Common;
using M4PL.Entities.Finance.OrderItem;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using _commands = M4PL.DataAccess.Finance.NavPriceCodeCommands;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;
using _orderItemCommands = M4PL.DataAccess.Finance.NAVOrderItemCommands;

namespace M4PL.Business.Finance.PriceCode
{
    public class NavPriceCodeCommands : BaseCommands<NavPriceCode>, INavPriceCodeCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public IList<NavPriceCode> GetAllPriceCode()
        {
            List<NavPriceCode> navPriceCodeList = null;
            if (!M4PBusinessContext.ComponentSettings.NavRateReadFromItem)
            {
                navPriceCodeList = GetNavPriceCodeData();
                if (navPriceCodeList != null && navPriceCodeList.Count > 0)
                {
                    _commands.Put(ActiveUser, navPriceCodeList);
                }
            }
            else
            {
                NAVOrderItemResponse navOrderItemResponse = CommonCommands.GetNAVOrderItemResponse();
                if (navOrderItemResponse?.OrderItemList?.Count > 0)
                {
                    _orderItemCommands.UpdateNavPriceCode(ActiveUser, navOrderItemResponse.OrderItemList);
                    navPriceCodeList = new List<NavPriceCode>();
                }
            }

            return navPriceCodeList;
        }

        public NavPriceCode Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<NavPriceCode> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public NavPriceCode Patch(NavPriceCode entity)
        {
            throw new NotImplementedException();
        }

        public NavPriceCode Post(NavPriceCode entity)
        {
            throw new NotImplementedException();
        }

        public NavPriceCode Put(NavPriceCode entity)
        {
            throw new NotImplementedException();
        }

        private List<NavPriceCode> GetNavPriceCodeData()
        {
            string navAPIUrl = M4PBusinessContext.ComponentSettings.NavAPIUrl;
            string navAPIUserName = M4PBusinessContext.ComponentSettings.NavAPIUserName;
            string navAPIPassword = M4PBusinessContext.ComponentSettings.NavAPIPassword;
            NavPriceCodeResponse navPriceCodeResponse = null;
            try
            {
                string serviceCall = string.Format("{0}('{1}')/SalesPrices", navAPIUrl, "Meridian");
                NetworkCredential myCredentials = new NetworkCredential(navAPIUserName, navAPIPassword);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(serviceCall);
                request.Credentials = myCredentials;
                request.KeepAlive = false;
                WebResponse response = request.GetResponse();

                using (Stream navPriceCodeResponseStream = response.GetResponseStream())
                {
                    using (TextReader txtCarrierSyncReader = new StreamReader(navPriceCodeResponseStream))
                    {
                        string responceString = txtCarrierSyncReader.ReadToEnd();

                        using (var stringReader = new StringReader(responceString))
                        {
                            navPriceCodeResponse = Newtonsoft.Json.JsonConvert.DeserializeObject<NavPriceCodeResponse>(responceString);
                        }
                    }
                }
            }
            catch (Exception exp)
            {
                _logger.Log(exp, "Error while getting the NAV Price Code Data.", "GetNavPriceCodeData", Utilities.Logger.LogType.Error);
            }

            return (navPriceCodeResponse?.PriceCodeList?.Count > 0) ?
                    navPriceCodeResponse.PriceCodeList :
                    new List<NavPriceCode>();
        }
    }
}
