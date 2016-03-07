using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;


namespace M4PL_Apln.Models
{
    // DXCOMMENT: Configure a data model (In this sample, we do this in file NorthwindDataProvider.cs. You would better create your custom file for a data model.)
    public static class NorthwindDataProvider {
        const string NorthwindDataContextKey = "DXNorthwindDataContext";

        public static NWDataContext DB = new NWDataContext();

        public static IEnumerable GetCustomers() {
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
    }
}