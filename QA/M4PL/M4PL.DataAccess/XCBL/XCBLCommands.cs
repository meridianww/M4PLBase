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
    public class XCBLCommands
    {
        public static long InsertxCBLDetailsInDB(XCBLSummaryHeaderModel xCBLSummaryHeaderModel)
        {
            try
            {
                long result = 0;
                var uttSummaryHeader = new List<SummaryHeader> { xCBLSummaryHeaderModel.SummaryHeader }.ToDataTable();
                uttSummaryHeader.RemoveColumnsFromDataTable(new List<string> { "SummaryHeaderId" });

                var uttAddress = xCBLSummaryHeaderModel.Address.ToDataTable();
                uttAddress.RemoveColumnsFromDataTable(new List<string> { "AddressId" });

                var uttCustomAttribute = new List<CustomAttribute> { xCBLSummaryHeaderModel.CustomAttribute }.ToDataTable();
                uttCustomAttribute.RemoveColumnsFromDataTable(new List<string> { "CustomAttributeId" });

                var uttUserDefinedField = new List<UserDefinedField> { xCBLSummaryHeaderModel.UserDefinedField }.ToDataTable();
                uttUserDefinedField.RemoveColumnsFromDataTable(new List<string> { "UserDefinedFieldId" });

				var uttLineDetail = xCBLSummaryHeaderModel.LineDetail.ToDataTable();
				uttLineDetail.RemoveColumnsFromDataTable(new List<string> { "LineDetailId" });

				var parameters = new List<Parameter>
            {
                new Parameter("@UttSummaryHeader",uttSummaryHeader, "xcbl.UttSummaryHeader"),
                new Parameter("@UttAddress", uttAddress,"xcbl.UttAddress"),
                new Parameter("@UttCustomAttribute",uttCustomAttribute ,"xcbl.UttCustomAttribute"),
                new Parameter("@UttUserDefinedField",uttUserDefinedField, "xcbl.UttUserDefinedField"),
				new Parameter("@UttLineDetail",uttLineDetail, "xcbl.UttLineDetail")
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
    }
}
