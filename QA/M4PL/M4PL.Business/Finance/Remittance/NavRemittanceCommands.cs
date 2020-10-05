#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Finance.Remittance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Document;
using M4PL.Entities.Support;
using M4PL.Business.Finance.VendorLedger;
using System.Data;
using M4PL.Entities.Finance.PurchaseOrder;
using System.IO;

namespace M4PL.Business.Finance.Remittance
{
	public class NavRemittanceCommands : BaseCommands<NavRemittance>, INavRemittanceCommands
	{
		public int Delete(long id)
		{
			throw new NotImplementedException();
		}

		public IList<IdRefLangName> Delete(List<long> ids, int statusId)
		{
			throw new NotImplementedException();
		}

		public NavRemittance Get(long id)
		{
			throw new NotImplementedException();
		}

		public IList<NavRemittance> GetPagedData(PagedDataInfo pagedDataInfo)
		{
			throw new NotImplementedException();
		}

		public DocumentData GetPostedInvoiceByCheckNumber(string checkNumber)
		{
			DocumentData documentData = null;
			NavVendorLedgerCommands navVendorLedgerCommands = new NavVendorLedgerCommands();
			var result = navVendorLedgerCommands.GetVendorCheckedInvoice(checkNumber);
			if (result?.Count > 0)
			{
				using (DataTable tblPostedInvoice = GetPostedInvoiceDataTable(result))
				{
					if (tblPostedInvoice != null && tblPostedInvoice.Rows.Count > 0)
					{
						documentData = new DocumentData();
						using (MemoryStream memoryStream = new MemoryStream())
						{
							using (StreamWriter writer = new StreamWriter(memoryStream))
							{
								WriteDataTable(tblPostedInvoice, writer, true);
							}

							documentData.DocumentContent = memoryStream.ToArray();
							documentData.DocumentName = string.Format("PostedInvoice_CheckNo_{0}.csv", checkNumber);
							documentData.ContentType = "text/csv";
							documentData.DocumentExtension = ".csv";
						}
					}
				}
			}

			return documentData;
		}

		public NavRemittance Patch(NavRemittance entity)
		{
			throw new NotImplementedException();
		}

		public NavRemittance Post(NavRemittance entity)
		{
			throw new NotImplementedException();
		}

		public NavRemittance Put(NavRemittance entity)
		{
			throw new NotImplementedException();
		}
		public static DataTable GetPostedInvoiceDataTable(List<CheckPostedInvoice> postedInvoiceList)
		{
			using (DataTable tblCheckPostedInvoice = new DataTable())
			{
				tblCheckPostedInvoice.Columns.Add("No");
				tblCheckPostedInvoice.Columns.Add("M4PL Job ID");
				tblCheckPostedInvoice.Columns.Add("Order Number");
				tblCheckPostedInvoice.Columns.Add("Document Date");
				tblCheckPostedInvoice.Columns.Add("Amount");
				if (postedInvoiceList?.Count > 0)
				{
					foreach (var postedInvoice in postedInvoiceList)
					{
						var row = tblCheckPostedInvoice.NewRow();
						row["No"] = postedInvoice.No;
						row["M4PL Job ID"] = postedInvoice.M4PL_JobId;
						row["Order Number"] = postedInvoice.Vendor_Order_No;
						row["Document Date"] = postedInvoice.Document_Date;
						row["Amount"] = postedInvoice.Amount;
						tblCheckPostedInvoice.Rows.Add(row);
						tblCheckPostedInvoice.AcceptChanges();
					}
				}

				return tblCheckPostedInvoice;
			}
		}

		public static void WriteDataTable(DataTable sourceTable, TextWriter writer, bool includeHeaders)
		{
			if (includeHeaders)
			{
				IEnumerable<String> headerValues = sourceTable.Columns
					.OfType<DataColumn>()
					.Select(column => QuoteValue(column.ColumnName));

				writer.WriteLine(String.Join(",", headerValues));
			}

			IEnumerable<String> items = null;

			foreach (DataRow row in sourceTable.Rows)
			{
				items = row.ItemArray.Select(o => QuoteValue(o?.ToString() ?? String.Empty));
				writer.WriteLine(String.Join(",", items));
			}

			writer.Flush();
		}

		private static string QuoteValue(string value)
		{
			return String.Concat("\"",
			value.Replace("\"", "\"\""), "\"");
		}
	}
}
