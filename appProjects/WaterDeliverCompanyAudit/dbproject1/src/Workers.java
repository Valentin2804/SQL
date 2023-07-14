import javax.xml.transform.Result;
import java.sql.*;

public class Workers {
    private static final String INVALID_EGN =
            """
                        SELECT COUNT(*) AS COUNTER
                        FROM workers
                        WHERE workers.egn = ?;
            """;

    private static final String INSERT_INTO = "INSERT INTO workers (name, egn, salaryPerOrder, endContract) VALUES (?, ?, ?, ?);";

    private static final String GET_WORKERS = "SELECT name, egn, salaryPerOrder FROM workers;";

    private static final String EDIT_WORKER = "UPDATE workers SET name = ?, egn = ?, salaryPerOrder = ?, endContract = ? WHERE egn = ?";

    private static final String GET_THE_NUMBER_OF_ALL_TIME_CONTRACTS = """
            SELECT COUNT(*) AS contracts
            FROM WorkersHistory
            WHERE WorkersHistory.egn = ?;
            """;

    public Workers(String name, String egn, Integer salary, Date date) throws ClassNotFoundException, SQLException {

        if(name.isEmpty() || salary <= 0)
        {
            throw  new IllegalArgumentException("Invalid name or salary provided");
        }

        try (Connection con = JDBCHelper.getConnection()){

            PreparedStatement query0 = con.prepareStatement(INVALID_EGN);
            query0.setString(1, egn);
            ResultSet result = query0.executeQuery();

            if(result.next())
            {
                int count = result.getInt("COUNTER");
                if (count == 1)
                {
                    throw  new IllegalArgumentException("Invalid EGN provided, this already exists");
                }
            }

            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setString(1, name);
                query.setString(2, egn);
                query.setInt(3, salary);
                query.setDate(4, date);
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

    public static void getWorkers() throws ClassNotFoundException, SQLException
    {
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();

            ResultSet resultSet = query.executeQuery(GET_WORKERS);

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

    public static void editWorker(String egn, String name, String egn1, Integer money, Date date)
            throws ClassNotFoundException, SQLException
    {
        try (Connection con = JDBCHelper.getConnection()){
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(EDIT_WORKER);
                query.setString(1, name);
                query.setString(2, egn);
                query.setInt(3, money);
                query.setDate(4, date);
                query.setString(5, egn1);
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

    public static void getNumOfAllTimeContractsOfAGivenWorker(String egn) throws SQLException, ClassNotFoundException
    {
        try (Connection con = JDBCHelper.getConnection()) {

            con.setAutoCommit(false);


            PreparedStatement query = con.prepareStatement(GET_THE_NUMBER_OF_ALL_TIME_CONTRACTS);
            query.setString(1, egn);
            ResultSet resultSet = query.executeQuery();

            con.setAutoCommit(true);

            if(resultSet.next())
            {
                System.out.println(resultSet.getInt("contracts"));
            }

        }
    }
}
