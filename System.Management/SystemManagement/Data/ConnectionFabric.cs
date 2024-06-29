using MySql.Data.MySqlClient;

namespace SystemManagement.Data
{
    public class ConnectionFabric
    {


        public MySqlConnection Connect()
        {
            MySqlConnection conexao;
            try
            {
                string conn = @"Persist Security info = false;
                                server = localhost;
                                database = menusystem;
                                uid = brunohoske;
                                port= 3307;
                                pwd =123";

                conexao = new MySqlConnection(conn);
                conexao.Open();
            }
            catch (MySqlException ex)
            {
                throw new Exception("Houve um erro ao se conectar com o banco de dados");
            }

            return conexao;
        }

        public MySqlDataReader ExecuteCommandReader(string sql)
        {
            try
            {
                var connection = Connect();
                using MySqlCommand cmd = new MySqlCommand(sql, connection);
                var reader = cmd.ExecuteReader();
                return reader;
            }
            catch (Exception ex)
            {
                return null;
            }


        }
        public void Execute(string sql, MySqlConnection connection) 
        {
            try
            {
                using var command = connection.CreateCommand();
                command.CommandText = sql;
                command.ExecuteNonQuery();
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void Execute(string sql)
        {
            try
            {
                using var connection = Connect();
                Execute(sql, connection);
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
