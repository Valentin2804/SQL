import java.sql.*;
import java.time.LocalDateTime;

public class Market {

    private static final String INSERT_INTO = "INSERT INTO market (name, address, moneyPerOrder, endContract) VALUES (?, ?, ?, ?);";

    private static final String GET_MARKET = "SELECT name, address, moneyPerOrder FROM MarketsHistory;";

    private static final String EDIT_MARKET = "UPDATE market SET name = ?, address = ?, moneyPerOrder = ?, endContract = ? WHERE address = ?";

    public Market(String name, String address, Integer moneyPerOrder, Date date) throws ClassNotFoundException, SQLException {
        if(name.isEmpty() || address.isEmpty() || moneyPerOrder <= 0)
        {
            throw new IllegalArgumentException("Invalid market name or address provided");
        }

        try (Connection con = JDBCHelper.getConnection()){
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(INSERT_INTO);
                query.setString(1, name);
                query.setString(2, address);
                query.setInt(3, moneyPerOrder);
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

    public static void getMarket() throws ClassNotFoundException, SQLException
    {
        try (Connection connection = JDBCHelper.getConnection()) {
            Statement query = connection.createStatement();
            ResultSet resultSet = query.executeQuery(GET_MARKET);

            while (resultSet.next())
            {
                System.out.println("\nMarket: " + resultSet.getString("name"));
                System.out.println("Address: " + resultSet.getString("address"));
                System.out.println("Money per Order: " + resultSet.getInt("moneyPerOrder"));
                System.out.println("End contract: " + resultSet.getDate("endContract"));
            }
        }
    }

    public static void editMarket(String address, String name, String address1, Integer money, Date date)
            throws ClassNotFoundException, SQLException
    {
        try (Connection con = JDBCHelper.getConnection()){
            con.setAutoCommit(false);

            try {
                PreparedStatement query = con.prepareStatement(EDIT_MARKET);
                query.setString(1, name);
                query.setString(2, address);
                query.setInt(3, money);
                query.setDate(4, date);
                query.setString(5, address1);
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
