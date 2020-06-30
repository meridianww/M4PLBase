/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 BaseCommands
Purpose:                                      Contains generic CRUD operation parameters
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Data;

namespace M4PL.DataAccess
{
    public static class ParamsProvider
    {
        #region Shared Paramters

        public static List<Parameter> PagedDataDefaultParams(this PagedDataInfo pagedDataInfo, ActiveUser activeUser, EntitiesAlias entitiesAlias, bool langCode = false)
        {
            var defaultParams = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@entity", pagedDataInfo.Entity.ToString()),
               new Parameter("@pageNo", pagedDataInfo.PageNumber),
               new Parameter("@pageSize", pagedDataInfo.PageSize),
               new Parameter("@orderBy", pagedDataInfo.OrderBy),
               new Parameter("@where", pagedDataInfo.WhereCondition),
               new Parameter("@parentId", pagedDataInfo.ParentId),
               new Parameter("@isNext", pagedDataInfo.IsNext),
               new Parameter("@isEnd", pagedDataInfo.IsEnd),
               new Parameter("@recordId", pagedDataInfo.RecordId),
               new Parameter("@groupBy", pagedDataInfo.GroupBy),
               new Parameter("@groupByWhere", pagedDataInfo.GroupByWhereCondition)
            };
            if (langCode)
                defaultParams.Add(new Parameter("@langCode", activeUser.LangCode));

            defaultParams.Add(new Parameter(StoredProceduresConstant.TotalCountLastParam, pagedDataInfo.TotalCount, ParameterDirection.Output, typeof(int)));
            return defaultParams;
        }

        public static List<Parameter> GetRecordDefaultParams(this ActiveUser activeUser, long id, bool langCode = false)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@id", id),
                new Parameter("@orgId", activeUser.OrganizationId)
            };
            if (langCode)
                parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            return parameters;
        }

        public static List<Parameter> GetRecordDefaultParams(this ActiveUser activeUser, bool langCode = false)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId)
            };
            if (langCode)
                parameters.Add(new Parameter("@langCode", activeUser.LangCode));
            return parameters;
        }

        public static List<Parameter> PostDefaultParams<T>(this ActiveUser activeUser, T record) where T : class, new()
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@entity", new T().GetType().Name)
            };
            if (record is BaseModel)
            {
                parameters.Add(new Parameter("@enteredBy", activeUser.UserName));
                parameters.Add(new Parameter("@dateEntered", Utilities.TimeUtility.GetPacificDateTime()));
            }
            return parameters;
        }

        public static List<Parameter> PutDefaultParams<T>(this ActiveUser activeUser, long id, T record) where T : class, new()
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@id", id),
               new Parameter("@entity", new T().GetType().Name)
            };
            if (record is BaseModel)
            {
                parameters.Add(new Parameter("@changedBy", activeUser.UserName));
                parameters.Add(new Parameter("@dateChanged", Utilities.TimeUtility.GetPacificDateTime()));
                parameters.Add(new Parameter("@isFormView", (record as BaseModel).IsFormView));
            }
            return parameters;
        }

        public static List<Parameter> DeleteDefaultParams(this ActiveUser activeUser, params long[] ids)
        {
            var defaultParams = new List<Parameter>
            {
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@id", ids[0])
            };

            return defaultParams;
        }

        #endregion Shared Paramters
    }
}