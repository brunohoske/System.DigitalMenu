using MySql.Data.MySqlClient;
using SystemManagement.Dao;
using SystemManagement.Data;
using SystemManagement.Models;

namespace SystemManagement.DAO
{
    public class OrderDao 

    {
        ConnectionFabric factory = new ConnectionFabric();

        public int GetOrderNumber(Store store)
        {
            int number = 0;
            try
            {
                var reader = factory.ExecuteCommandReader($"SELECT IDORDER FROM ORDERS WHERE CNPJ = {store.Cnpj} ORDER BY IDORDER DESC LIMIT 1");
                while (reader.Read())
                {
                    number = Convert.ToInt32(reader["IdOrder"]);
                }

                return number + 10;
            }
            
            catch (Exception e)
            {
                return 0;
            }

        }


        public void CreateOrder(Order order)
        {
            try
            {
                order.Id = GetOrderNumber(order.Store);
                string dt = order.Date.ToString("yyyy-MM-dd HH:mm:ss");

                using var connection = factory.Connect();
                using MySqlCommand command = connection.CreateCommand();
                command.CommandText = $"Insert into Orders(idorder,cnpj,total,order_date,check_number,order_active) Values(@idorder,@cnpj,@value,@order_date,@check_number,1 )";

                command.Parameters.AddWithValue("@idorder", order.Id);
                command.Parameters.AddWithValue("@cnpj", order.Store.Cnpj);
                command.Parameters.AddWithValue("@value",order.Value);
                command.Parameters.AddWithValue("@order_date", order.Date);
                command.Parameters.AddWithValue("@check_number", order.Table.TableNumber);

                command.ExecuteNonQuery();

                CreateOrderDetails(order);

            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao inserir Pedido");
            }
        }

        public void CreateOrderDetails(Order order)
        {
            using var connection = factory.Connect();
            using MySqlCommand command = connection.CreateCommand();

            for (int i = 0; i < order.Products.Count; i++)
            {

                command.CommandText = $"INSERT INTO order_details(idorder,cnpj,idproduct,item,check_number,price,order_date) VALUES(@idorder,@cnpj,@idproduct,{i + 1},@check_number,@value,@order_date)";


                command.Parameters.AddWithValue("@idorder", order.Id);
                command.Parameters.AddWithValue("@cnpj", order.Store.Cnpj);
                command.Parameters.AddWithValue("@idproduct", order.Products[i].Id);
                command.Parameters.AddWithValue("@value", order.Products[i].Value);
                command.Parameters.AddWithValue("@order_date", order.Date);
                command.Parameters.AddWithValue("@check_number", order.Table.TableNumber);

                command.ExecuteNonQuery();

            }
        }

        public List<Order> GetOrders(Store store)
        {
            List<Order> orders = new List<Order>();

            try
            {
                var reader = factory.ExecuteCommandReader($"SELECT * FROM ORDERS WHERE CNPJ = '{store.Cnpj}' AND ORDER_ACTIVE = 1");

                while (reader.Read())
                {
                    Order order = new Order();

                    order.Id = Convert.ToInt32(reader["idorder"]);
                    order.Products = GetOrderProduct(order);
                    order.Value = Convert.ToDouble(reader["total"]);
                    order.Table = new Table() { Store = store, TableNumber = Convert.ToInt32(reader["check_number"]) };
                    order.Date = Convert.ToDateTime(reader["order_date"]);
                    orders.Add(order);
                }

                return orders;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public List<Product> GetOrderProduct(Order order)
        {
            List<Product> products = new List<Product>();
            List<int> orderProducts = new List<int>();
            try
            {
              
                var reader = factory.ExecuteCommandReader($"SELECT idproduct FROM order_details where idorder = {order.Id}");
                while (reader.Read())
                {
                    orderProducts.Add(Convert.ToInt32(reader["idproduct"]));
                }

               foreach (int i in orderProducts)
                {
                    ProductDao productDao = new ProductDao();
                    products.Add(productDao.GetProductFromId(i));
                }
                
                return products;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        public List<Order> GetOrdersInTable(Store store, Table table)
        {
            List<Order> orders = new List<Order>();

            try
            {
                var reader = factory.ExecuteCommandReader($"SELECT * FROM ORDERS WHERE CNPJ = '{store.Cnpj}' AND ORDER_ACTIVE = 1 AND CHECK_NUMBER = {table.TableNumber}");

                while (reader.Read())
                {
                    Order order = new Order();

                    order.Id = Convert.ToInt32(reader["idorder"]);
                    order.Products = GetOrderProduct(order);
                    order.Value = Convert.ToDouble(reader["total"]);
                    order.Table = new Table() { Store = store, TableNumber = Convert.ToInt32(reader["check_number"]) };
                    order.Date = Convert.ToDateTime(reader["order_date"]);
                    orders.Add(order);
                }

                return orders;
            }
            catch (Exception e)
            {
                return null;
            }
        }




    }
}
