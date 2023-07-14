import java.sql.*;

public class Orders {

    private static final String INVALID_ADDRESS = """
            SELECT COUNT(*) AS COUNTER
                                        FROM market
                                        WHERE market.address = ?;
            """;

    private static final String MARKET_ID =
            """
                    SELECT market.id AS MARKET 
                                                FROM market 
                                                WHERE market.address = ?;
                    """;

    private static final String INVALID_WORKER = """
            SELECT COUNT(*) AS COUNTER
                                        FROM workers
                                        WHERE workers.egn = ?;
            """;

    private static final String WORKER_ID =
            """
                    SELECT workers.id AS WORKER 
                                                FROM workers 
                                                WHERE workers.egn = ?;
                    """;

    private static final String INSERT_INTO = "INSERT INTO Orders (workerId, marketId) VALUES (?, ?);";

    private static final String GET_ACTIVE_ORDERS =
            """
                            SELECT market.name, market.address, workers.name, workers.egn
                            FROM Orders
                            LEFT JOIN market
                            ON market.id = Orders.marketId
                            LEFT JOIN workers
                            ON workers.id = Orders.workerId;
                    """;

    private static final String EDIT_ORDER = "UPDATE Orders SET workerId = ? WHERE workerId = ? AND addressId = ?";

    public Orders(String egn, String address) throws ClassNotFoundException, SQLException {
        try (Connection con = JDBCHelper.getConnection()){

            PreparedStatement query0 = con.prepareStatement(INVALID_ADDRESS);
            query0.setString(1, address);
            ResultSet result = query0.executeQuery();

            if(result.next())
            {
                int count = result.getInt("COUNTER");
                if (count == 0)
                {
                    throw  new IllegalArgumentException("Invalid address provided, market with this address does not exists");
                }
            }

            PreparedStatement query2 = con.prepareStatement(INVALID_WORKER);
            query2.setString(1, egn);
            ResultSet result2 = query2.executeQuery();

            if(result2.next())
            {
                int count = result2.getInt("COUNTER");
                if (count == 0)
                {
                    throw  new IllegalArgumentException("Invalid worker provided, worker with this EGN does not exists");
                }
            }

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(MARKET_ID);
            query1.setString(1, address);
            ResultSet result1 = query1.executeQuery();

            int id_market = result1.getInt("MARKET");

            PreparedStatement query3 = con.prepareStatement(WORKER_ID);
            query3.setString(1, egn);
            ResultSet result3 = query3.executeQuery();

            int id_worker = result3.getInt("WORKER");

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setInt(1, id_worker);
                query.setInt(2, id_market);
                query.executeUpdate();
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public static void getOrders() throws ClassNotFoundException, SQLException
    {
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();

            ResultSet resultSet = query.executeQuery(GET_ACTIVE_ORDERS);

            while (resultSet.next())
            {
                System.out.println("\nOrder: ");
                System.out.println("Market name: " + resultSet.getString("name"));
                System.out.println("Market address: " + resultSet.getString("address"));
                System.out.println("Worker name: " + resultSet.getInt("name"));
                System.out.println("Worker egn: " + resultSet.getInt("egn"));
            }
        }
    }

    public static void editOrder(String oldEgn, String newEgn, String address)
            throws ClassNotFoundException, SQLException
    {
        try (Connection con = JDBCHelper.getConnection()){

            PreparedStatement query2 = con.prepareStatement(INVALID_WORKER);
            query2.setString(1, newEgn);
            ResultSet result2 = query2.executeQuery();

            if(result2.next())
            {
                int count = result2.getInt("COUNTER");
                if (count == 0)
                {
                    throw  new IllegalArgumentException("Invalid worker provided, worker with this EGN does not exists");
                }
            }

            con.setAutoCommit(false);

            PreparedStatement query1 = con.prepareStatement(MARKET_ID);
            query1.setString(1, address);
            ResultSet result1 = query1.executeQuery();

            int id_market = result1.getInt("MARKET");

            PreparedStatement query3 = con.prepareStatement(WORKER_ID);
            query3.setString(1, oldEgn);
            ResultSet result3 = query3.executeQuery();

            int id_worker = result3.getInt("WORKER");

            PreparedStatement query4 = con.prepareStatement(WORKER_ID);
            query4.setString(1, newEgn);
            ResultSet result4 = query4.executeQuery();

            int id_worker_new = result4.getInt("WORKER");

            try {
                PreparedStatement query = con.prepareStatement(EDIT_ORDER);
                query.setInt(1, id_worker_new);
                query.setInt(2, id_worker);
                query.setInt(3, id_market);
                query.executeUpdate();
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}
