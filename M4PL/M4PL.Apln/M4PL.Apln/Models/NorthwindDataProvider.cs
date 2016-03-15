using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;


namespace M4PL_Apln.Models
{
    // DXCOMMENT: Configure a data model (In this sample, we do this in file NorthwindDataProvider.cs. You would better create your custom file for a data model.)
    public static class NorthwindDataProvider
    {
        const string NorthwindDataContextKey = "DXNorthwindDataContext";

        public static NWDataContext DB = new NWDataContext();

        public static IEnumerable GetCustomers()
        {
            var daa = DB.Employees.ToList();
            return from customer in DB.Employees select customer;
        }

        public static IEnumerable GetOrders(int employeeID)
        {
            var query = from order in DB.Orders
                        where order.EmployeeID == employeeID
                        join order_detail in DB.Order_Details on order.OrderID equals order_detail.OrderID
                        join customer in DB.Customers on order.CustomerID equals customer.CustomerID
                        select new
                        {
                            order.OrderID,
                            order.OrderDate,
                            order.ShipName,
                            order.ShipCountry,
                            order.ShipCity,
                            order.ShipAddress,
                            order.ShippedDate,
                            order_detail.Quantity,
                            order_detail.UnitPrice,
                            customer.CustomerID,
                            customer.ContactName,
                            customer.CompanyName,
                            customer.City,
                            customer.Address,
                            customer.Phone,
                            customer.Fax
                        };
            return query.ToList();
        }

        internal static AllReports GetAllReports()
        {
            return new AllReports(AreaReportData(), BarReportData(), PieReportData());
        }

        static List<AreaReportData> AreaReportData()
        {
            List<AreaReportData> list = new List<AreaReportData>();
            list.Add(new AreaReportData { Population = 240, year = 1950 });
            list.Add(new AreaReportData { Population = 340, year = 1975 });
            list.Add(new AreaReportData { Population = 440, year = 1990 });
            list.Add(new AreaReportData { Population = 540, year = 2020 });
            list.Add(new AreaReportData { Population = 740, year = 2050 });
            return list;
        }

        static List<BarReportData> BarReportData()
        {
            string[] states = new string[] { "Nepal", "India", "Pakistan", "Bangladesh", "Sri Lanka" };
            string[] years = new string[] { "2008", "2011", "2014", "2017" };
            Dictionary<string, IList<double>> values = new Dictionary<string, IList<double>>();
            values.Add(years[0], new double[] { 423.721, 178.719, 308.845, 348.555, 160.274 });
            values.Add(years[1], new double[] { 476.851, 195.769, 335.793, 374.771, 182.373 });
            values.Add(years[2], new double[] { 508.964, 207.211, 302.556, 408.268, 201.797 });
            values.Add(years[3], new double[] { 528.104, 227.971, 372.776, 418.358, 211.927 });

            List<BarReportData> result = new List<BarReportData>();
            foreach (string year in years)
                for (int i = 0; i < states.Length; i++)
                    result.Add(new BarReportData(states[i], year, values[year][i]));
            return result;
        }

        static List<PieReportData> PieReportData()
        {
            return new List<PieReportData>(){
                new PieReportData("Russia", 17.0752),
                new PieReportData("Canada", 9.98467),
                new PieReportData("USA", 9.63142),
                new PieReportData("China", 9.59696),
                new PieReportData("Brazil", 8.511965),
                new PieReportData("Australia", 7.68685),
                new PieReportData("India", 3.28759),
                new PieReportData("Others", 81.2)
            };
        }
    }

    [Serializable]
    public class AllReports
    {
        public List<AreaReportData> AreaChart { get; set; }
        public List<BarReportData> BarChart { get; set; }
        public List<PieReportData> PieChart { get; set; }

        public AllReports(List<AreaReportData> _AreaChart, List<BarReportData> _BarChart, List<PieReportData> _PieChart)
        {
            this.AreaChart = _AreaChart;
            this.BarChart = _BarChart;
            this.PieChart = _PieChart;
        }
    }

    [Serializable]
    public class AreaReportData
    {
        public int year { get; set; }
        public int Population { get; set; }
    }

    [Serializable]
    public class BarReportData
    {
        public string State { get; set; }
        public string Year { get; set; }
        public double Product { get; set; }

        public BarReportData(string state, string year, double product)
        {
            this.State = state;
            this.Year = year;
            this.Product = product;
        }
    }

    [Serializable]
    public class PieReportData
    {
        public string Name { get; set; }
        public double Area { get; set; }

        public PieReportData(string name, double area)
        {
            this.Name = name;
            this.Area = area;
        }
    }
}