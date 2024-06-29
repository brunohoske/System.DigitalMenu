using MySql.Data.MySqlClient;
using SystemManagement.Data;
using SystemManagement.Models;

namespace SystemManagement.Dao
{
    public class ProductDao : BaseDao
    {
        ConnectionFabric factory = new ConnectionFabric();
        public List<Product> GetProducts(Store store)
        {
            List<Product> products = new List<Product>();
            try
            {

                var reader = factory.ExecuteCommandReader($"SELECT * FROM PRODUCTS WHERE CNPJ = {store.Cnpj}");
                while (reader.Read())
                {
                    Product p = new Product();

                    p.Id = reader.GetInt32("IdProduct");
                    p.Name = reader["Product_name"].ToString();
                    p.Value = Convert.ToInt32(reader["PRICE"]);
                    p.Description = reader["DESCRIPTION"].ToString();
                    p.Store = new Store() { Name = "McDonalds", Cnpj = reader["CNPJ"].ToString() };


                    products.Add(p);
                }

                return products;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public Product GetProductFromId(int id)
        {
            var reader = factory.ExecuteCommandReader($"SELECT * FROM PRODUCTS WHERE IDPRODUCT = {id}");
            Product product = new Product();
            while (reader.Read())
            {
                product.Id = Convert.ToInt32(reader["idproduct"].ToString());
                product.Name = reader["Product_Name"].ToString();
                product.Value = Convert.ToInt32(reader["price"]);
                product.Description = reader["description"].ToString();
                product.Store = new Store() { Cnpj = reader["cnpj"].ToString() };
                
            }

            return product;
        }

    }
}
