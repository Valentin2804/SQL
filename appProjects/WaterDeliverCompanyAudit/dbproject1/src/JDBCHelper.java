import java.sql.*;

public class JDBCHelper {
    private static final String CREATE_TABLE_MARKET =
            """
                    CREATE TABLE market(id INTEGER AUTO_INCREMENT PRIMARY KEY
                    					, name VARCHAR(50) NOT NULL
                                        , address VARCHAR(150) NOT NULL
                                        , moneyPerOrder INTEGER NOT NULL
                                        , endContract DATETIME NOT NULL);
            """;

    private static final String CREATE_TABLE_WORKERS =
            """ 
                    CREATE TABLE workers(id INTEGER AUTO_INCREMENT PRIMARY KEY
                    					, name VARCHAR(100) NOT NULL
                                        , egn CHAR(10) NOT NULL
                                        , salaryPerOrder INTEGER NOT NULL
                                        , endContract DATETIME NOT NULL);
                    """;

    private static final String CREATE_TABLE_ORDERS =
            """
                    CREATE TABLE Orders(id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
                    					, workerId INTEGER NOT NULL
                    					, marketId INTEGER NOT NULL
                    				
                    					, FOREIGN KEY (workerId) REFERENCES workers(id)
                    					, FOREIGN KEY (marketId) REFERENCES market(id));
                    """;

    private static final String CREATE_WORKERS_HISTORY =
            """
                    CREATE TABLE WorkersHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
                    							, beginDate DATETIME NOT NULL
                                                , endDate DATETIME
                    							, id INTEGER
                    							, name VARCHAR(50)
                    							, egn CHAR(10)
                                                , salaryPerOrder INTEGER
                                                , endContract DATETIME);
                    """;

    private static final  String CREATE_MARKETS_HISTORY =
            """
                    CREATE TABLE MarketsHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
                    							, beginDate DATETIME NOT NULL
                                                , endDate DATETIME
                    							, id INTEGER
                    							, name VARCHAR(50)\s
                    							, address VARCHAR(150)
                                                , moneyPerOrder INTEGER
                                                , endContract DATETIME);
                                               \s
                    """;

    private static final  String CREATE_ORDERS_HISTORY =
            """
                    CREATE TABLE OrdersHistory(UID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY
                    							, beginDate DATETIME NOT NULL
                                                , endDate DATETIME
                    							, id INTEGER
                    							, marketId INTEGER
                    							, workerId INTEGER);
                                              \s
                    """;



    private static final  String CREATE_MARKETS_INSERT_TRIGGER =
            """
                    CREATE TRIGGER MarketInsert AFTER INSERT ON market\s
                    FOR EACH ROW BEGIN
                    INSERT INTO MarketsHistory (beginDate, endDate, id, name, address, moneyPerOrder, endContract)
                    VALUES(NOW(), null, NEW.id, NEW.name, NEW.address, NEW.moneyPerOrder, NEW.endContract);
                    END
                    """;
    private static final  String CREATE_MARKETS_UPDATE_TRIGGER =
            """
                    CREATE TRIGGER MarketUpdate AFTER Update ON market\s
                    FOR EACH ROW BEGIN
                                        
                    UPDATE MarketsHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                                        
                    INSERT INTO MarketsHistory (beginDate, endDate, id, name, address, moneyPerOrder, endContract)
                    VALUES(NOW(), null, NEW.id, NEW.name, NEW.address, NEW.moneyPerOrder, NEW.endContract);
                    END
                    """;
    private static final  String CREATE_MARKETS_DELETE_TRIGGER =
            """
                    CREATE TRIGGER MarketsDelete AFTER Delete ON market\s
                    FOR EACH ROW BEGIN
                    UPDATE MarketsHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                    END
                    """;
    private static final  String CREATE_WORKERS_INSERT_TRIGGER =
            """
                    CREATE TRIGGER WorkersInsert AFTER INSERT ON workers\s
                    FOR EACH ROW BEGIN
                    INSERT INTO WorkersHistory (beginDate, endDate, id, name, egn, salaryPerOrder, endContract)
                    VALUES(NOW(), null, NEW.id, NEW.name, NEW.egn, NEW.salaryPerOrder, NEW.endContract);
                    END
                    """;
    private static final  String CREATE_WORKERS_UPDATE_TRIGGER =
            """
                    CREATE TRIGGER WorkersUpdate AFTER Update ON workers\s
                    FOR EACH ROW BEGIN
                                        
                    UPDATE WorkersHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                                        
                    INSERT INTO WorkersHistory (beginDate, endDate, id, name, egn, salaryPerOrder, endContract)
                    VALUES(NOW(), null, NEW.id, NEW.name, NEW.egn, NEW.salaryPerOrder, NEW.endCOntract);
                    END
                    """;
    private static final  String CREATE_WORKERS_DELETE_TRIGGER =
            """
                    CREATE TRIGGER WorkersDelete AFTER Delete ON workers\s
                    FOR EACH ROW BEGIN
                    UPDATE WorkersHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                    END
                    """;
    private static final  String CREATE_ORDERS_INSERT_TRIGGER =
            """
                    CREATE TRIGGER OrdersInsert AFTER INSERT ON Orders\s
                    FOR EACH ROW BEGIN
                    INSERT INTO OrdersHistory (beginDate, endDate, id, marketId, workerId)
                    VALUES(NOW(), null, NEW.id, NEW.marketId, NEW.workerId);
                    END
                    """;
    private static final  String CREATE_ORDERS_UPDATE_TRIGGER =
            """
                    CREATE TRIGGER OrdersUpdate AFTER Update ON Orders\s
                    FOR EACH ROW BEGIN
                                        
                    UPDATE OrdersHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                                        
                    INSERT INTO OrdersHistory (beginDate, endDate, id, marketId, workerId)
                    VALUES(NOW(), null, NEW.id, NEW.marketId, NEW.workerId);
                    END
                    """;
    private static final  String CREATE_ORDERS_DELETE_TRIGGER =
            """
                    CREATE TRIGGER OrdersDelete AFTER Delete ON Orders\s
                    FOR EACH ROW BEGIN
                    UPDATE OrdersHistory SET endDate = NOW()
                    WHERE id = OLD.id AND endDate IS NULL;
                    END
                    """;

    private static final String CALCULATE_THE_PROFIT =
            """
                    SELECT SUM(MarketsHistory.moneyPerOrder - WorkersHistory.salaryPerOrder) AS profit
                    FROM OrdersHistory
                    LEFT JOIN MarketsHistory
                    ON MarketsHistory.id = OrdersHistory.marketId\s
                    AND MarketsHistory.beginDate <= OrdersHistory.endDate\s
                    AND MarketsHistory.endContract >= OrdersHistory.endDate
                    LEFT JOIN WorkersHistory
                    ON WorkersHistory.id = OrdersHistory.workerId\s
                    AND WorkersHistory.beginDate <= OrdersHistory.endDate\s
                    AND WorkersHistory.endContract >= OrdersHistory.endDate
                    WHERE OrdersHistory.endDate >= ? AND OrdersHistory.endDate <= ?;
                    """;


    private static final String DROP_MARKETS = "DROP TABLE market";
    private static final String DROP_WORKERS = "DROP TABLE workers";
    private static final String DROP_ORDERS = "DROP TABLE Orders";
    private static final String DROP_MARKETS_HISTORY = "DROP TABLE MarketsHistory";
    private static final String DROP_WORKERS_HISTORY = "DROP TABLE WorkersHistory";
    private static final String DROP_ORDERS_HISTORY = "DROP TABLE OrdersHistory";
    private static final String DROP_TRIGGER_MARKETS_INSERT = "DROP TRIGGER MarketInsert";

    private static final String DROP_TRIGGER_MARKETS_UPDATE = "DROP TRIGGER MarketUpdate";
    private static final String DROP_TRIGGER_MARKETS_DELETE = "DROP TRIGGER MarketsDelete";
    private static final String DROP_TRIGGER_WORKERS_INSERT = "DROP TRIGGER WorkersInsert";
    private static final String DROP_TRIGGER_WORKERS_UPDATE = "DROP TRIGGER WorkersUpdate";
    private static final String DROP_TRIGGER_WORKERS_DELETE = "DROP TRIGGER WorkersDelete";
    private static final String DROP_TRIGGER_ORDERS_INSERT = "DROP TRIGGER OrdersInsert";
    private static final String DROP_TRIGGER_ORDERS_UPDATE = "DROP TRIGGER ordersUpdate";
    private static final String DROP_TRIGGER_ORDERS_DELETE = "DROP TRIGGER OrdersDelete";

    private static final String GET_WORKERS_HISTORY = "SELECT * FROM WorkersHistory";

    private static final String GET_MARKETS_HISTORY = "SELECT * FROM MarketsHistory";

    private static final String GET_ORDERS_HISTORY = "SELECT * FROM OrdersHistory";


    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // инициализация на driver-а
        Class.forName("com.mysql.cj.jdbc.Driver");

        // създаване на connection string
        String connectionString = "jdbc:mysql://127.0.0.1:3306/waterDeliver?user=root&password=0000";

        // създаване на връзка към БД
        Connection con = DriverManager.getConnection(connectionString);

        return con;
    }

    public static void createDBStructure() throws SQLException, ClassNotFoundException {
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();

            query.execute(CREATE_TABLE_MARKET);
            query.execute(CREATE_TABLE_WORKERS);
            query.execute(CREATE_TABLE_ORDERS);
            query.execute(CREATE_MARKETS_HISTORY);
            query.execute(CREATE_WORKERS_HISTORY);
            query.execute(CREATE_ORDERS_HISTORY);
            query.execute(CREATE_MARKETS_INSERT_TRIGGER);
            query.execute(CREATE_MARKETS_UPDATE_TRIGGER);
            query.execute(CREATE_MARKETS_DELETE_TRIGGER);
            query.execute(CREATE_WORKERS_INSERT_TRIGGER);
            query.execute(CREATE_WORKERS_UPDATE_TRIGGER);
            query.execute(CREATE_WORKERS_DELETE_TRIGGER);
            query.execute(CREATE_ORDERS_INSERT_TRIGGER);
            query.execute(CREATE_ORDERS_UPDATE_TRIGGER);
            query.execute(CREATE_ORDERS_DELETE_TRIGGER);
        }
    }

    public static void dropDatabase()  throws SQLException, ClassNotFoundException{
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();

            query.executeUpdate(DROP_MARKETS);
            query.executeUpdate(DROP_WORKERS);
            query.executeUpdate(DROP_ORDERS);
            query.executeUpdate(DROP_MARKETS_HISTORY);
            query.executeUpdate(DROP_WORKERS_HISTORY);
            query.executeUpdate(DROP_ORDERS_HISTORY);
            query.executeUpdate(DROP_TRIGGER_MARKETS_UPDATE);
            query.executeUpdate(DROP_TRIGGER_MARKETS_INSERT);
            query.executeUpdate(DROP_TRIGGER_MARKETS_DELETE);
            query.executeUpdate(DROP_TRIGGER_WORKERS_INSERT);
            query.executeUpdate(DROP_TRIGGER_WORKERS_UPDATE);
            query.executeUpdate(DROP_TRIGGER_WORKERS_DELETE);
            query.executeUpdate(DROP_TRIGGER_ORDERS_INSERT);
            query.executeUpdate(DROP_TRIGGER_ORDERS_UPDATE);
            query.executeUpdate(DROP_TRIGGER_ORDERS_DELETE);
        }
    }


    public static int getProfitBetweenTwoDays(Date date, Date date1) throws  SQLException, ClassNotFoundException
    {
        try (Connection connection = JDBCHelper.getConnection()){
            connection.setAutoCommit(false);
            PreparedStatement query = connection.prepareStatement(CALCULATE_THE_PROFIT);
            query.setDate(1, date);
            query.setDate(2, date1);

            ResultSet result2 = query.executeQuery();
            connection.setAutoCommit(true);

            return result2.getInt("profit");
        }
    }

    public static void getWorkersHistory() throws ClassNotFoundException, SQLException
    {
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();

            ResultSet resultSet = query.executeQuery(GET_WORKERS_HISTORY);

            while (resultSet.next())
            {
                System.out.println("\nWorker: ");
                System.out.println("Name " + resultSet.getString("name"));
                System.out.println("EGN " + resultSet.getString("egn"));
                System.out.println("Salary per order: " + resultSet.getInt("salaryPerOrder"));
                System.out.println("End contract: " + resultSet.getDate("endContract"));
            }
        }
    }
}
