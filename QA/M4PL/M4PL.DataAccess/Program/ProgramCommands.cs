/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ProgramCommands
Purpose:                                      Contains commands to perform CRUD on Program
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Program
{
    public class ProgramCommands : BaseCommands<Entities.Program.Program>
    {
        /// <summary>
        /// Gets list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Program.Program> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetProgramView, EntitiesAlias.Program);
        }

        /// <summary>
        /// Gets the specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Program.Program Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetProgram);
        }

        /// <summary>
        /// Gets the specific Program record With parentId
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Entities.Program.Program Get(ActiveUser activeUser, long id, long? parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Program.Program>(StoredProceduresConstant.GetProgram, parameters.ToArray(), storedProcedure: true);
            return result ?? new Entities.Program.Program();
        }

        /// <summary>
        /// Creates a new Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="program"></param>
        /// <returns></returns>

        public static Entities.Program.Program Post(ActiveUser activeUser, Entities.Program.Program program)
        {
            var parameters = GetParameters(program);
            // parameters.Add(new Parameter("@langCode", program.LangCode));
            parameters.AddRange(activeUser.PostDefaultParams(program));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertProgram);
        }

        /// <summary>
        /// Updates the existing Program recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="program"></param>
        /// <returns></returns>

        public static Entities.Program.Program Put(ActiveUser activeUser, Entities.Program.Program program)
        {
            var parameters = GetParameters(program);
            // parameters.Add(new Parameter("@langCode", program.LangCode));
            parameters.AddRange(activeUser.PutDefaultParams(program.Id, program));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateProgram);
        }

        /// <summary>
        /// Deletes a specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Program, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the Program Module
        /// </summary>
        /// <param name="program"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Program.Program program)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@prgOrgId", program.PrgOrgID),
               new Parameter("@prgCustId", program.PrgCustID),
               new Parameter("@prgItemNumber", program.PrgItemNumber),
               new Parameter("@prgProgramCode", program.PrgProgramCode),
               new Parameter("@prgProjectCode", program.PrgProjectCode),
               new Parameter("@prgPhaseCode", program.PrgPhaseCode),
               new Parameter("@prgProgramTitle", program.PrgProgramTitle),
               new Parameter("@prgAccountCode", program.PrgAccountCode),
               new Parameter("@delEarliest", program.DelEarliest),
               new Parameter("@delLatest", program.DelLatest),
               new Parameter("@delDay", program.DelDay),
               new Parameter("@pckEarliest", program.PckEarliest),
               new Parameter("@pckLatest", program.PckLatest),
               new Parameter("@pckDay", program.PckDay),
               new Parameter("@statusId", program.StatusId),
               new Parameter("@prgDateStart", program.PrgDateStart),
               new Parameter("@prgDateEnd", program.PrgDateEnd),
               new Parameter("@prgDeliveryTimeDefault", program.PrgDeliveryTimeDefault),
               new Parameter("@prgPickUpTimeDefault", program.PrgPickUpTimeDefault),
               new Parameter("@parentId", program.ParentId),
               new Parameter("@prgRollUpBilling", program.PrgRollUpBilling),
               new Parameter("@prgRollUpBillingJobFieldId", program.PrgRollUpBillingJobFieldId),
               new Parameter("@prgElectronicInvoice", program.PrgElectronicInvoice),
            };
            return parameters;
        }

        public static IList<TreeModel> GetProgramTree(ActiveUser activeUser, long orgId, long? parentId, bool isCustNode)
        {
            var parameters = new[]
          {
                new Parameter("@orgId", orgId)
                ,new Parameter("@parentId", parentId)
                ,new Parameter("@isCustNode", isCustNode)
                ,new Parameter("@entity", EntitiesAlias.Program.ToString()),
                 new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId)

            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetProgramTreeViewData, parameters, storedProcedure: true);
            return result;
        }

        public static IList<TreeModel> GetProgramCopyTree(ActiveUser activeUser, long programId, long? parentId, bool isCustNode, bool isSource)
        {
            var parameters = new[]
          {
                 new Parameter("@userId", activeUser.UserId)
                ,new Parameter("@isSource", isSource)
                ,new Parameter("@programId", programId)
                ,new Parameter("@orgId", activeUser.OrganizationId)
                ,new Parameter("@parentId", parentId)
                ,new Parameter("@isCustNode", isCustNode)
                ,new Parameter("@entity", EntitiesAlias.Program.ToString())

            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeModel>(StoredProceduresConstant.GetProgramCopyTreeViewData, parameters, storedProcedure: true);
            return result;
        }

        public static async Task<bool> CopyPPPModel(CopyPPPModel copyPPPModel, ActiveUser activeUser)
        {
            List<CopyPPPDbModel> dbModel = new List<CopyPPPDbModel>();

            dbModel.Add(new CopyPPPDbModel
            {
                RecordId = copyPPPModel.RecordId,
                ConfigurationIds = copyPPPModel.ConfigurationIds == null ? string.Empty : string.Join(",", copyPPPModel.ConfigurationIds),
                ToPPPIds = copyPPPModel.ToPPPIds == null ? string.Empty : string.Join(",", copyPPPModel.ToPPPIds),
                ParentId = 0,
                SelectAll = copyPPPModel.SelectAll
            });


            RecursiveDbModel(copyPPPModel.CopyPPPModelSub, copyPPPModel.RecordId, dbModel);

            var parameters = new[]
            {
                 new Parameter("@udtCopyPPPModel", GetCopyPPPDbModelAsDatatable(dbModel) )
                ,new Parameter("@createdBy", activeUser.UserName)
                ,new Parameter("@OrgId", activeUser.OrganizationId)
                ,new Parameter("@userId", activeUser.UserId)
                ,new Parameter("@langCode", activeUser.LangCode)

            };
            var result = false;
            await Task.Run(() =>
            {
                result = SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UdtCopyPPPModel, parameters, storedProcedure: true);
            });
            return result;
        }

        public static void RecursiveDbModel(List<CopyPPPModel> copyPPPModel, long? parentId, List<CopyPPPDbModel> dbModel)
        {
            if (copyPPPModel != null)
            {
                foreach (var copyModel in copyPPPModel)
                {
                    dbModel.Add(new CopyPPPDbModel
                    {
                        RecordId = copyModel.RecordId,
                        ConfigurationIds = copyModel.ConfigurationIds == null ? string.Empty : string.Join(",", copyModel.ConfigurationIds),
                        ToPPPIds = copyModel.ToPPPIds == null ? string.Empty : string.Join(",", copyModel.ToPPPIds),
                        ParentId = parentId,
                        SelectAll = copyModel.SelectAll
                    });

                    RecursiveDbModel(copyModel.CopyPPPModelSub, copyModel.RecordId, dbModel);
                }
            }
        }

        private static DataTable GetCopyPPPDbModelAsDatatable(List<CopyPPPDbModel> dbModel)
        {
            using (DataTable dtCopyPPPModel = new DataTable("CopyPPPModel"))
            {
                //dtSecurityIds.Locale = System.Globalization.CultureInfo.InvariantCulture;
                dtCopyPPPModel.Columns.Add("RecordId", type: typeof(long));
                dtCopyPPPModel.Columns.Add("SelectAll", type: typeof(bool));
                dtCopyPPPModel.Columns.Add("ConfigurationIds", type: typeof(string));
                dtCopyPPPModel.Columns.Add("ToPPPIds", type: typeof(string));
                dtCopyPPPModel.Columns.Add("ParentId", type: typeof(long));
                foreach (var item in dbModel)
                {
                    dtCopyPPPModel.Rows.Add(item.RecordId, item.SelectAll, item.ConfigurationIds, item.ToPPPIds, item.ParentId);
                }

                return dtCopyPPPModel;
            }
        }

        public static List<Entities.Program.Program> GetProgramsByCustomer(long custId)
        {
            var parameters = new[]
        {
                new Parameter("@CustId", custId)

            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.Program>(StoredProceduresConstant.GetProgramsByCustomer, parameters, storedProcedure: true);
            return result;
        }

    }
}