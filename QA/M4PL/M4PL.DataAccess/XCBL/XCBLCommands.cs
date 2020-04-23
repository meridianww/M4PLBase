using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _logger = M4PL.DataAccess.Logger.ErrorLogger;

namespace M4PL.DataAccess.XCBL
{
    public class XCBLCommands : BaseCommands<XCBLSummaryHeaderModel>
    {
        public static long InsertxCBLDetailsInDB(XCBLSummaryHeaderModel xCBLSummaryHeaderModel)
        {
            try
            {
                long result = 0;
                var uttSummaryHeader = new List<SummaryHeader> { xCBLSummaryHeaderModel.SummaryHeader }.ToDataTable();
                uttSummaryHeader.RemoveColumnsFromDataTable(new List<string> { "SummaryHeaderId","Action", "TrailerNumber" });

                var uttAddress = xCBLSummaryHeaderModel.Address.ToDataTable();
                uttAddress.RemoveColumnsFromDataTable(new List<string> { "AddressId" });

                var uttCustomAttribute = new List<CustomAttribute> { xCBLSummaryHeaderModel.CustomAttribute }.ToDataTable();
                uttCustomAttribute.RemoveColumnsFromDataTable(new List<string> { "CustomAttributeId" });

                var uttUserDefinedField = new List<UserDefinedField> { xCBLSummaryHeaderModel.UserDefinedField }.ToDataTable();
                uttUserDefinedField.RemoveColumnsFromDataTable(new List<string> { "UserDefinedFieldId" });

				var uttLineDetail = xCBLSummaryHeaderModel.LineDetail.ToDataTable();
				uttLineDetail.RemoveColumnsFromDataTable(new List<string> { "LineDetailId" });

                var uttGatewayIds = xCBLSummaryHeaderModel.CopiedGatewayIds.ToDataTable();

                var parameters = new List<Parameter>
            {
                new Parameter("@UttSummaryHeader",uttSummaryHeader, "xcbl.UttSummaryHeader"),
                new Parameter("@UttAddress", uttAddress,"xcbl.UttAddress"),
                new Parameter("@UttCustomAttribute",uttCustomAttribute ,"xcbl.UttCustomAttribute"),
                new Parameter("@UttUserDefinedField",uttUserDefinedField, "xcbl.UttUserDefinedField"),
				new Parameter("@UttLineDetail",uttLineDetail, "xcbl.UttLineDetail"),
                new Parameter("@UttCopiedGatewayIds",uttGatewayIds, "dbo.uttIDList")
                
            };

                result = SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.InsertXcblData, parameters.ToArray(), false, true);
                return result;
            }
            catch(Exception ex)
            {
                _logger.Log(ex, "Exception occured in method PostXCBLSummaryHeader. Exception :" + ex.Message,"XCBL POST", Utilities.Logger.LogType.Error);
                return -1;
            }
        }

        public static XCBLSummaryHeaderModel GetXCBLDataByCustomerReferenceNo(ActiveUser activeUser, string customerReferenceNo)
        {
            try
            {
                XCBLSummaryHeaderModel xCBLSummaryHeaderModel = null;
                SetCollection sets = new SetCollection();
                sets.AddSet<SummaryHeader>("SummaryHeader");
                sets.AddSet<Address>("Address");
                sets.AddSet<UserDefinedField>("UserDefinedField");
                sets.AddSet<CustomAttribute>("CustomAttribute");
                sets.AddSet<LineDetail>("LineDetail");


                   var parameters = new List<Parameter>
                   {
                       new Parameter("@CustomerReferenceNo", customerReferenceNo),
                   };
               SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetXCBLDataBySummaryHeaderId);
                var xcblSummaryHeader = sets.GetSet<SummaryHeader>("SummaryHeader");
                var xcblAddress = sets.GetSet<Address>("Address");
                var xcblUserDefinedField = sets.GetSet<UserDefinedField>("UserDefinedField");
                var xcblCustomAttribute = sets.GetSet<CustomAttribute>("CustomAttribute");
                var xcblLineDetail = sets.GetSet<LineDetail>("LineDetail");

                if (xcblSummaryHeader !=null && xcblSummaryHeader.Count > 0)
                {
                    xCBLSummaryHeaderModel = new XCBLSummaryHeaderModel();
                    xCBLSummaryHeaderModel.SummaryHeader = xcblSummaryHeader.First();
                }

                if(xcblAddress!=null && xcblAddress.Count > 0)
                {
                    xCBLSummaryHeaderModel.Address = xcblAddress;
                }

                if (xcblUserDefinedField != null && xcblUserDefinedField.Count > 0)
                {
                    xCBLSummaryHeaderModel.UserDefinedField = xcblUserDefinedField.First();
                }

                if (xcblCustomAttribute != null && xcblCustomAttribute.Count > 0)
                {
                    xCBLSummaryHeaderModel.CustomAttribute = xcblCustomAttribute.First();
                }

                if (xcblLineDetail != null && xcblLineDetail.Count > 0)
                {
                    xCBLSummaryHeaderModel.LineDetail = xcblLineDetail;
                }

                return xCBLSummaryHeaderModel;
            }
            catch (Exception ex)
            {
                _logger.Log(ex, "Exception occured in method GetXCBLDataBySummaryHeaderId. Exception :" + ex.Message, "XCBL POST", Utilities.Logger.LogType.Error);
                return null;
            }
        }
    }
}
